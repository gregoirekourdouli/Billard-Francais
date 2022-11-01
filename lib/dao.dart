import 'package:billard_fr/db.dart';
import 'package:sqlite3/common.dart';

import 'model.dart';

class DAO {
  DAO._privateConstructor();

  static final DAO _instance = DAO._privateConstructor();

  factory DAO() {
    return _instance;
  }

  final _db = Db();

  Future<List<Game>> getGames() async {
    final results = await _db.selectQuery(
        "SELECT id, timestamp, competitors FROM games WHERE favorite = 0");
    return results
        .map((e) => Game(
            id: e['id'] as int,
            timestamp: e['timestamp'] as int,
            competitors: e['competitors'] as int))
        .toList();
  }

  Future<List<Game>> getFavoriteGames() async {
    final results = await _db.selectQuery(
        "SELECT id, timestamp, competitors FROM games WHERE favorite = 1");
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

  //////////////////////////////////////////////////////////

  Future<List<Turn>> getTurns(Game game, int competitorId) async {
    final results = await _db.selectQuery(
        "SELECT id, points FROM turns WHERE gameId = ${game.id} AND competitorId = $competitorId");
    return results
        .map((e) => Turn(id: e['id'] as int, points: e['points'] as int))
        .toList();
  }

  String _getSql(String operation, Game game, int competitorId) =>
      "SELECT gameId, competitorId, $operation(points) as points FROM turns GROUP BY gameId, competitorId HAVING gameId = ${game.id} AND competitorId = $competitorId";

  int _getPoint(ResultSet results) {
    if (results.length != 1) {
      return 0;
    }
    final e = results[0];
    return e['points'] as int;
  }

  Future<int> getScore(Game game, int competitorId) async {
    final results = await _db.selectQuery(_getSql("SUM", game, competitorId));
    return _getPoint(results);
  }

  Future<double> getAvg(Game game, int competitorId) async {
    final results = await _db.selectQuery(_getSql("AVG", game, competitorId));
    if (results.length != 1) {
      return 0;
    }
    final e = results[0];
    return e['points'] as double;
  }

  Future<int> getCount(Game game, int competitorId) async {
    final results = await _db.selectQuery(_getSql("COUNT", game, competitorId));
    return _getPoint(results);
  }

  addPoints(Game game, int competitorId, int points) async {
    await _db.executeQuery(
        "INSERT INTO turns (gameId, competitorId, points) VALUES (${game.id}, $competitorId, $points)");
  }
}
