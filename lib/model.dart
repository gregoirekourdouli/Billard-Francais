
import 'package:billard_fr/dao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Game {
  int id;
  int timestamp;
  int competitors;
  String get date {
    var format = DateFormat('y-M-d');
    return format.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }
  Game({required this.id, required this.timestamp, required this.competitors});
}

class GameProvider extends ChangeNotifier {

  final _dao = DAO();

  Future<List<Game>> getGames() => _dao.getGames();
  Future<List<Game>> getFavoriteGames() => _dao.getFavoriteGames();

  void addGame(Game game) async {
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