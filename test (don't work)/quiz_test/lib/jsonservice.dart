import 'dart:convert';

getQuiz() async {
  var data = jsonDecode("assets/quiz_questions".toString());
  return data;
}