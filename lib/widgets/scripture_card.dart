import 'package:flutter/material.dart';

class ScriptureCard extends StatelessWidget {
  final String theme;
  final String type;
  final String num;
  final String title;
  final String book;
  final String chapter;
  final String part;
  final String content;
  const ScriptureCard(
      {super.key,
      required this.theme,
      required this.type,
      required this.num,
      required this.title,
      required this.book,
      required this.chapter,
      required this.part,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amberAccent.withOpacity(0.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              height: 5.0,
            ),
            Text("$book $chapter:$part"),
            SizedBox(
              height: 5.0,
            ),
            Text(content),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$book $chapter:$part",
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text("$type-$num"),
                SizedBox(
                  width: 3,
                ),
                Text(theme),
              ],
            )
          ]),
        ));
  }
}
