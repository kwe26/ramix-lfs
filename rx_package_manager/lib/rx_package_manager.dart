import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:toml/toml.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'package:rx_package_manager/sqlite.dart' as sql;

String version = "0.1";

Map<String, dynamic> packageManifest(String filePath) {
  final inputSteam = File(filePath).readAsBytesSync();

  final tarBytes = GZipDecoder().decodeBytes(inputSteam);
  final archive = TarDecoder().decodeBytes(tarBytes);

  final entry = archive.files.firstWhere(
    (f) => basename(f.name) == 'manifest.toml',
    orElse: () => throw StateError('manifest.toml not found'),
  );

  final manifest = String.fromCharCodes(entry.content as List<int>);

  var document = TomlDocument.parse(manifest);

  return document.toMap();
}

void userManifestChecker(Map<String, dynamic> manifest) {
  checkField<String>(manifest, "name", validator: (v) => v.trim().isNotEmpty);

  checkField<String>(
    manifest,
    "version",
    validator: (v) => v.trim().isNotEmpty,
  );

  checkField<int>(manifest, "release");

  checkField<String>(manifest, "arch", validator: (v) => v.trim().isNotEmpty);

  checkField<String>(
    manifest,
    "license",
    validator: (v) => v.trim().isNotEmpty,
  );

  checkField<String>(
    manifest,
    "description",
    validator: (v) => v.trim().isNotEmpty,
  );

  stdout.write("Checking depends..... ");

  final deps = manifest["depends"];

  if (deps == null) {
    stdout.writeln("None");
  } else if (deps is List) {
    stdout.writeln("${deps.length} dependency(s)");
  } else {
    throw Exception("'depends' must be an array.");
  }

  print("===> Manifest verified.");
}

void checkField<T>(
  Map<String, dynamic> manifest,
  String field, {
  bool Function(T value)? validator,
}) {
  stdout.write("Checking ${field.padRight(12, '.')} ");

  if (!manifest.containsKey(field)) {
    stdout.writeln("FAILED");
    throw Exception("manifest.toml: Missing required field '$field'.");
  }

  final value = manifest[field];

  if (value is! T) {
    stdout.writeln("FAILED");
    throw Exception(
      "manifest.toml: '$field' should be of type ${T.toString()}.",
    );
  }

  if (validator != null && !validator(value)) {
    stdout.writeln("FAILED");
    throw Exception("manifest.toml: '$field' is invalid.");
  }

  stdout.writeln(value);
}

Future<File> generatePackageManifest({
  required Map<String, dynamic> userManifest,
  required Directory destDir,
  required Directory buildDir,
}) async {
  stdout.writeln("Scanning installed files...");

  final buffer = StringBuffer();

  for (final entry in userManifest.entries) {
    final value = entry.value;

    if (value is List) {
      buffer.writeln("${entry.key} = [");

      for (final item in value) {
        buffer.writeln('    "$item",');
      }

      buffer.writeln("]");
      buffer.writeln();
    } else if (value is String) {
      buffer.writeln('${entry.key} = "$value"');
    } else {
      buffer.writeln("${entry.key} = $value");
    }
  }

  buffer.writeln();

  int fileCount = 0;
  int dirCount = 0;
  int linkCount = 0;

  await for (final entity in destDir.list(
    recursive: true,
    followLinks: false,
  )) {
    final rel = "/" + relative(entity.path, from: destDir.path);

    stdout.writeln(" • $rel");

    if (entity is File) {
      fileCount++;

      final stat = entity.statSync();

      final digest = await sha256.bind(entity.openRead()).first;

      final mode = (stat.mode & 0x1FF).toRadixString(8);

      buffer.writeln("[[entries]]");
      buffer.writeln('path = "$rel"');
      buffer.writeln('type = "file"');
      buffer.writeln("size = ${stat.size}");
      buffer.writeln('mode = "$mode"');
      buffer.writeln('sha256 = "$digest"');
      buffer.writeln();
    } else if (entity is Directory) {
      dirCount++;

      final stat = entity.statSync();
      final mode = (stat.mode & 0x1FF).toRadixString(8);

      buffer.writeln("[[entries]]");
      buffer.writeln('path = "$rel"');
      buffer.writeln('type = "directory"');
      buffer.writeln('mode = "$mode"');
      buffer.writeln();
    } else if (entity is Link) {
      linkCount++;

      final target = await entity.target();

      buffer.writeln("[[entries]]");
      buffer.writeln('path = "$rel"');
      buffer.writeln('type = "symlink"');
      buffer.writeln('target = "$target"');
      buffer.writeln();
    }
  }

  buffer.writeln("[package]");
  buffer.writeln("files = $fileCount");
  buffer.writeln("directories = $dirCount");
  buffer.writeln("symlinks = $linkCount");

  final manifest = File(join(buildDir.path, "manifest.toml"));

  await manifest.writeAsString(buffer.toString());

  stdout.writeln();
  stdout.writeln("Manifest generated.");
  stdout.writeln(" Files       : $fileCount");
  stdout.writeln(" Directories : $dirCount");
  stdout.writeln(" Symlinks    : $linkCount");
  stdout.writeln(" Output      : ${manifest.path}");

  return manifest;
}

Future<File> packageRx({
  required Directory buildDir,
  required Directory destDir,
  required File manifest,
  required String outputName,
}) async {
  stdout.writeln("Packaing $outputName.rx...");

  final archive = Archive();

  archive.addFile(
    ArchiveFile(
      "manifest.toml",
      manifest.lengthSync(),
      manifest.readAsBytesSync(),
    ),
  );

  await for (final entity in destDir.list(
    recursive: true,
    followLinks: false,
  )) {
    final rel = relative(entity.path, from: destDir.path);
    final archivePath = join("build", rel).replaceAll("\\", "/");

    if (entity is File) {
      archive.addFile(
        ArchiveFile(archivePath, entity.lengthSync(), entity.readAsBytesSync()),
      );
    } else if (entity is Directory) {
      archive.addFile(ArchiveFile.directory(archivePath));
    } else if (entity is Link) {
      archive.addFile(ArchiveFile.symlink(archivePath, await entity.target()));
    }
  }

  // TAR encode
  final tarBytes = TarEncoder().encode(archive);

  // GZip compress
  final gzBytes = GZipEncoder().encodeBytes(tarBytes);

  final output = File(join(buildDir.parent.path, "$outputName.rx"));

  output.writeAsBytesSync(gzBytes);

  stdout.writeln("Created ${output.path}");

  return output;
}

Future<void> extractPackageToCache({
  required String filePath,
  required String packageName,
  required String version,
}) async {
  final inputStream = File(filePath).readAsBytesSync();

  final tarBytes = GZipDecoder().decodeBytes(inputStream);
  final archive = TarDecoder().decodeBytes(tarBytes);

  // print("Entries: ${archive.files.length}");

  // for (final f in archive.files) {
  //   print("${f.name}  dir=${f.isDirectory} file=${f.isFile} symlink=${f.isSymbolicLink}");
  // }

  final cacheDir = Directory("/var/lib/rxpkg/cache/$packageName-$version");

  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }

  cacheDir.createSync(recursive: true);

  for (final entry in archive.files) {
    final outPath = join(cacheDir.path, entry.name);

    if (entry.isDirectory) {
      Directory(outPath).createSync(recursive: true);
    } else if (entry.isSymbolicLink) {
      Directory(dirname(outPath)).createSync(recursive: true);

      Link(outPath).createSync(entry.symbolicLink!, recursive: true);
    } else {
      Directory(dirname(outPath)).createSync(recursive: true);

      File(outPath).writeAsBytesSync(entry.readBytes()!);
    }
  }

  print("> Extracted package to ${cacheDir.path}");
}

Future<void> installCacheToVolume({
  required String packageName,
  required String version,
}) async {
  final buildDir = Directory(
    "/var/lib/rxpkg/cache/$packageName-$version/build",
  );

  if (!buildDir.existsSync()) {
    throw Exception("build/ directory not found in cache.");
  }

  final volumeDir = Directory("/var/lib/rxpkg/vol/$packageName/$version");

  if (volumeDir.existsSync()) {
    volumeDir.deleteSync(recursive: true);
  }

  volumeDir.createSync(recursive: true);

  await for (final entity in buildDir.list(
    recursive: true,
    followLinks: false,
  )) {
    final rel = relative(entity.path, from: buildDir.path);
    final dest = join(volumeDir.path, rel);

    if (entity is Directory) {
      Directory(dest).createSync(recursive: true);
    } else if (entity is File) {
      File(dest).createSync(recursive: true);
      entity.copySync(dest);
    } else if (entity is Link) {
      Link(dest).createSync(entity.targetSync(), recursive: true);
    }
  }

  print("> Installed package into ${volumeDir.path}");
}

Future<void> verifyExecutableSignatures({
  required Directory cacheDir,
  required Map<String, dynamic> manifest,
}) async {
  print("> verifying executable signatures...");

  final entries = manifest["entries"] as List<dynamic>;

  int checked = 0;

  for (final raw in entries) {
    final entry = raw as Map<String, dynamic>;

    if (entry["type"] != "file") {
      continue;
    }

    final mode = entry["mode"].toString();

    // Skip non-executables.
    if (!mode.contains("1") && !mode.contains("5") && !mode.contains("7")) {
      continue;
    }

    final path = entry["path"] as String;

    final expected = entry["sha256"] as String;

    final file = File("${cacheDir.path}/build${path}");

    if (!file.existsSync()) {
      throw Exception("Missing executable: $path");
    }

    final digest = sha256.convert(file.readAsBytesSync()).toString();

    if (digest != expected) {
      throw Exception(
        "Signature verification failed:\n"
        "  $path\n"
        "Expected: $expected\n"
        "Actual:   $digest",
      );
    }

    checked++;
  }

  print("> verified $checked executable(s)");
}

void _removeExisting(String path) {
  final type = FileSystemEntity.typeSync(
    path,
    followLinks: false,
  );

  switch (type) {
    case FileSystemEntityType.file:
      File(path).deleteSync();
      break;

    case FileSystemEntityType.link:
      Link(path).deleteSync();
      break;

    case FileSystemEntityType.directory:
      final dir = Directory(path);

      if (dir.listSync(followLinks: false).isEmpty) {
        dir.deleteSync();
      } else {
        throw Exception(
          "Cannot replace non-empty directory '$path' with a symlink.",
        );
      }

      break;

    case FileSystemEntityType.notFound:
      break;

    default:
      break;
  }
}

String _progressBar(int current, int total, {int width = 32}) {
  final ratio = total == 0 ? 1.0 : current / total;
  final filled = (ratio * width).floor();

  return "[${'█' * filled}${'░' * (width - filled)}]";
}

void _applyPermissions(String path, String mode) {
  final result = Process.runSync(
    "chmod",
    [mode, path],
  );

  if (result.exitCode != 0) {
    throw Exception(
      "Failed to chmod $path to $mode:\n${result.stderr}",
    );
  }
}

Future<void> createNewSymlinks({
  required String packageName,
  required String version,
  required Map<String, dynamic> manifest,
}) async {
  final entries = manifest["entries"] as List<dynamic>;

  final total = entries.length;
  int current = 0;

  stdout.writeln("> creating filesystem layout");
  stdout.writeln();

  for (final raw in entries) {
    current++;

    final entry = raw as Map<String, dynamic>;

    final systemPath = entry["path"] as String;
    final type = entry["type"] as String;

    final percent = ((current / total) * 100).floor();

    stdout.write(
      "\r${_progressBar(current, total)} "
      "${percent.toString().padLeft(3)}% "
      "(${current.toString().padLeft(4)}/${total.toString().padRight(4)}) "
      "${type.padRight(9)} "
      "$systemPath"
      " " * 20,
    );

    switch (type) {
      case "directory":
        Directory(systemPath).createSync(recursive: true);

        await sql.addDirectory(
          packageName,
          version,
          systemPath,
        );

        break;

      case "file":
        final volumePath =
            "/var/lib/rxpkg/vol/$packageName/$version$systemPath";

        if (!File(volumePath).existsSync()) {
          stdout.writeln();
          throw Exception("Missing file in volume: $volumePath");
        }

        Directory(dirname(systemPath)).createSync(recursive: true);

        _removeExisting(systemPath);

        _applyPermissions(
          volumePath,
          entry["mode"].toString(),
        );

        Link(systemPath).createSync(
          volumePath,
          recursive: true,
        );

        await sql.addFile(
          packageName,
          version,
          volumePath,
          entry["sha256"] as String,
        );

        await sql.addSymlink(
          packageName,
          version,
          systemPath,
          volumePath,
        );

        break;

      case "symlink":
        final target = entry["target"] as String;

        Directory(dirname(systemPath)).createSync(recursive: true);

        _removeExisting(systemPath);

        Link(systemPath).createSync(
          target,
          recursive: true,
        );

        await sql.addSymlink(
          packageName,
          version,
          systemPath,
          target,
        );

        break;

      default:
        stdout.writeln();
        throw Exception(
          "Unknown manifest entry type '$type'.",
        );
    }
  }

  stdout.write(
    "\r${_progressBar(total, total)} "
    "100% "
    "(${total.toString().padLeft(4)}/${total.toString().padRight(4)}) "
    "Done."
    " " * 60,
  );

  stdout.writeln();
  stdout.writeln("> filesystem layout complete");
}

void applyPermissions(String path, String mode) {
  final result = Process.runSync("chmod", [mode, path]);

  if (result.exitCode != 0) {
    throw Exception("Failed to chmod $path to $mode:\n${result.stderr}");
  }
}

Future<void> forceRemovePackage(String appName) async {
  if (sql.appsDb == null || sql.filesDb == null) {
    throw Exception("Database not initialized.");
  }

  final app = sql.appsDb!.select(
    '''
    SELECT current_version
    FROM apps
    WHERE name = ?;
    ''',
    [appName],
  );

  if (app.isEmpty) {
    throw Exception("Package '$appName' is not installed.");
  }

  final version = app.first["current_version"] as String;

  stdout.writeln("> removing filesystem links");

  final entries = sql.filesDb!.select(
    '''
    SELECT path, type
    FROM files
    WHERE app_name = ?
      AND version = ?;
    ''',
    [appName, version],
  );

  int removed = 0;

  for (final entry in entries) {
    final path = entry["path"] as String;
    final type = entry["type"] as String;

    switch (type) {
      case "symlink":
        if (Link(path).existsSync()) {
          Link(path).deleteSync();
          removed++;
        }
        break;

      case "file":
        // Files installed by rxpkg are symlinks.
        if (Link(path).existsSync()) {
          Link(path).deleteSync();
          removed++;
        }
        break;

      case "directory":
        try {
          Directory(path).deleteSync();
        } catch (_) {
          // Ignore non-empty directories.
        }
        break;
    }
  }

  stdout.writeln("> removed $removed link(s)");

  stdout.writeln("> removing database entries");

  await sql.removeVersion(
    appName,
    version,
  );

  stdout.writeln("✓ Package '$appName' removed.");
}