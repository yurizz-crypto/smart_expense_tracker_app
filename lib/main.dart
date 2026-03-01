import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_app/view_models/expense_viewmodel.dart';
import 'package:smart_expense_tracker_app/views/home_screen.dart';

// This is the main entry point where the application starts its execution.
void main() async {
  // Ensuring the Flutter engine is fully initialized is necessary before running any asynchronous setup tasks.
  WidgetsFlutterBinding.ensureInitialized();

  // This step establishes the connection to Firebase services for backend data management.
  await Firebase.initializeApp();

  runApp(
    // The ChangeNotifierProvider covers the app to make the expense data accessible to any screen that needs it.
    ChangeNotifierProvider(
      create: (context) => ExpenseViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SmartTrackerHome(),
    );
  }
}