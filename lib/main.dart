import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/game/controllers/drag_drop_controller.dart';
import 'features/game/screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DragDropController(),
      child: MaterialApp(
        title: 'Little Learners: Gujarati Match',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        home: const GameScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 