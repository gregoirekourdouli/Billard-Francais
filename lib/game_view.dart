

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'current_game_view.dart';
import 'model.dart';

abstract class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);
}

class FavoriteGameView extends GameView {
  const FavoriteGameView({super.key});

  @override
  State<GameView> createState() => _FavoriteGameViewState();
}

class OtherGameView extends GameView {
  const OtherGameView({super.key});

  @override
  State<GameView> createState() => _OtherGameViewState();
}

abstract class _GameViewState extends State<GameView> {
  // Subclassed methods
  Future<List<Game>> getGames(GameProvider provider);

  String getTitle();

  void onDismissed(DismissDirection direction, Game game);

  Widget getBackground();

  Widget getSecondBackground();

  Widget? getLeadingWidget();

  String getTileTitle(Game game) {
    if (game.competitors == 1) {
      return '${game.id} - Seul';
    } else {
      return '${game.id} - Avec adversaire';
    }
  }

  Widget _buildTile(BuildContext context, Game game, List<Game> games) {
    return Dismissible(
        key: Key(game.id.toString()),
        onDismissed: (direction) {
          onDismissed(direction, game);
          games.remove(game);
        },
        background: getBackground(),
        secondaryBackground: getSecondBackground(),
        child: ListTile(
          leading: getLeadingWidget(),
          title: Text(getTileTitle(game)),
          subtitle: Text(game.date),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CurrentGameView(game: game)));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, provider, child) {
      return FutureBuilder<List<Game>>(
          future: getGames(provider),
          builder: (context, AsyncSnapshot<List<Game>> snapshot) {
            if (snapshot.hasData) {
              return Visibility(
                  visible: snapshot.data!.isNotEmpty,
                  maintainState: true,
                  maintainAnimation: true,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, bottom: 5, top: 25),
                            child: Text(getTitle(),
                                style: Theme.of(context).textTheme.titleLarge ??
                                    const TextStyle(fontSize: 25))),
                        ListView.builder(
                          // scroll manage by SingleChildScrollView above
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = snapshot.data!.elementAt(index);
                              return _buildTile(context, item, snapshot.data!);
                            })
                      ]));
            } else if (snapshot.hasError) {
              throw snapshot.error ?? "Could not retrieve games";
            } else {
              return const CircularProgressIndicator();
            }
          });
    });
  }
}

class _OtherGameViewState extends _GameViewState {
  @override
  Future<List<Game>> getGames(GameProvider provider) => provider.getGames();

  @override
  String getTitle() => "Parties";

  @override
  Widget getBackground() {
    return Container(
        color: Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary));
  }

  @override
  Widget getSecondBackground() {
    return Container(
        color:
        Colors.yellow.harmonizeWith(Theme.of(context).colorScheme.primary));
  }

  @override
  void onDismissed(DismissDirection direction, Game game) {
    if (direction == DismissDirection.startToEnd) {
      Provider.of<GameProvider>(context, listen: false).deleteGame(game);
    } else {
      Provider.of<GameProvider>(context, listen: false).setFavorite(game, true);
    }
  }

  @override
  Widget? getLeadingWidget() => null;
}

class _FavoriteGameViewState extends _GameViewState {
  Color get favoriteColor =>
      Colors.yellow.harmonizeWith(Theme.of(context).colorScheme.primary);

  @override
  Future<List<Game>> getGames(GameProvider provider) =>
      provider.getFavoriteGames();

  @override
  String getTitle() => "Favoris";

  @override
  Widget getBackground() {
    return Container(color: favoriteColor);
  }

  @override
  Widget getSecondBackground() => getBackground();

  @override
  void onDismissed(DismissDirection direction, Game game) {
    Provider.of<GameProvider>(context, listen: false).setFavorite(game, false);
  }

  @override
  Widget? getLeadingWidget() =>
      Icon(Icons.star_rounded, color: Theme.of(context).colorScheme.primary);
}
