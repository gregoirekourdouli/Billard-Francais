PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "games" (
        "id"    INTEGER NOT NULL,
        "timestamp"     INTEGER NOT NULL DEFAULT 0,
        "favorite"      INTEGER NOT NULL DEFAULT 0,
        "competitors"   INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "turns" (
        "id"    INTEGER NOT NULL,
        "gameId"    INTEGER NOT NULL,
        "competitorId"  INTEGER NOT NULL,
        "points" INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("gameId") REFERENCES "games"("id")
);
DELETE FROM sqlite_sequence;
COMMIT;