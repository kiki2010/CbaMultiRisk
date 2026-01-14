import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';

//Quiz questions
class QuizQuestions {
  final int id;
  final String text;
  final int correct;

  QuizQuestions({
    required this.id,
    required this.text,
    required this.correct
  });

  factory QuizQuestions.fromJson(Map<String, dynamic> json, String lang) {
    return QuizQuestions(
      id: json['id'],
      text: json['text'][lang],
      correct: json['correct']
    );
  }
}

//load json
Future<List<QuizQuestions>> loadQuestions(String lang) async {
  final String response =
    await rootBundle.loadString('assets/quiz_questions.json');
  final List data = json.decode(response);

  return data
    .map((q) => QuizQuestions.fromJson(q, lang))
    .toList();
}

//quiz engine (points, random questions, no repetitions, evaluations)
class QuizEngine {
  final List<QuizQuestions> questions;
  final Set<int> used = {};

  int score = 0;
  QuizQuestions? current;

  QuizEngine(this.questions);

  QuizQuestions nextQuestion() {
    final random = Random();
    late QuizQuestions q;

    do {
      q = questions[random.nextInt(questions.length)];
    } while (used.contains(q.id));

    used.add(q.id);
    current = q;
    return q;
  }

  bool answer(int userAnswer) {
    if (current == null) return false;

    final correct = userAnswer == current!.correct;

    if (correct) {
      score += 10;
    } else {
      score -= 5;
    }

    return correct;
  }
}

//random gif
String getRandomSuccessGif() {
  final random = Random().nextInt(5) + 1;
  return 'assets/gif/$random.gif';
}

//Error gif
String getErrorGif() {
  return 'assets/gif/e.gif';
}

//time manager
class TimerManager {
  final int duration;
  late int remaining;
  Timer? _timer;

  TimerManager({this.duration = 60}) {
    remaining = duration;
  }

  void start(void Function() onTick, void Function() onFinish) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

//score manager
class ScoreManager {
  static const String highScoreKey = 'high_score';

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(highScoreKey) ?? 0;
  }

  Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final highScore = prefs.getInt(highScoreKey) ?? 0;

    if (score > highScore) {
      await prefs.setInt(highScoreKey, score);
    }
  }
}

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 20,
      child: IconButton(
        icon: const Icon(Icons.close, size: 28),
        onPressed: () {
          Navigator.of(context)
              .popUntil((route) => route.isFirst);
        },
      ),
    );
  }
}
