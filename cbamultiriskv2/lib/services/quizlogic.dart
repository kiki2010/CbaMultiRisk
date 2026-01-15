import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class QuizQuestion {
  final int id;
  final Map<String, String> text;
  final int correct;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.correct
  });

  String getText(String lang) => text[lang] ?? text['es']!;
  
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(id: json['id'], text: json['text'], correct: json['correct']);
  }
}

Future<List<QuizQuestion>> loadQuestion(String lang) async {
  final String response = await rootBundle.loadString('assets/quiz_questions.json');
  final List data = json.decode(response);

  return data.map((q) => QuizQuestion.fromJson(q)).toList();
}