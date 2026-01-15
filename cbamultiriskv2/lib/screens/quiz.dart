import 'package:cbamultiriskv2/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:cbamultiriskv2/widgets/avatar.dart';
import 'package:cbamultiriskv2/widgets/speechBubble.dart';
import 'package:cbamultiriskv2/services/quizlogic.dart';

//Menu Screen
class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

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
                title: "Answer all the questions you can in 60 seconds."
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CloseButtonWidget(),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Esot es un juego haha")
            ],
          )
        ],
      ),
    );
  }
}