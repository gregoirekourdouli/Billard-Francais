import 'package:billard_fr/model.dart';
import 'package:billard_fr/settings_view.dart';
import 'package:billard_fr/theme_preference.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: const Color(0xff607D8B));
  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xff607D8B), brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => GameProvider()),
          ],
          child: Consumer<ThemeProvider>(builder: (context, provider, child) {
            return MaterialApp(
              title: 'Billard fr',
              theme: ThemeData(
                colorScheme: lightColorScheme ?? _defaultLightColorScheme,
                useMaterial3: provider.isMaterial3,
              ),
              darkTheme: ThemeData(
                  colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
                  useMaterial3: provider.isMaterial3),
              themeMode: provider.isDark ? ThemeMode.dark : ThemeMode.light,
              home: const MyHomePage(title: 'L\'appli pour Fred'),
            );
          }));
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const SettingsView()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: const <Widget>[FavoriteGameView(), OtherGameView()],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _dialogBuilder(context);
        },
        tooltip: 'Nouvelle partie',
        label: const Text("Nouvelle partie"),
        icon: const Icon(Icons.add_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(title: const Text("Type de partie"), children: [
            SimpleDialogOption(
              onPressed: () async {
                final provider = Provider.of<GameProvider>(context, listen: false);
                await provider.addGame(
                    Game(id: 0, timestamp: DateTime.now().millisecondsSinceEpoch, competitors: 1));
                final game = await provider.getLastSavedGame();
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CurrentGameView(game: game)));
              },
              child: const Text("Seul"),
            ),
            SimpleDialogOption(
              onPressed: () async {
                final provider = Provider.of<GameProvider>(context, listen: false);
                await provider.addGame(
                    Game(id: 0, timestamp: DateTime.now().millisecondsSinceEpoch, competitors: 0));
                final game = await provider.getLastSavedGame();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => CurrentGameView(game: game,)));
              },
              child: const Text("Avec adversaire"),
            )
          ]);
        });
  }
}

class CurrentGameView extends StatelessWidget {
  const CurrentGameView({super.key, required this.game});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Partie"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("${game.date} - ${game.id}")
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
        child: const Icon(Icons.add_rounded)
      ),
    );
  }
}



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
          title: Text('${game.date} - ${game.id}'),
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
