import 'package:flutter/material.dart';

class AnimatedCardPage extends StatefulWidget {
  @override
  AnimatedCardPageState createState() => AnimatedCardPageState();
}

class AnimatedCardPageState extends State<AnimatedCardPage> {
  var alignment = Alignment.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Align with card"),
      ),
      body: GestureDetector(
        onVerticalDragStart: (details) {
          print("on vertical drag start ${details}");
          setState(() {
            alignment = alignment == Alignment.center
                ? Alignment.topRight
                : Alignment.center;
          });
        },
        child: AnimatedAlign(
          alignment: alignment,
          duration: Duration(milliseconds: 100),
          child: Container(
            width: 300,
            height: 150,
            color: Colors.amberAccent,
          ),
        ),
      ),
    );
  }
}
