import 'package:flutter/material.dart';

class BackCard extends StatelessWidget {
  final String theme;
  final String type;
  final String num;
  final String title;
  final String book;
  final String chapter;
  final String part;
  final String content;
  const BackCard(
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
          border: Border.all(width: 2, color: Colors.black),
          color: type == "A" ? Colors.greenAccent : Colors.amberAccent,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(
                height: 5.0,
              ),
              Text("En $book $chapter:$part"),
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
            ]));
  }
}
