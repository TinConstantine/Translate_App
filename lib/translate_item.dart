import 'package:flutter/material.dart';

class TranslateItem extends StatelessWidget {
  final String word;
  final String definition;
  final String pronounce;
  const TranslateItem(
      {super.key,
      required this.word,
      required this.definition,
      required this.pronounce});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              word,
              style: const TextStyle(fontSize: 21),
            )),
        body: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      definition,
                      style: const TextStyle(fontSize: 21),
                    ),
                    Text(pronounce,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.5),
                        ))
                  ]),
            )));
  }
}
