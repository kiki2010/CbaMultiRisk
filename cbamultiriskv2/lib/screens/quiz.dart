import 'package:cbamultiriskv2/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';
import 'package:cbamultiriskv2/services/quizlogic.dart';
import 'package:provider/provider.dart';
import 'package:cbamultiriskv2/l10n/locale_controller.dart';

//Menu Screen
class QuizMenuScreen extends StatefulWidget {
  const QuizMenuScreen({super.key});

  @override
  State<QuizMenuScreen> createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  int highScore = 0;
  int lastScore = 0;

  @override
  void initState() {
    _loadHighScore();
    super.initState();
  }

  Future<void> _loadHighScore() async {
    final score = await ScoreManager().getHighScore();
    final last = await ScoreManager().getLastScore();

    setState(() {
      lastScore = last;
      highScore = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CloseButtonWidget(),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              speechBubble(
                title: "Answer all the questions you can in 60 seconds. Your HighScore is: $highScore | Your last score is: $lastScore"
              ),

              Center(
                child: SuquiAvatar(posIndex: 1, height: 300, onTap: () {}),
              ),

              Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizGameScreen()));
                    _loadHighScore();
                  },
                  child: Text("Jugar"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//game Screen
class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  QuizEngine? engine;
  TimerManager? timer;
  final GifManager gifManager = GifManager();

  String currentGif = 'assets/gif/1.gif';
  bool loading = true;
  
  @override
  void initState() {
    _initGame();
    super.initState();
  }

  Future<void> _initGame() async {
    final lang = context.read<LocaleController>().locale.languageCode;
    final question = await loadQuestion(lang);

    engine = QuizEngine(question);

    timer = TimerManager(duration: 60);
    timer!.start(
      () => setState(() {}),
      _finishGame,
    );

    setState(() {
      currentGif = gifManager.successGif();
      loading = false;
    });
  }

  void _answer(int value) {
    final correct = engine!.answer(value);

    setState(() {
      currentGif = correct
        ? gifManager.successGif()
        : gifManager.errorGif();
    });

    if (!engine!.hasQuestions) {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    timer?.stop();
    await ScoreManager().saveScore(engine!.score);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleController>().locale.languageCode;

    if (loading || engine?.currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const CloseButtonWidget(),

          const SizedBox(height: 30),

          Positioned(
            top: 50,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('⏱️ ${timer!.remaining}s', style: const TextStyle(fontSize: 16)),
                Text('⭐ ${engine!.score}', style: const TextStyle(fontSize: 16))
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              

              speechBubble(title: engine!.currentQuestion!.getText(lang)),

              Center(
                child: Image.asset(
                  currentGif,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _answer(1),
                  child: Text('Verdadero'),
                ),
                ElevatedButton(
                  onPressed: () => _answer(0),
                  child: Text('Falso'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}