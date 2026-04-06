import 'package:flutter/material.dart';
import 'package:lamp/global_variable.dart';
import 'package:lamp/widgets/card_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lamp and Light"),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final items = frontScripture;
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final scripture = items[i];

                return Align(
                  heightFactor: 0.2,
                  child: CardContainer(
                      theme: scripture['theme'].toString(),
                      type: scripture['type'].toString(),
                      num: scripture['num'].toString(),
                      title: scripture['title'].toString(),
                      book: scripture['book'].toString(),
                      chapter: scripture['chapter'].toString(),
                      part: scripture['part'].toString(),
                      content: scripture['content'].toString()),
                );
              });
        }));
  }
}
