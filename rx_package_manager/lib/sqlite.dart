import 'dart:io';

import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';

Database? appsDb;
Database? filesDb;

Future<void> createDatabaseInitIfNotExists() async {
  const root = "/var/lib/rxpkg";

  await Directory(join(root, "db")).create(recursive: true);

  appsDb = sqlite3.open(
    join(root, "db", "apps.db"),
  );

  filesDb = sqlite3.open(
    join(root, "db", "files.db"),
  );

  appsDb!.execute("""
    CREATE TABLE IF NOT EXISTS apps (
      name TEXT PRIMARY KEY,
      current_version TEXT,
      enabled INTEGER NOT NULL DEFAULT 1
    );
  """);

  appsDb!.execute("""
    CREATE TABLE IF NOT EXISTS versions (
      app_name TEXT NOT NULL,
      version TEXT NOT NULL,
      installed_at INTEGER NOT NULL,

      PRIMARY KEY(app_name, version),

      FOREIGN KEY(app_name)
        REFERENCES apps(name)
        ON DELETE CASCADE
    );
  """);

  filesDb!.execute("""
    CREATE TABLE IF NOT EXISTS files (
      app_name TEXT NOT NULL,

      version TEXT NOT NULL,

      path TEXT PRIMARY KEY,

      type TEXT NOT NULL,

      sha256 TEXT,

      target TEXT,

      verified INTEGER NOT NULL DEFAULT 1
    );
  """);
}

Future<void> createAppIfNotExists(
  String appName,
) async {
  if (appsDb == null) {
    throw Exception(
      "Database not initialized. Call createDatabaseInitIfNotExists() first.",
    );
  }

  final exists = appsDb!
      .select(
        "SELECT name FROM apps WHERE name = ?;",
        [appName],
      );

  if (exists.isNotEmpty) {
    return;
  }

  appsDb!.execute(
    """
    INSERT INTO apps(
      name,
      current_version,
      enabled
    )
    VALUES(?, NULL, 1);
    """,
    [appName],
  );
}

Future<void> addInstalledVersion(
  String appName,
  String version,
) async {
  if (appsDb == null) {
    throw Exception(
      "Database not initialized. Call createDatabaseInitIfNotExists() first.",
    );
  }

  appsDb!.execute(
    """
    INSERT OR IGNORE INTO versions(
      app_name,
      version,
      installed_at
    )
    VALUES (?, ?, ?);
    """,
    [
      appName,
      version,
      DateTime.now().millisecondsSinceEpoch,
    ],
  );
}

Future<void> setCurrentVersion(
  String appName,
  String version,
) async {
  if (appsDb == null) {
    throw Exception(
      "Database not initialized. Call createDatabaseInitIfNotExists() first.",
    );
  }

  final exists = appsDb!.select(
    """
    SELECT 1
    FROM versions
    WHERE app_name = ?
      AND version = ?;
    """,
    [appName, version],
  );

  if (exists.isEmpty) {
    throw Exception(
      "$appName version $version is not installed.",
    );
  }

  appsDb!.execute(
    """
    UPDATE apps
    SET current_version = ?
    WHERE name = ?;
    """,
    [
      version,
      appName,
    ],
  );
}

Future<void> disableApp(
  String appName,
) async {
  if (appsDb == null) {
    throw Exception(
      "Database not initialized. Call createDatabaseInitIfNotExists() first.",
    );
  }

  appsDb!.execute(
    """
    UPDATE apps
    SET enabled = 0
    WHERE name = ?;
    """,
    [appName],
  );
}

Future<void> enableApp(
  String appName,
) async {
  if (appsDb == null) {
    throw Exception(
      "Database not initialized. Call createDatabaseInitIfNotExists() first.",
    );
  }

  appsDb!.execute(
    """
    UPDATE apps
    SET enabled = 1
    WHERE name = ?;
    """,
    [appName],
  );
}

Future<void> removeVersion(
  String appName,
  String version,
) async {
  if (appsDb == null || filesDb == null) {
    throw Exception(
      "Database not initialized. Call createDatabaseInitIfNotExists() first.",
    );
  }

  if (version == "all") {
    appsDb!.execute(
      "DELETE FROM versions WHERE app_name = ?;",
      [appName],
    );

    filesDb!.execute(
      "DELETE FROM files WHERE app_name = ?;",
      [appName],
    );

    appsDb!.execute(
      "DELETE FROM apps WHERE name = ?;",
      [appName],
    );

    return;
  }

  appsDb!.execute(
    """
    DELETE FROM versions
    WHERE app_name = ?
      AND version = ?;
    """,
    [appName, version],
  );

  filesDb!.execute(
    """
    DELETE FROM files
    WHERE app_name = ?
      AND version = ?;
    """,
    [appName, version],
  );

  final remaining = appsDb!.select(
    """
    SELECT version
    FROM versions
    WHERE app_name = ?;
    """,
    [appName],
  );

  if (remaining.isEmpty) {
    appsDb!.execute(
      "DELETE FROM apps WHERE name = ?;",
      [appName],
    );
  }
}

Future<void> addFile(
  String appName,
  String version,
  String path,
  String sha256,
) async {
  if (filesDb == null) {
    throw Exception(
      "Database not initialized.",
    );
  }

  filesDb!.execute(
    """
    INSERT OR REPLACE INTO files(
      app_name,
      version,
      path,
      type,
      sha256,
      target,
      verified
    )
    VALUES (?, ?, ?, 'file', ?, NULL, 1);
    """,
    [
      appName,
      version,
      path,
      sha256,
    ],
  );
}

Future<void> addDirectory(
  String appName,
  String version,
  String path,
) async {
  if (filesDb == null) {
    throw Exception(
      "Database not initialized.",
    );
  }

  filesDb!.execute(
    """
    INSERT OR REPLACE INTO files(
      app_name,
      version,
      path,
      type,
      sha256,
      target,
      verified
    )
    VALUES (?, ?, ?, 'directory', NULL, NULL, 1);
    """,
    [
      appName,
      version,
      path,
    ],
  );
}

Future<void> addSymlink(
  String appName,
  String version,
  String path,
  String target,
) async {
  if (filesDb == null) {
    throw Exception(
      "Database not initialized.",
    );
  }

  filesDb!.execute(
    """
    INSERT OR REPLACE INTO files(
      app_name,
      version,
      path,
      type,
      sha256,
      target,
      verified
    )
    VALUES (?, ?, ?, 'symlink', NULL, ?, 1);
    """,
    [
      appName,
      version,
      path,
      target,
    ],
  );
}

Future<void> verifyFile(
  String path,
  bool verified,
) async {
  if (filesDb == null) {
    throw Exception(
      "Database not initialized.",
    );
  }

  filesDb!.execute(
    """
    UPDATE files
    SET verified = ?
    WHERE path = ?;
    """,
    [
      verified ? 1 : 0,
      path,
    ],
  );
}

Future<void> removeFilesOfVersion(
  String appName,
  String version,
) async {
  if (filesDb == null) {
    throw Exception(
      "Database not initialized.",
    );
  }

  filesDb!.execute(
    """
    DELETE FROM files
    WHERE app_name = ?
      AND version = ?;
    """,
    [
      appName,
      version,
    ],
  );
}

int compareVersions(
  String a,
  String b,
) {
  final va = a.split('.').map(int.parse).toList();
  final vb = b.split('.').map(int.parse).toList();

  final len = va.length > vb.length
      ? va.length
      : vb.length;

  for (var i = 0; i < len; i++) {
    final ai = i < va.length ? va[i] : 0;
    final bi = i < vb.length ? vb[i] : 0;

    if (ai != bi) {
      return ai.compareTo(bi);
    }
  }

  return 0;
}


bool satisfiesVersion(
  String installed,
  String constraint,
) {
  if (constraint.startsWith(">=")) {
    return compareVersions(
      installed,
      constraint.substring(2),
    ) >= 0;
  }

  if (constraint.startsWith("<=")) {
    return compareVersions(
      installed,
      constraint.substring(2),
    ) <= 0;
  }

  if (constraint.startsWith(">")) {
    return compareVersions(
      installed,
      constraint.substring(1),
    ) > 0;
  }

  if (constraint.startsWith("<")) {
    return compareVersions(
      installed,
      constraint.substring(1),
    ) < 0;
  }

  if (constraint.startsWith("==")) {
    return compareVersions(
      installed,
      constraint.substring(2),
    ) == 0;
  }

  if (constraint.startsWith("=")) {
    return compareVersions(
      installed,
      constraint.substring(1),
    ) == 0;
  }

  throw Exception(
    "Invalid version constraint '$constraint'.",
  );
}

Future<String?> getCurrentVersion(String appName) async {
  if (appsDb == null) {
    throw Exception("Database not initialized.");
  }

  final result = appsDb!.select(
    "SELECT current_version FROM apps WHERE name = ?;",
    [appName],
  );

  if (result.isEmpty) return null;

  return result.first["current_version"] as String?;
}

Future<bool> isAppInstalled(
  String appName, {
  String? versionConstraint,
}) async {
  if (appsDb == null) {
    throw Exception("Database not initialized.");
  }

  final installed = appsDb!.select(
    "SELECT 1 FROM apps WHERE name = ? LIMIT 1;",
    [appName],
  );

  if (installed.isEmpty) {
    return false;
  }

  if (versionConstraint == null) {
    final result = appsDb!.select(
      """
      SELECT 1
      FROM apps
      WHERE name = ?
      LIMIT 1;
      """,
      [appName],
    );

    return result.isNotEmpty;
  }

  final currentVersion = await getCurrentVersion(appName);

  return satisfiesVersion(
    currentVersion.toString(),
    versionConstraint,
  );
}

Future<void> listInstalledPackages() async {
  if (appsDb == null) {
    throw Exception("Database not initialized.");
  }

  stdout.writeln();
  stdout.writeln("Installed Packages");
  stdout.writeln("──────────────────────────────────────────────────────────────");
  stdout.writeln();

  final apps = appsDb!.select('''
    SELECT
      name,
      current_version,
      enabled
    FROM apps
    ORDER BY name COLLATE NOCASE;
  ''');

  int count = 0;

  for (final app in apps) {
    count++;

    final name = app['name'] as String;
    final current = app['current_version'] as String?;
    final enabled = (app['enabled'] as int) == 1;

    final versions = appsDb!.select(
      '''
      SELECT version
      FROM versions
      WHERE app_name = ?
      ORDER BY version DESC;
      ''',
      [name],
    );

    if (versions.length <= 1) {
      stdout.writeln(
        "${name.padRight(22)} "
        "${(current ?? "-").padRight(12)} "
        "${enabled ? "(current)" : "(disabled)"}",
      );
    } else {
      stdout.writeln(name);

      for (final version in versions) {
        final v = version['version'] as String;

        final marker = (v == current)
            ? "← current"
            : "";

        stdout.writeln(
          "  ├─ ${v.padRight(12)} $marker",
        );
      }

      stdout.writeln();
    }
  }

  stdout.writeln();
  stdout.writeln("$count package(s) installed.");
}

