import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // রানটাইম উইজেট এরর লাল/ধূসর স্ক্রিনের বদলে স্ক্রিনে টেক্সট হিসেবে দেখাবে
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'App Error:\n${details.exception}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      ),
    );
  };

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SL IQ Test Earn BD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AdminDashboardScreen(),
    );
  }
}
