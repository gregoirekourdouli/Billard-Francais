import 'package:flutter/material.dart';

class CompetitorView extends StatelessWidget {
  const CompetitorView({super.key, required this.competitorId});

  final int competitorId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
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
                          child: Text("Total", style: Theme.of(context).textTheme.titleLarge ??
                              const TextStyle(fontSize: 25))
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("886", style: Theme.of(context).textTheme.titleLarge ??
                              const TextStyle(fontSize: 25))
                      ),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
