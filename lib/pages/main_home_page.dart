import 'package:flutter/material.dart';
import 'package:lamp/global_variable.dart';
import 'package:lamp/widgets/cards_swiper_widget.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  bool _shouldPlayAnimation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _shouldPlayAnimation = !_shouldPlayAnimation;
            });
          },
          child: Icon(_shouldPlayAnimation ? Icons.pause : Icons.play_arrow),
        ),
        body: Center(
            child: CardsSwiperWidget(
          cardData: frontScripture,
          animationDuration: const Duration(milliseconds: 600),
          downDragDuration: const Duration(milliseconds: 200),
          onCardChange: (index) {
            print('Top card index: ${index}');
          },
          cardBuilder: (context, index, visibleIndex) {
            if (index < 0 || index >= frontScripture.length) {
              return const SizedBox.shrink();
            }
            final card = frontScripture[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellow.shade100,
              ),
              width: 300,
              height: 200,
              alignment: Alignment.center,
              child: Text(
                card['content'] as String,
              ),
            );
          },
        )));
  }
}
