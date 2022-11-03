import 'package:billard_fr/model.dart';
import 'package:billard_fr/settings_view.dart';
import 'package:billard_fr/theme_preference.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'current_game_view.dart';
import 'game_view.dart';

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
            ChangeNotifierProvider(create: (_) => TurnProvider()),
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
              home: const MyHomePage(title: 'Billard français'),
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
          return SimpleDialog(title: const Text("Jouer ..."), children: [
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
                    Game(id: 0, timestamp: DateTime.now().millisecondsSinceEpoch, competitors: 2));
                final game = await provider.getLastSavedGame();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => CurrentGameView(game: game,)));
              },
              child: const Text("Avec un adversaire"),
            )
          ]);
        });
  }
}

