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

class suquiAvatar extends StatelessWidget {
  final int posIndex;
  final VoidCallback onTap;

  const suquiAvatar({
    super.key,
    required this.posIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'assets/gif/$posIndex.gif',
        height: MediaQuery.of(context).size.height * 0.35,
        fit: BoxFit.contain,
      ),
    );
  }
}

class SuquiController {
  final Random _random = Random();

  List<SuquiTip> _tips = [];
  int _currentPose = 0;

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
