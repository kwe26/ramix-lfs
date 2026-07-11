import 'package:path/path.dart';
import 'package:rx_package_manager/rx_package_manager.dart';
import 'dart:io';

import 'package:toml/toml.dart';

Future<void> run(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
}) async {
  print("> $executable ${arguments.join(" ")}");

  final proc = await Process.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    environment: environment
  );

  final stdoutFuture = stdout.addStream(proc.stdout);
  final stderrFuture = stderr.addStream(proc.stderr);

  final code = await proc.exitCode;

  await stdoutFuture;
  await stderrFuture;

  if (code != 0) {
    throw Exception("$executable failed with exit code $code");
  }
}

Future<void> buildScript(
  Map<String, dynamic> build,
  Directory projectDir,
  Directory rxbuild,
) async {
  final buildDir = Directory(join(rxbuild.path, "build"));
  final destDir = Directory(join(rxbuild.path, "dest"));

  if (rxbuild.existsSync()) {
    rxbuild.deleteSync(recursive: true);
  }

  buildDir.createSync(recursive: true);
  destDir.createSync(recursive: true);

  final script = build["script"];

  if (script == null) {
    throw Exception("script build system requires 'script' field.");
  }

  await run(
    script.toString(),
    replaceVars(
      build["args"] ?? [],
      destDir.absolute.path,
    ),
    workingDirectory: projectDir.path,
    environment: {
      "DESTDIR": destDir.absolute.path,
      "NPROC": Platform.numberOfProcessors.toString(),
    },
  );
}
Future<void> buildMake(
    Map<String, dynamic> build,
    Directory projectDir,
    Directory rxbuild,
) async {
    final buildDir = Directory(join(rxbuild.path, "build"));
    final destDir  = Directory(join(rxbuild.path, "dest"));

    if (rxbuild.existsSync()) {
        rxbuild.deleteSync(recursive: true);
    }

    buildDir.createSync(recursive: true);
    destDir.createSync(recursive: true);

    await run(
        "make",
        replaceVars(build["make"] ?? [], destDir.absolute.path),
        workingDirectory: projectDir.path,
    );

    await run(
        "make",
        [
            ...replaceVars(build["install"] ?? [], destDir.absolute.path),
        ],
        workingDirectory: projectDir.path,
    );
}

Future<void> main(List<String> args) async {
  String? root;
  String? manifestPath;
  String? buildPath;
  String? outputPath;

  final positional = <String>[];

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case "--root":
        root = args[++i];
        break;

      case "--manifest":
        manifestPath = args[++i];
        break;

      case "--build":
        buildPath = args[++i];
        break;

      case "--output":
        outputPath = args[++i];
        break;

      default:
        positional.add(args[i]);
    }
  }

  //
  // Compatibility mode
  //

  final projectDir = Directory(
    root ?? (positional.isEmpty ? Directory.current.path : positional.first),
  );

  buildPath ??= join(projectDir.path, "build.toml");
  manifestPath ??= join(projectDir.path, "manifest.toml");

  outputPath ??= join(projectDir.path, ".rxbuild");

  if (projectDir.existsSync()) {
    final config = TomlDocument.parse(File(buildPath).readAsStringSync());

    final userPkgManifest = TomlDocument.parse(
      File(manifestPath).readAsStringSync(),
    ).toMap();

    final rxbuild = Directory(outputPath);

    final buildDir = Directory(join(rxbuild.path, "build"));

    final destDir = Directory(join(rxbuild.path, "dest"));

    userManifestChecker(userPkgManifest);

    final build = config.toMap()["build"] as Map<String, dynamic>;

    switch (build['system']) {
      case "autotools":
        await buildAutotools(build, projectDir, rxbuild);

      case "make":
        await buildMake(build, projectDir, rxbuild);
      case "script":
        await buildScript(build, projectDir, rxbuild);
      default:
        throw Exception("Unknown Build system. rxpkg failed");
    }

    File manifest = await generatePackageManifest(
      userManifest: userPkgManifest,
      destDir: destDir,
      buildDir: buildDir,
    );

    await packageRx(
      buildDir: buildDir,
      destDir: destDir,
      manifest: manifest,
      outputName:
          "${userPkgManifest["name"]}-${userPkgManifest["version"]}-${userPkgManifest["release"]}",
    );
  } else {
    stderr.writeln("rxbuild: directory not found");
    exit(1);
  }
}

Future<void> buildAutotools(
  Map<String, dynamic> build,
  Directory projectDir,
  Directory rxbuild,
) async {
  final buildDir = Directory(join(rxbuild.path, "build"));
  final destDir  = Directory(join(rxbuild.path, "dest"));

  if (rxbuild.existsSync()) {
    rxbuild.deleteSync(recursive: true);
  }

  buildDir.createSync(recursive: true);
  destDir.createSync(recursive: true);

  final outOfSource = build["out_of_source"] ?? true;

  final workingDir = outOfSource ? buildDir.path : projectDir.path;

  final configure = outOfSource
      ? relative(join(projectDir.path, "configure"), from: buildDir.path)
      : "./configure";

  await run(
    configure,
    replaceVars(build["configure"] ?? [], destDir.absolute.path),
    workingDirectory: workingDir,
  );

  await run(
    "make",
    replaceVars(build["make"] ?? [], destDir.absolute.path),
    workingDirectory: workingDir,
  );

  await run("make", [
    ...replaceVars(build["install"] ?? [], destDir.absolute.path),
    "install",
  ], workingDirectory: workingDir);
}

List<String> replaceVars(List<dynamic> args, String destDir) {
  return args.map((e) {
    return e
        .toString()
        .replaceAll(r'${DESTDIR}', destDir)
        .replaceAll(r'${NPROC}', Platform.numberOfProcessors.toString());
  }).toList();
}
