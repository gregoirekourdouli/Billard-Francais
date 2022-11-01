import 'package:billard_fr/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetitorView extends StatelessWidget {
  const CompetitorView(
      {super.key, required this.competitorId, required this.game});

  final int competitorId;
  final Game game;

  Widget _pointTextBuilder(context, AsyncSnapshot<int> snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.toString(),
          style: Theme.of(context).textTheme.titleLarge ??
              const TextStyle(fontSize: 25));
    } else if (snapshot.hasError) {
      throw snapshot.error ?? "Could not retrieve turns";
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _cardBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Total",
                        style: Theme.of(context).textTheme.titleLarge ??
                            const TextStyle(fontSize: 25))),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer<TurnProvider>(
                        builder: (context, provider, child) {
                      return FutureBuilder<int>(
                          future: provider.getScore(game, competitorId),
                          builder: _pointTextBuilder);
                    })),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _cardBuilder(context),
          Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 5, top: 25),
              child:
                  Consumer<TurnProvider>(builder: (context, provider, child) {
                return FutureBuilder<List<Turn>>(
                    future: provider.getTurns(game, competitorId),
                    builder: (context, AsyncSnapshot<List<Turn>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data!
                                    .elementAt(index)
                                    .points
                                    .toString()),
                              );
                            });
                      } else if (snapshot.hasError) {
                        throw snapshot.error ?? "Could not retrieve turns";
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    });
              }))
        ],
      ),
    );
  }
}
