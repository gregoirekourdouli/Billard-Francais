import 'package:flutter/material.dart';

import 'competitor_view.dart';
import 'model.dart';

class CurrentGameView extends StatefulWidget {
  const CurrentGameView({super.key, required this.game});

  final Game game;

  @override
  State<CurrentGameView> createState() => _CurrentGameViewState();
}

class _CurrentGameViewState extends State<CurrentGameView> {
  int _index = 0;

  static const List<Widget> _competitorViews = [
    CompetitorView(competitorId: 0),
    CompetitorView(competitorId: 1)
  ];

  Widget? _bottomBarBuilder() {
    if (widget.game.competitors == 2) {
      return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: "Adversaire 1",
              icon: Icon(Icons.person_rounded),
            ),
            BottomNavigationBarItem(
              label: "Adversaire 2",
              icon: Icon(Icons.person_rounded),
            )
          ]);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Partie"),
      ),
      body: _competitorViews[_index],
      bottomNavigationBar: _bottomBarBuilder(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.add_rounded)),
    );
  }
}
