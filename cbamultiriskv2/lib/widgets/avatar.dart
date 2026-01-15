import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

class SuquiTip {
  final int id;
  final String category;
  final String es;
  final String en;

  SuquiTip({
    required this.id,
    required this.category,
    required this.es,
    required this.en,
  });
  
  factory SuquiTip.fromJson(Map<String, dynamic> json) {
    return SuquiTip(
      id: json['id'],
      category: json['category'],
      es: json['es'],
      en: json['en'],
    );
  }

  String text(String locale) {
    return locale == 'en' ? en : es;
  }
}

class SuquiAvatar extends StatelessWidget {
  final int posIndex;
  final double height;
  final VoidCallback onTap;

  const SuquiAvatar({
    super.key,
    required this.posIndex,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'assets/gif/$posIndex.gif',
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

class SuquiController {
  final Random _random = Random();

  List<SuquiTip> _tips = [];
  int _currentPose = 1;

  int get currentPose => _currentPose;
  bool get hasTips => _tips.isNotEmpty;

  Future<void> loadTips() async {
    final jsonString = await rootBundle.loadString(
      'assets/suqui_tips.json',
    );

    final Map<String, dynamic> data = json.decode(jsonString);

    final List tipsJson = data['tips'];

    _tips = tipsJson
      .map((e) => SuquiTip.fromJson(e))
      .toList();
  }

  SuquiTip randomTip({String? category}) {
    final list = category == null
        ? _tips
        : _tips.where((t) => t.category == category).toList();

    return list[_random.nextInt(list.length)];
  }

  void nextPose(int maxPose) {
    _currentPose++;
    if (_currentPose > maxPose) _currentPose = 1;
  }
}

class SuquiButtons extends StatelessWidget {
  void Function(String category) onCategoryTap;
  final VoidCallback onQuizTap;

  SuquiButtons({
    super.key,
    required this.onCategoryTap,
    required this.onQuizTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconButton(
          Icons.local_fire_department,
          () {
            onCategoryTap('fire');
          }
        ),
        iconButton(
          Icons.water,
          () {
            onCategoryTap('flood');
          }
        ),
        iconButton(
          Icons.sports_esports,
          onQuizTap,
        )
      ],
    );
  }
}

Widget iconButton(IconData icon, VoidCallback onTap) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: onTap,
    child: Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF2B70C9)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Color(0xFF2B70C9),),
    ),
  );
}

class SuquiError extends StatelessWidget {
  final String message;

  const SuquiError({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/gif/e.gif',
              height: MediaQuery.of(context).size.height * 0.45,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 16,),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}