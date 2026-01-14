//menu
import 'package:flutter/material.dart';
import 'quizlogicandelements.dart';

class QuizMenuScreen extends StatelessWidget {
  final int? lastScore;

  const QuizMenuScreen({super.key, this.lastScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FutureBuilder<int>(
              future: ScoreManager().getHighScore(),
              builder: (context, snapshot) {
                final highScore = snapshot.data ?? 0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (lastScore != null) ...[
                      Text(
                        'Tu puntaje: $lastScore',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      'Récord: $highScore',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuizGameScreen(),
                          ),
                        );
                      },
                      child: Text(
                        lastScore == null ? 'Jugar' : 'Jugar de nuevo',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const CloseButtonWidget(),
        ],
      ),
    );
  }
}

//game

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  QuizEngine? engine;
  TimerManager? timer;
  QuizQuestions? question;
  String? feedbackGif;


  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final questions = await loadQuestions('es');

    engine = QuizEngine(questions);
    question = engine!.nextQuestion();

    timer = TimerManager(duration: 60);
    timer!.start(
      () => setState(() {}),
      _finishGame,
    );

    setState(() {});
  }

  void _answer(int value) async {
  final correct = engine!.answer(value);

  setState(() {
    feedbackGif = correct
        ? getRandomSuccessGif()
        : getErrorGif();
  });

  // Mostrar el gif 600 ms
  await Future.delayed(const Duration(milliseconds: 600));

  if (!mounted) return;

  setState(() {
    feedbackGif = null;
    question = engine!.nextQuestion();
  });
}


  Future<void> _finishGame() async {
    await ScoreManager().saveScore(engine!.score);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizMenuScreen(
          lastScore: engine!.score,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (engine == null || question == null || timer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tiempo: ${timer!.remaining}s',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  question!.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _answer(1),
                    child: const Text('Verdadero'),
                  ),
                  ElevatedButton(
                    onPressed: () => _answer(0),
                    child: const Text('Falso'),
                  ),
                ],
              ),
            ],
          ),
          if (feedbackGif != null)
            Center(
              child: Image.asset(
                feedbackGif!,
                width: 180,
              ),
            ),
          const CloseButtonWidget(),
        ],
      ),
    );
  }
}
