import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lamp/global_variable.dart';

class AnimatedCardPage extends StatefulWidget {
  final Function onCardChanged;

  AnimatedCardPage({this.onCardChanged});
  @override
  _AnimatedCardPageState createState() => _AnimatedCardPageState();
}

class _AnimatedCardPageState extends State<AnimatedCardPage>
    with SingleTickerProviderStateMixin {
  //might need to add cards
  //  var int currentIndex;

  late AnimationController controller;
  late Animation<double> moveDown;
  late Animation<double> rotate;
  late Animation<double> moveUp;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );

    moveUp = Tween<double>(begin: 0, end: 150).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    rotate = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    moveDown = Tween<double>(begin: 150, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void startAnimation() {
    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom move with card"),
      ),
      body: GestureDetector(
        onTap: startAnimation,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(1, 3, 0.001)
                ..rotateX(rotate.value), //perspective
              child: child,
            );
          },
          child: Center(
            child: Container(
              width: 300,
              height: 150,
              color: Colors.amberAccent,
              child: Text(frontScripture[0]['content'].toString()),
            ),
          ),
        ),
      ),
    );
  }
}
