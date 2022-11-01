import 'package:billard_fr/dao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Game {
  int id;
  int timestamp;
  int competitors;

  String get date {
    var format = DateFormat('d-M-y');
    return format.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  Game({required this.id, required this.timestamp, required this.competitors});
}

class Turn {
  int id;
  int points;

  Turn({required this.id, required this.points});
}

class GameProvider extends ChangeNotifier {
  final _dao = DAO();

  Future<List<Game>> getGames() async => await _dao.getGames();

  Future<List<Game>> getFavoriteGames() async => await _dao.getFavoriteGames();

  Future<Game> getLastSavedGame() async => await _dao.getLastSavedGame();

  addGame(Game game) async {
    await _dao.addGame(game);
    notifyListeners();
  }

  void setFavorite(Game game, bool favorite) async {
    await _dao.setFavorite(game, favorite);
    notifyListeners();
  }

  void deleteGame(Game game) async {
    await _dao.deleteGame(game);
    notifyListeners();
  }
}

class TurnProvider extends ChangeNotifier {
  final _dao = DAO();

  Future<List<Turn>> getTurns(Game game, int competitorId) async =>
      await _dao.getTurns(game, competitorId);

  Future<int> getScore(Game game, int competitorId) async =>
      await _dao.getScore(game, competitorId);

  void addPoints(Game game, int competitorId, int points) async {
    await _dao.addPoints(game, competitorId, points);
    notifyListeners();
  }
}
