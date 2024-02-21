// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kurye_takip/components/texts.dart';

class QuestionsAnswersPage extends StatelessWidget {
  const QuestionsAnswersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sorular/Cevaplar"),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomExpansionTile(question: Texts.Question1, answer: Texts.Answer1),
              CustomExpansionTile(question: Texts.Question2, answer: Texts.Answer2),
              CustomExpansionTile(question: Texts.Question3, answer: Texts.Answer3),
              CustomExpansionTile(question: Texts.Question4, answer: Texts.Answer4),
              CustomExpansionTile(question: Texts.Question5, answer: Texts.Answer5),
              CustomExpansionTile(question: Texts.Question6, answer: Texts.Answer6),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  CustomExpansionTile({
    super.key,
    required this.question,
    required this.answer,
  });

  String question = "";
  String answer = "";

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      children: [
        Padding(padding: const EdgeInsets.only(left: 8.0), child: Text(answer)),
      ],
    );
  }
}
