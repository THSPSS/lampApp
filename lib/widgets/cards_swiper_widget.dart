import 'package:flutter/material.dart';
import 'dart:math';

//using <T> for Generic Widget : allowing it to handle any type of card data.
class CardsSwiperWidget<T> extends StatefulWidget {
  //Parameters
  final List<T> cardData;
  //Each Card Builder
  final Widget Function(BuildContext context, int index, int visibleIndex)
      cardBuilder;
  //duration for Swipe animation
  final Duration animationDuration;
  //how far card can be dragged down
  final double maxDragDistance;
  //point where card should be swiped away
  final Duration downDragDuration;
  final double thresholdValue;
  //Callback when the top card changes
  final void Function(int)? onCardChange;

  const CardsSwiperWidget({
    required this.cardData,
    required this.cardBuilder,
    this.animationDuration = const Duration(milliseconds: 800),
    this.downDragDuration = const Duration(milliseconds: 300),
    this.maxDragDistance = 220.0,
    this.thresholdValue = 0.3,
    this.onCardChange,
    super.key,
  });

  @override
  State<CardsSwiperWidget<T>> createState() => _CardsSwiperWidgetState<T>();
}

//Building the State Class
class _CardsSwiperWidgetState<T> extends State<CardsSwiperWidget<T>>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yOffsetAnimation;
  late Animation<double> _rotationAnimation;

  double _startAnimationValue = 0.0;
  double _dragStartPosition = 0.0;
  double _dragOffest = 0.0;
  bool _isCardSwitched = false;
  bool _hasReachedHalf = false;

  late List<T> _cardData;

  @override
  void initState() {
    super.initState();

    // Copy the card data to allow modifications
    _cardData = List.from(widget.cardData);

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Create a CurvedAnimation
    final _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Define the yOffset animation
    _yOffsetAnimation = Tween<double>(
      begin: 0.0,
      end: -widget.maxDragDistance,
    ).animate(_animation);

    // Define the rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: -pi,
    ).animate(_animation);

    //Listen to the animation value to switch cards
    _controller.addListener(() {
      if (!_isCardSwitched && _controller.value >= 0.5) {
        // Move the top card to the back
        // Remove from first slot and add it to make it last of list
        var firstCard = _cardData.removeAt(0);
        _cardData.add(firstCard);

        _isCardSwitched = true;

        // Trigger the callback with the new top card index
        if (widget.onCardChange != null) {
          widget.onCardChange!(widget.cardData.indexOf(_cardData[0]));
        }
      }

      // Reset the switch flag when animation resets
      if (_controller.value == 1.0) {
        _isCardSwitched = false;
        _controller.reset();
        _hasReachedHalf = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Called when the users starts dragging
  void _onVerticalDragStart(DragStartDetails details) {
    if (_controller.isAnimating) return;

    _startAnimationValue = _controller.value;
    _dragStartPosition = details.globalPosition.dy;
    _controller.stop(canceled: false);
    _hasReachedHalf = false;
  }

// Updates the animation based on the drag distance
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating || _hasReachedHalf) return;

    double dragDistance = _dragStartPosition -
        details.globalPosition.dy; // positive when dragging up

    if (dragDistance >= 0) {
      //Dragging up
      double dragFraction = dragDistance / widget.maxDragDistance;
      double newValue = (_startAnimationValue + dragFraction).clamp(0.0, 1.0);
      _controller.value = newValue;

      if (_controller.value >= 0.5 && !_hasReachedHalf) {
        _hasReachedHalf = true;
        _controller.animateTo(1.0, duration: Duration(milliseconds: 200));
      }
    }
  }

  // Complete the animation when the drags ends
  void _onVerticalDragEnd(DragEndDetails details) {
    if (_controller.isAnimating) return;

    if (!_hasReachedHalf) {
      if (_controller.value >= widget.thresholdValue) {
        _controller.animateTo(1.0, duration: Duration(milliseconds: 200));
      } else {
        _controller.animateBack(0.0, duration: Duration(milliseconds: 200));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Third card (if exists)
                if (_cardData.length > 2)
                  Transform.translate(
                      offset: Offset(0, 20),
                      child: widget.cardBuilder(
                          context, widget.cardData.indexOf(_cardData[2]), 2)),
                // Second card
                if (_cardData.length > 1)
                  Transform.translate(
                    offset: Offset(0, 10),
                    child: widget.cardBuilder(
                        context, widget.cardData.indexOf(_cardData[1]), 1),
                  ),
                // Top card with animation
                Transform.translate(
                  offset: Offset(0, _yOffsetAnimation.value),
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: widget.cardBuilder(
                        context, widget.cardData.indexOf(_cardData[0]), 0),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
