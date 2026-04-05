// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lamp/widgets/back_card.dart';
import 'package:lamp/widgets/front_card.dart';
import 'dart:math' show pi;

class CardContainer extends StatefulWidget {
  final String theme;
  final String type;
  final String num;
  final String title;
  final String book;
  final String chapter;
  final String part;
  final String content;

  const CardContainer({
    super.key,
    required this.theme,
    required this.type,
    required this.num,
    required this.title,
    required this.book,
    required this.chapter,
    required this.part,
    required this.content,
  });

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer>
    with SingleTickerProviderStateMixin {
  bool isFront = true;

  late AnimationController _cardFlipController;
  late Animation<double> _cardFlipAnimation;

  @override
  void initState() {
    super.initState();

    _cardFlipController = AnimationController(
      duration: const Duration(seconds: 1), // Animation lasts 1 seconds
      vsync: this, // Syncs with the screen refresh rate
    );

    _cardFlipAnimation = Tween(
      begin: 0.0, // ---> 0°
      end: pi, // ---> 180°
    ).animate(_cardFlipController); // Place the animation controller here
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isFront) {
          _cardFlipController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _cardFlipAnimation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(_cardFlipAnimation.value),
            child: isFront
                ? FrontCard(
                    theme: widget.theme,
                    type: widget.type,
                    num: widget.num,
                    title: widget.title,
                    book: widget.book,
                    chapter: widget.chapter,
                    part: widget.part,
                    content: widget.content)
                : BackCard(
                    theme: widget.theme,
                    type: widget.type,
                    num: widget.num,
                    title: widget.title,
                    book: widget.book,
                    chapter: widget.chapter,
                    part: widget.part,
                    content: widget.content),
          );
        },
      ),
    );
  }
}
