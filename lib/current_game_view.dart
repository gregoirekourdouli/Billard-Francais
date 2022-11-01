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
          _dialogBuilder(context);
        },
        tooltip: "Ajouter des points",
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddTurnDialog(game: widget.game, competitorId: _index);
        });
  }
}

class AddTurnDialog extends StatefulWidget {
  const AddTurnDialog(
      {super.key, required this.game, required this.competitorId});

  final Game game;
  final int competitorId;

  @override
  State<AddTurnDialog> createState() => _AddTurnDialogState();
}

class _AddTurnDialogState extends State<AddTurnDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Ajouter des points"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Entrer le nombre de points obtenus',
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Provider.of<TurnProvider>(context, listen: false).addPoints(
                    widget.game,
                    widget.competitorId,
                    int.parse(controller.text));
                Navigator.of(context).pop();
              },
              child: const Text("Ok"))
        ]);
  }
}
