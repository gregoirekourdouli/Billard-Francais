import 'package:billard_fr/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class _CardRow extends StatelessWidget {
  const _CardRow({required this.competitorId, required this.game});

  final int competitorId;
  final Game game;

  String getTitle();

  TextStyle getTitleStyle(BuildContext context);

  TextStyle getDataStyle(BuildContext context);

  Widget getFutureBuilder(
      BuildContext context, TurnProvider provider, Widget? child);

  Widget _pointTextBuilder(context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.toString(), style: getDataStyle(context));
    } else if (snapshot.hasError) {
      throw snapshot.error ?? "Could not retrieve turns";
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(getTitle(), style: getTitleStyle(context))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<TurnProvider>(builder: getFutureBuilder)),
      ],
    );
  }
}

class _CardTotalRow extends _CardRow {
  const _CardTotalRow({required super.competitorId, required super.game});

  @override
  TextStyle getDataStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge ??
        const TextStyle(fontSize: 25);
  }

  @override
  String getTitle() => 'Total';

  @override
  TextStyle getTitleStyle(BuildContext context) => getDataStyle(context);

  @override
  Widget getFutureBuilder(
      BuildContext context, TurnProvider provider, Widget? child) {
    return FutureBuilder<int>(
        future: provider.getScore(game, competitorId),
        builder: _pointTextBuilder);
  }
}

class _CardAvgRow extends _CardRow {
  const _CardAvgRow({required super.competitorId, required super.game});

  @override
  TextStyle getDataStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium ??
        const TextStyle(fontSize: 20);
  }

  @override
  String getTitle() => "Moyenne";

  @override
  TextStyle getTitleStyle(BuildContext context) => getDataStyle(context);

  @override
  Widget getFutureBuilder(
      BuildContext context, TurnProvider provider, Widget? child) {
    return FutureBuilder<double>(
        future: provider.getAvg(game, competitorId),
        builder: _pointTextBuilder);
  }
}

class _CardCountRow extends _CardRow {
  const _CardCountRow({required super.competitorId, required super.game});

  @override
  TextStyle getDataStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium ??
        const TextStyle(fontSize: 20);
  }

  @override
  Widget getFutureBuilder(
      BuildContext context, TurnProvider provider, Widget? child) {
    return FutureBuilder<int>(
        future: provider.getTurnCount(game, competitorId),
        builder: _pointTextBuilder);
  }

  @override
  String getTitle() => "Nb de reprises";

  @override
  TextStyle getTitleStyle(BuildContext context) => getDataStyle(context);
}

class CompetitorView extends StatelessWidget {
  const CompetitorView(
      {super.key, required this.competitorId, required this.game});

  final int competitorId;
  final Game game;

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
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                _CardTotalRow(competitorId: competitorId, game: game),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _CardAvgRow(competitorId: competitorId, game: game)),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child:
                        _CardCountRow(competitorId: competitorId, game: game)),
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
