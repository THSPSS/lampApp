import 'package:flutter/material.dart';
import 'package:lamp/global_variable.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(child: LayoutBuilder(builder: (context, constraints) {
      final items = scriptures;
      return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) {
            final scripture = items[i];

            return Text(scripture['content'].toString());
          });
    })));
  }
}
