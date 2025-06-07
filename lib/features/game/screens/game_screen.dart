import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/drag_drop_controller.dart';
import '../../../core/widgets/draggable_puzzle_piece.dart';
import '../../../core/constants/game_constants.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Little Learners: Gujarati Match'),
        actions: [
          Consumer<DragDropController>(
            builder: (context, controller, _) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Score: ${controller.score}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DragDropController>().resetGame();
            },
          ),
        ],
      ),
      body: Consumer<DragDropController>(
        builder: (context, controller, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Match the pictures with their Gujarati names!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: GameConstants.spacing,
                  runSpacing: GameConstants.spacing,
                  alignment: WrapAlignment.center,
                  children: controller.pieces.map((piece) {
                    return DraggablePuzzlePiece(
                      piece: piece,
                      onDragStarted: () => controller.startDragging(piece),
                      onDragEnded: (targetPiece) {
                        if (controller.checkMatch(targetPiece)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Great job! 🎉'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 