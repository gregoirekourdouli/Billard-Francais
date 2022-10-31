import 'package:billard_fr/db.dart';

import 'model.dart';

class DAO {
  DAO._privateConstructor();

  static final DAO _instance = DAO._privateConstructor();

  factory DAO() {
    return _instance;
  }

  final _db = Db();

  Future<List<Game>> getGames() async {
    final results = await _db
        .selectQuery("SELECT id, timestamp, competitors FROM games WHERE favorite = 0");
    return results
        .map((e) => Game(
            id: e['id'] as int,
            timestamp: e['timestamp'] as int,
            competitors: e['competitors'] as int))
        .toList();
  }

  Future<List<Game>> getFavoriteGames() async {
    final results = await _db
        .selectQuery("SELECT id, timestamp, competitors FROM games WHERE favorite = 1");
    return results
        .map(
          (e) => Game(
              id: e['id'] as int,
              timestamp: e['timestamp'] as int,
              competitors: e['competitors'] as int),
        )
        .toList();
  }

  addGame(Game game) async {
    await _db.executeQuery(
        "INSERT INTO games (timestamp, competitors) VALUES (${game.timestamp}, ${game.competitors})");
  }

  deleteGame(Game game) async {
    await _db.executeQuery("DELETE FROM games WHERE id = ${game.id}");
  }

  setFavorite(Game game, bool favorite) async {
    await _db.executeQuery(
        "UPDATE games SET favorite = ${favorite.toString()} WHERE id = ${game.id}");
  }

  Future<Game> getLastSavedGame() async {
    final results = await _db.selectQuery(
        "SELECT id, timestamp, competitors FROM games ORDER BY id DESC LIMIT 1");
    if (results.length != 1) {
      throw 'Could not retrieve the last game';
    }
    final result = results.elementAt(0);
    return Game(
        id: result['id'] as int,
        timestamp: result['timestamp'] as int,
        competitors: result['competitors'] as int);
  }
}
