import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
      body: CompetitorView(competitorId: _index, game: widget.game),
      bottomNavigationBar: _bottomBarBuilder(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<TurnProvider>(context, listen: false)
                .addPoints(widget.game, _index, 10);
          },
          child: const Icon(Icons.add_rounded)),
    );
  }
}

class AddTurnDialog extends StatelessWidget {
  const AddTurnDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: TextField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Entrer le nombre de points obtenus',
      ),
    ));
  }
}
