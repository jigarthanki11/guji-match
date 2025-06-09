import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/game/controllers/drag_drop_controller.dart';
import 'features/game/screens/game_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DragDropController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Learners: Gujarati Match',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
} 