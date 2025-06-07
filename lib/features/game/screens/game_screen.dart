import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/drag_drop_controller.dart';
import '../../../core/widgets/draggable_puzzle_piece.dart';
import '../models/puzzle_piece.dart';
import '../../../core/constants/game_constants.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DragDropController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF6FF),
        appBar: AppBar(
          title: const Text('Little Learners: Gujarati Match'),
          actions: [
            Consumer<DragDropController>(
              builder: (context, controller, _) => Row(
                children: [
                  Text('Score: ${controller.score}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => controller.resetGame(),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<DragDropController>(
          builder: (context, controller, _) {
            // Split pieces into tray and canvas
            final trayPieces = controller.pieces.where((p) => !p.isMatched && !p.isOnCanvas).toList();
            final canvasPieces = controller.pieces.where((p) => p.isOnCanvas).toList();
            final slots = GameConstants.gujaratiWords.keys.expand((id) => [GameConstants.leftPiece, GameConstants.rightPiece].map((type) => {'id': id, 'type': type})).toList();

            return Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Connect the puzzle pieces!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                // Canvas area
                Expanded(
                  child: Center(
                    child: Container(
                      width: 400,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Stack(
                        children: [
                          // Empty slots
                          ...slots.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final slot = entry.value;
                            final double x = 60 + (idx % 2) * 160;
                            final double y = 80 + (idx ~/ 2) * 160;
                            final PuzzlePiece? placedPiece = canvasPieces.where((p) => p.id == slot['id'] && p.pieceType == slot['type']).isNotEmpty
                                ? canvasPieces.firstWhere((p) => p.id == slot['id'] && p.pieceType == slot['type'])
                                : null;
                            return Positioned(
                              left: x,
                              top: y,
                              child: DragTarget<PuzzlePiece>(
                                builder: (context, candidateData, rejectedData) {
                                  return placedPiece != null
                                      ? DraggablePuzzlePiece(
                                          piece: placedPiece,
                                          isDraggable: false,
                                          onDragStarted: () {},
                                          onDragEnded: (_) {},
                                        )
                                      : Container(
                                          width: GameConstants.pieceSize,
                                          height: GameConstants.pieceSize,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey, width: 2),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        );
                                },
                                onWillAccept: (piece) {
                                  return piece != null &&
                                    piece.id == slot['id'] &&
                                    piece.pieceType == slot['type'];
                                },
                                onAccept: (piece) {
                                  controller.placePieceOnCanvas(piece.id, piece.pieceType);
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Puzzle tray
                Container(
                  height: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trayPieces.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                      final piece = trayPieces[index];
                      return Draggable<PuzzlePiece>(
                        data: piece,
                        feedback: Material(
                          color: Colors.transparent,
                          child: DraggablePuzzlePiece(
                            piece: piece,
                            isDraggable: false,
                            onDragStarted: () {},
                            onDragEnded: (_) {},
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: DraggablePuzzlePiece(
                            piece: piece,
                            isDraggable: false,
                            onDragStarted: () {},
                            onDragEnded: (_) {},
                          ),
                        ),
                        child: DraggablePuzzlePiece(
                          piece: piece,
                          isDraggable: true,
                          onDragStarted: () {},
                          onDragEnded: (_) {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
} 