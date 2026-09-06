import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // ১. মেথড চ্যানেল ইনিশিয়ালাইজেশনের জন্য নিশ্চিত করা
  WidgetsFlutterBinding.ensureInitialized();
  
  // ২. ফায়ারবেস অ্যাপ ইনিশিয়ালাইজ করা
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Test App'),
        ),
        body: const Center(
          child: Text(
            'Firebase Successfully Initialized!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
