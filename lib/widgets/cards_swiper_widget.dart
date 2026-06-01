import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

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
  final bool shouldStartCardCollectionAnimation;
  final void Function(bool value) onCardCollectionAnimationComplete;

  // Offset and scale parameters
  final double topCardOffsetStart;
  final double topCardOffsetEnd;
  final double topCardScaleStart;
  final double topCardScaleEnd;

  final double secondCardOffsetStart;
  final double secondCardOffsetEnd;
  final double secondCardScaleStart;
  final double secondCardScaleEnd;

  final double thirdCardOffsetStart;
  final double thirdCardOffsetEnd;
  final double thirdCardScaleStart;
  final double thirdCardScaleEnd;

  const CardsSwiperWidget({
    required this.cardData,
    required this.cardBuilder,
    this.animationDuration = const Duration(milliseconds: 800),
    this.downDragDuration = const Duration(milliseconds: 300),
    this.maxDragDistance = 220.0,
    this.thresholdValue = 0.3,
    this.onCardChange,
    // Default offset and scale values
    this.topCardOffsetStart = 0.0,
    this.topCardOffsetEnd = -15.0,
    this.topCardScaleStart = 1.0,
    this.topCardScaleEnd = 0.9,
    this.secondCardOffsetStart = -15.0,
    this.secondCardOffsetEnd = 0.0,
    this.secondCardScaleStart = 0.95,
    this.secondCardScaleEnd = 1.0,
    this.thirdCardOffsetStart = -30.0,
    this.thirdCardOffsetEnd = -15.0,
    this.thirdCardScaleStart = 0.9,
    this.thirdCardScaleEnd = 0.95,
    this.shouldStartCardCollectionAnimation = false,
    required this.onCardCollectionAnimationComplete,
    super.key,
  });

  @override
  State<CardsSwiperWidget<T>> createState() => _CardsSwiperWidgetState<T>();
}

//Building the State Class
class _CardsSwiperWidgetState<T> extends State<CardsSwiperWidget<T>>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _yOffsetAnimation;
  Animation<double>? _rotationAnimation;
  Animation<double>? _animation;
  AnimationController? _downDragController;
  Animation<double>? _downDragAnimation;
  AnimationController? _cardCollectionAnimationController;
  Animation<double>? _cardCollectionyOffsetAnimation;

  double _startAnimationValue = 0.0;
  double _dragStartPosition = 0.0;
  double _dragOffset = 0.0;
  bool _isCardSwitched = false;
  bool _hasReachedHalf = false;
  bool _isAnimationBlocked = false;
  bool _shouldPlayVibration = true;

  late List<T> _cardData;

  Timer? _debounceTimer;

  Widget? _topCardWidget;
  int? _topCardIndex;

  Widget? _secondCardWidget;
  int? _secondCardIndex;

  Widget? _thirdCardWidget;
  int? _thirdCardIndex;

  Widget? _poppedCardWidget;
  int? _poppedCardIndex;

  Future<void> onCardSwitchVibration() async {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 250), () {
      HapticFeedback.selectionClick();
    });
  }

  Future<void> onCardBlockVibration() async {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.lightImpact();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      HapticFeedback.mediumImpact();
    });
  }

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
    _animation = CurvedAnimation(
      parent: _controller ?? AnimationController(vsync: this),
      curve: Curves.easeInOut,
    );

    // Define the yOffset animation using TweenSequence
    _yOffsetAnimation = Tween<double>(
      begin: 0.0,
      end: -widget.maxDragDistance,
    ).animate(_animation ?? const AlwaysStoppedAnimation(0.0));

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
