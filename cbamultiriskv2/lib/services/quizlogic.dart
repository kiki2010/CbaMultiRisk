/*
Quiz Logic
last edit: 26/02/2026
Change: Save amount of correct answers
*/

import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:async';

//Get data from the json
class QuizQuestion {
  final int id;
  final String es;
  final String en;
  final int correct;

  QuizQuestion({
    required this.id,
    required this.es,
    required this.en,
    required this.correct
  });

  String getText(String lang) {
    return lang == 'es' ? es : en;
  }
  
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(id: json['id'], es: json['es'], en: json['en'], correct: json['answer']);
  }
}

Future<List<QuizQuestion>> loadQuestion(String lang) async {
  final String response = await rootBundle.loadString('assets/suqui_questions.json');
  final List data = json.decode(response);

  return data.map((q) => QuizQuestion.fromJson(q)).toList();
}

//Random Question and quiz engine
class QuizEngine {
  final List<QuizQuestion> _allQuestions;
  final Random _random = Random();
  List<QuizQuestion> _remainingQuestions = [];

  int score = 0;
  int correctAnswers = 0;
  QuizQuestion? currentQuestion;

  //get question
  QuizEngine(this._allQuestions) {
    _remainingQuestions = List.from(_allQuestions);
    _nextQuestion();
  }

  void _nextQuestion() {
    if(_remainingQuestions.isEmpty) {
      currentQuestion = null;
      return;
    }
    final index = _random.nextInt(_remainingQuestions.length);
    currentQuestion = _remainingQuestions.removeAt(index);
  }

  //+ point - points
  bool answer(int userAnswer){
    if (currentQuestion == null) return false;

    final correct = userAnswer == currentQuestion!.correct;

    if (correct) {
      score += 10;
      correctAnswers++;
      _nextQuestion();
    } else {
      if (score > 0) {
        score -= 5;
      }
    }

    return correct;
  }

  bool get hasQuestions => currentQuestion != null;
}

//Gif manager
class GifManager {
  final Random _random = Random();

  String successGif() {
    final n = _random.nextInt(5) + 1;
    return 'assets/gif/$n.gif';
  }

  String errorGif() => 'assets/gif/e.gif';
}

//Timer
class TimerManager {
  final int duration;
  late int remaining;
  Timer? _timer;

  TimerManager({this.duration = 60}) {
    remaining = duration;
  }

  void start(void Function() onTick, void Function() onFinish) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer)  {
      remaining--;
      onTick();

      if (remaining <= 0) {
        stop();
        onFinish();
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}

//Score Manager
class ScoreManager {
  static const String highScoreKey = 'high_score';
  static const String lastScoreKey = 'last_score';
  static const String correctKey = 'last_correct';

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(highScoreKey) ?? 0;
  }

  Future<int> getLastScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(lastScoreKey) ?? 0;
  }

  Future<int> getCorrect() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(correctKey) ?? 0;
  }

  Future<void> saveScore(int score, int correctAnswers) async {
    final prefs = await SharedPreferences.getInstance();
    final highScore = prefs.getInt(highScoreKey) ?? 0;
    await prefs.setInt(lastScoreKey, score);
    await prefs.setInt(correctKey, correctAnswers);

    if (score > highScore) {
      await prefs.setInt(highScoreKey, score);
    }
  }
}