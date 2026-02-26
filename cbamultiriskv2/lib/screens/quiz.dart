/*
Quiz Screen
Last Edit: 26/02/2026
Change: if less than 6 answers are correct you get a different message
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Quiz Logic
import 'package:cbamultiriskv2/services/quizlogic.dart';

//Widgets used on the screen
import 'package:cbamultiriskv2/widgets/cards.dart';
import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';

//English or Spanish
import 'package:cbamultiriskv2/l10n/locale_controller.dart';
import 'package:cbamultiriskv2/l10n/app_localizations.dart';

/*
-----------
Menu Screen
-----------
*/
class QuizMenuScreen extends StatefulWidget {
  const QuizMenuScreen({super.key});

  @override
  State<QuizMenuScreen> createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  //Variables for saving the highest and last scores
  int highScore = 0;
  int lastScore = 0;
  int lastCorrect = 0;

  //We start everything (getting the last and highest scores | Saved using sharedPreferences -> lib\services\quizlogic.dart)
  @override
  void initState() {
    _loadHighScore();
    super.initState();
  }

  Future<void> _loadHighScore() async {
    final score = await ScoreManager().getHighScore();
    final last = await ScoreManager().getLastScore();
    final correct = await ScoreManager().getCorrect();

    setState(() {
      lastScore = last;
      highScore = score;
      lastCorrect = correct;
    });
  }

  //Screen Time!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Button for closing the game menu and going back to the Suqui Tips Screen
          const CloseButtonWidget(),

          //Column with a speechBubble with instructions, a Suqui and play button 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              speechBubble(
                title: lastCorrect > 6
                  ? AppLocalizations.of(context)!.gameTitleHigh(highScore, lastScore)
                  : AppLocalizations.of(context)!.gameTitleLow(highScore, lastScore),
                fontSize: 16,
              ),

              Center(
                child: SuquiAvatar(posIndex: 1, height: 300, onTap: () {}),
              ),
            ],
          ),

          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizGameScreen()),
                ).then((_) {
                  _loadHighScore();
                });
              },
              child: Text(AppLocalizations.of(context)!.play),
            ),
          ),
        ],
      ),
    );
  }
}

/*
-----------
Game Screen
-----------
*/
class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  //Timer + game logic
  QuizEngine? engine;
  TimerManager? timer;
  final GifManager gifManager = GifManager();

  bool _initialized = false;

  String currentGif = 'assets/gif/1.gif';
  bool loading = true;
  
  //We load the Timer + game logic 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      _initGame();
    }
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

  //Function for whem an answer is OK or Wrong
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

  //Function for when we finish the game
  Future<void> _finishGame() async {
    timer?.stop();
    await ScoreManager().saveScore(engine!.score, engine!.correctAnswers);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    timer?.stop();
    super.dispose();
  }
  

  //Screen Time!
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleController>().locale.languageCode;

    if (loading || engine?.currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //Timer and score points!
                Text('⏱️ ${timer!.remaining}s', style: const TextStyle(fontSize: 16)),
                Text(AppLocalizations.of(context)!.score(engine!.score), style: const TextStyle(fontSize: 16))
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SpeechBubble with question and Suqui!              

              speechBubble(title: engine!.currentQuestion!.getText(lang), fontSize: 16),

              Center(
                child: Image.asset(
                  currentGif,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          //True or false buttons
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _answer(1),
                  child: Text(AppLocalizations.of(context)!.trueAnswer),
                ),
                ElevatedButton(
                  onPressed: () => _answer(0),
                  child: Text(AppLocalizations.of(context)!.falseAnswer),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}