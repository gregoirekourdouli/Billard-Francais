PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "games" (
        "id"    INTEGER NOT NULL,
        "timestamp"     INTEGER NOT NULL DEFAULT 0,
        "favorite"      INTEGER NOT NULL DEFAULT 0,
        "competitors"   INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT)
);
DELETE FROM sqlite_sequence;
COMMIT;