import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scripture card"),
      ),
      body: Container(
        width: 300,
        height: 150,
        color: Colors.amberAccent,
      ),
    );
  }
}
