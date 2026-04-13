// import 'package:flutter/material.dart';
// import 'package:lamp/widgets/flip_card.dart';

// // FlipAnimation 위젯 정의
// class FlipAnimation extends StatefulWidget {
//   final List<Color> colors;

//   const FlipAnimation({
//     required this.colors,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<FlipAnimation> createState() => _FlipAnimationState();
// }

// class _FlipAnimationState extends State<FlipAnimation>
//     with TickerProviderStateMixin {
//   late List<FlipCard> dataSource;
//   late List<double> tops;
//   late List<double> lefts;
//   late List<double> widths;
//   late List<double> heights;
//   late List<int> indexes;
//   late List<UniqueKey> flipKeys;
//   late double size;
//   late AnimationController _controller1;
//   late AnimationController _controller2;
//   late AnimationController _controller3;
//   double newDx = 0;
//   double newDy = 0;
//   late Offset center;
//   double initialTop = 500;
//   double initialLeft = 0;
//   late double lastLeft;

//   @override
//   void initState() {
//     super.initState();
//     initializeVariables();
//     initializeControllers();
//     createCards();
//   }

//   @override
//   void dispose() {
//     _controller1.dispose();
//     _controller2.dispose();
//     _controller3.dispose();
//     super.dispose();
//   }

//   // 필드 변수 초기화 함수
//   void initializeVariables() {
//     size = 300;
//     double initialWidth = size;
//     double initialHeight = size / 3 * 2;
//     tops = List.generate(widget.colors.length,
//         (index) => initialTop + index * (size / (size / 20)));
//     lefts = List.generate(
//         widget.colors.length, (index) => initialLeft - index * (size / 20));
//     lastLeft = lefts.last;
//     widths = List.generate(widget.colors.length,
//         (index) => initialWidth + (index * initialWidth / 10));
//     heights = List.generate(widget.colors.length,
//         (index) => initialHeight + (index * initialHeight / 10));
//     indexes = List.generate(widget.colors.length, (index) => index);
//     flipKeys = List.generate(widget.colors.length, (index) => UniqueKey());
//   }

//   //PanUpdate 위치 변형 함수
//   void getWidgetsPositions(DragUpdateDetails details) {
//     setState(() {
//       newDx = details.globalPosition.dx;
//       newDy = details.globalPosition.dy;
//       double diffX = (center.dx - newDx).clamp(-20, 50);
//       double diffY = (center.dy - newDy).clamp(-20, 40);
//       tops = List.generate(
//           widget.colors.length, (index) => initialTop - index * (diffY));
//       lefts = List.generate(
//           widget.colors.length, (index) => initialLeft - index * (diffX));
//       for (int i = 0; i < dataSource.length; i++) {
//         dataSource[i] = dataSource[i].copyWith(
//             top: tops[dataSource[i].index], left: lefts[dataSource[i].index]);
//       }
//     });
//   }

//   // 아래쪽 탭 처리 함수
//   void _handleDownCardTap(int index) {
//     setState(() {
//       for (int i = 0; i < dataSource.length; i++) {
//         if (dataSource[i].index == 0) {
//           dataSource[i] = dataSource[i].copyWith(
//             top: tops[0],
//             left: lefts[0],
//             width: widths[0],
//             height: heights[0],
//           );
//         } else {
//           dataSource[i] = dataSource[i].copyWith(
//             top: tops[dataSource[i].index],
//             left: lefts[dataSource[i].index],
//             width: widths[dataSource[i].index],
//             height: heights[dataSource[i].index],
//           );
//         }
//       }
//       _controller3.reset();
//       _controller3.forward();
//     });
//   }

//   // 카드 전환 처리 함수
//   void _handleSwitchingCardTap(int index) {
//     for (int i = 0; i < dataSource.length; i++) {
//       if (dataSource[i].index == dataSource.length - 1) {
//         dataSource[i] = dataSource[i].copyWith(
//           index: indexes[0],
//         );
//       } else {
//         dataSource[i] = dataSource[i].copyWith(
//           index: dataSource[i].index + 1,
//         );
//       }
//     }
//     _controller2.reset();
//     _controller2.forward().then((_) {
//       _handleDownCardTap(index);
//     });
//   }

//   void _handleUpTap(int index) {
//     setState(() {
//       dataSource[index] = dataSource[index].copyWith(
//         top: 0 + (size / 3),
//         left: lastLeft == dataSource[index].left
//             ? lefts.first
//             : lefts[dataSource[index].index - 1],
//         width: size / 1.2,
//         height: size / 3 * 2 / 1.2,
//       );
//       _controller1.reset();
//       _controller1.forward().then((_) {
//         _handleSwitchingCardTap(index);
//       });
//     });
//   }

//   // 애니메이션 컨트롤러 초기화 함수
//   void initializeControllers() {
//     _controller1 = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );

//     _controller2 = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 0),
//     );

//     _controller3 = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }

//   // 카드 생성 함수
//   void createCards() {
//     dataSource = List.generate(widget.colors.length, (index) {
//       return FlipCard(
//         color: widget.colors[index],
//         top: tops[index],
//         left: lefts[index],
//         width: widths[index],
//         height: heights[index],
//         index: indexes[index],
//         flipKey: flipKeys[index],
//       );
//     });
//   }

//   Widget _buildGeneralWidget(FlipCard data, double radius) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(radius),
//         color: data.color,
//       ),
//     );
//   }

//   Widget _buildRotatedWidget(
//       FlipCard data, Animation<double> animation, double radius) {
//     return RotationTransition(
//       turns:
//           Tween(begin: 0.0, end: 0.5).animate(animation), //end값을 증가 시키면 회전 수 변경
//       child: _buildGeneralWidget(data, radius),
//     );
//   }

//   Widget _buildCardWidget(
//       FlipCard data, Animation<double> animation, double radius, int index) {
//     return GestureDetector(
//       onTap: () {
//         _handleUpTap(index);
//       },
//       onPanUpdate: (details) {
//         getWidgetsPositions(details);
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         width: data.width,
//         height: data.height,
//         curve: Curves.easeInOut,
//         child: data.index == 0
//             ? _buildRotatedWidget(data, _controller3, radius)
//             : data.index == dataSource.length - 1
//                 ? _buildRotatedWidget(data, _controller1, radius)
//                 : _buildGeneralWidget(data, radius),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final screenWidth = screenSize.width;
//     final screenHeight = screenSize.height;
//     center =
//         Offset(screenWidth / 2, screenHeight - initialTop + heights.first / 2);
//     double radius = size * 0.1;
//     return Indexer(children: [
//       ...dataSource.map((data) {
//         int index = dataSource.indexOf(data);
//         return Indexed(
//           key: data.flipKey,
//           index: data.index,
//           child: AnimatedPositioned(
//             duration: const Duration(milliseconds: 500),
//             top: data.top,
//             left: screenWidth / 2 + data.left - widths.first / 2,
//             curve: Curves.easeInOut,
//             child: _buildCardWidget(data, _controller3, radius, index),
//           ),
//         );
//       }).toList(),
//     ]);
//   }
// }
