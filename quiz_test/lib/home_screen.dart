import 'package:flutter/material.dart';
import 'quiz.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla inicial')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Abrir Quiz'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QuizMenuScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
