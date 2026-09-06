import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_dashboard.dart';

void main() async {
  // ১. ফ্ল্যাটার উইজেট মেমোরি ঠিকমতো ইনিশিয়ালাইজ করা
  WidgetsFlutterBinding.ensureInitialized();

  // ২. Safe Firebase Initialization (যদি কোনো কারণে ফেল করে অ্যাপ যেন ক্র্যাশ বা ফ্রিজ না হয়)
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
      home: const AdminDashboard(), // আপনার মূল স্ক্রিন বা ড্যাশবোর্ড
    );
  }
}
