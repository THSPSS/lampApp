// FlipCard 클래스 정의

import 'package:flutter/material.dart';

class FlipCard {
  final Color color;
  final double top;
  final double left;
  final double width;
  final double height;
  final int index;
  final UniqueKey flipKey;

  FlipCard({
    required this.color,
    required this.top,
    required this.left,
    required this.width,
    required this.height,
    required this.index,
    required this.flipKey,
  });

  FlipCard copyWith({
    Color? color,
    double? top,
    double? left,
    double? width,
    double? height,
    int? index,
    UniqueKey? flipKey,
  }) {
    return FlipCard(
      color: color ?? this.color,
      top: top ?? this.top,
      left: left ?? this.left,
      width: width ?? this.width,
      height: height ?? this.height,
      index: index ?? this.index,
      flipKey: flipKey ?? this.flipKey,
    );
  }
}
