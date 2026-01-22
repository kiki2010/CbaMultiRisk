/*
Speech Bubble
last edit: 17/01/2026
Change: comments were added
*/

import 'package:flutter/material.dart';
import 'dart:async';

//To show text like is type (more aesthetic)
class TypewriterText extends StatefulWidget {
  final String text;
  final Duration speed;
  final TextStyle? style;
  final TextAlign textAlign;

  const TypewriterText({
    super.key,
    required this.text,
    this.speed = const Duration(milliseconds: 40),
    this.style,
    this.textAlign = TextAlign.center,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = "";
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_index];
          _index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

//The bubble tail effect for the speechBubble
class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// THE SPEECH BUBBLE
Widget speechBubble({
  required String title,
  String? category,
  double fontSize = 13,
}) {
  final bool showIcon = category != null;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            constraints: const BoxConstraints(
              maxWidth: 180,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3)
                )
              ]
            ),

            child: TypewriterText(
              key: ValueKey(title),
              text: title,
              speed: const Duration(milliseconds: 35),
              style: TextStyle(
                fontSize: fontSize,
                height: 1.2,
                color: Colors.black87
              ),
            ),
          ),
          CustomPaint(
            size: const Size(20, 10),
            painter: BubbleTailPainter(),
          )
        ],
      ),

      //ICON
      if (showIcon)
        Positioned(
        top: -10,
        left: -10,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFF2B70C9)),
          ),
          
          child: Icon(
            _iconFromCategory(category),
            size: 20,
            color: const Color(0xFF2B70C9),
          ),
        ),
      )
    ],
  );
}

//ICON FOR CATEGORY
IconData _iconFromCategory(String category) {
  switch (category) {
    case 'fire':
      return Icons.local_fire_department;

    case 'flood':
      return Icons.flood;

    default:
      return Icons.info;
  }
}