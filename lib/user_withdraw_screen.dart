import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  final String userId;
  const QuizScreen({super.key, required this.userId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int userScore = 0;

  void _answerQuestion(int selectedIndex, int correctIndex, int points) {
    if (selectedIndex == correctIndex) {
      userScore += points;
      // ফায়ারস্টোরে ইউজারের পয়েন্ট যোগ করা
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'points': FieldValue.increment(points)});
    }

    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('কুইজ খেলুন ও ইনকাম করুন')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final docs = snapshot.data!.docs;
          if (currentQuestionIndex >= docs.length) {
            return Center(child: Text('অভিনন্দন! আপনার প্রাপ্ত পয়েন্ট: $userScore'));
          }

          final quiz = docs[currentQuestionIndex].data() as Map<String, dynamic>;
          final options = List<String>.from(quiz['options']['arrayValue']['values'].map((e) => e['stringValue']));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  quiz['questionText']['stringValue'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...options.asMap().entries.map((entry) {
                  return ElevatedButton(
                    onPressed: () => _answerQuestion(
                      entry.key,
                      quiz['correctIndex']['integerValue'],
                      quiz['points']['integerValue'],
                    ),
                    child: Text(entry.value),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}