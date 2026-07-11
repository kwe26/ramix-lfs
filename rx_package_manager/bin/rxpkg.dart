import 'dart:io';
import 'package:path/path.dart';
import 'package:rx_package_manager/rx_package_manager.dart'
    as rx_package_manager;
import 'package:rx_package_manager/sqlite.dart' as sql;
import 'dart:ffi';

final _libc = DynamicLibrary.open('libc.so.6');

final _geteuid = _libc.lookupFunction<Uint32 Function(), int Function()>(
  'geteuid',
);

bool isRoot() => _geteuid() == 0;

class Dependency {
  final String name;
  final String? constraint;

  Dependency(this.name, this.constraint);
}

Dependency parseDependency(String dep) {
  final match = RegExp(
    r'^([A-Za-z0-9._+-]+)\s*(>=|<=|==|>|<|=)?\s*(.*)?$',
  ).firstMatch(dep);

  if (match == null) {
    throw FormatException("Invalid dependency: $dep");
  }

  final name = match.group(1)!;

  final op = match.group(2);
  final version = match.group(3)?.trim();

  return Dependency(name, op == null ? null : "$op$version");
}

Future<void> initPkgDirect() async {
  const root = "/var/lib/rxpkg";

  final directories = [
    join(root, 'vol'),
    join(root, 'cache'),
    join(root, 'db'),
  ];

  for (final dir in directories) {
    await Directory(dir).create(recursive: true);
  }
}

void main(List<String> arguments) async {
  print('rxpkg version ${rx_package_manager.version}');

  await sql.createDatabaseInitIfNotExists();


  if (!isRoot()) {
    stderr.writeln('your must run as the superuser of the system');
    exit(1);
  } else {
    await initPkgDirect();
  }

  if (arguments.isEmpty) {
    print("no arguments passed");
    return;
  }

  if (arguments.first == 'help') {
    print(' Help   -------------  Version');
    print(' rxpkg install <package_path> ');
    print(' rxpkg installed ');
    print(' rxpkg force-rm <package> ');
    print(' rxbuild . ');
  }

  if(arguments.first == "installed"){
    await sql.listInstalledPackages();
    return;
  }

  if(arguments.first == "force-rm"){
    await rx_package_manager.forceRemovePackage(arguments[1]);
    return;
  }

  if (arguments.first == "install") {
    print("> querying package");
    String filePath = arguments[1];

    Map<String, dynamic> manifest = rx_package_manager.packageManifest(
      filePath,
    );

    bool isInstalled = await sql.isAppInstalled(
      manifest['name'],
      // ignore: prefer_interpolation_to_compose_strings
      versionConstraint: "="+manifest['version'],
    );

    if(isInstalled){
      print("${manifest['name']}@${manifest['version']} already installed!");
      return;
    }

    int ok = 0;
    int nook = 0;

    print("> checking depends");
    for (final depd in manifest["depends"]) {
      Dependency dep = parseDependency(depd);
      if ((await sql.isAppInstalled(
            dep.name,
            versionConstraint: dep.constraint,
          )) ==
          true) {
        ok += 1;
        print("> ${dep.name}${dep.constraint} satisfied");
      } else {
        nook += 1;
        print("> ${dep.name}${dep.constraint} not satisfied!");
      }
    }

    if (nook > 0) {
      stderr.writeln(
        "> dependencies not satisfied, halting installation of package",
      );
      exit(1);
    }

    print("> $ok deps satisfied");

    print ("> attempting to write files to cache");

    await rx_package_manager.extractPackageToCache(filePath: filePath, packageName: manifest['name'], version: manifest['version']);

    print ("> writing to vol");

    await rx_package_manager.installCacheToVolume(packageName: manifest['name'], version: manifest['version']);

    await rx_package_manager.verifyExecutableSignatures(cacheDir: Directory(
      "/var/lib/rxpkg/cache/${manifest["name"]}-${manifest["version"]}",
    ), manifest: manifest);

    await sql.createAppIfNotExists(manifest['name']);
    await sql.addInstalledVersion(manifest['name'], manifest['version']);
    await sql.setCurrentVersion(manifest['name'], manifest['version']);
    await sql.enableApp(manifest['name']);
    
    await rx_package_manager.createNewSymlinks(packageName: manifest['name'], version: manifest['version'], manifest: manifest);

    print(">> ${manifest['name']} @ ${manifest['version']} installed successfully!");
  }
}
