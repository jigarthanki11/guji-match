import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../features/game/models/puzzle_piece.dart';
import '../constants/game_constants.dart';

class DraggablePuzzlePiece extends StatelessWidget {
  final PuzzlePiece piece;
  final VoidCallback onDragStarted;
  final Function(PuzzlePiece) onDragEnded;
  final bool isTarget;

  const DraggablePuzzlePiece({
    super.key,
    required this.piece,
    required this.onDragStarted,
    required this.onDragEnded,
    this.isTarget = false,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<PuzzlePiece>(
      data: piece,
      feedback: _buildPiece(context, isDragging: true),
      childWhenDragging: _buildPiece(context, isDragging: true),
      onDragStarted: () => onDragStarted(),
      onDragEnd: (_) => onDragEnded(piece),
      child: _buildPiece(context),
    );
  }

  Widget _buildPiece(BuildContext context, {bool isDragging = false}) {
    return Container(
      width: GameConstants.pieceSize,
      height: GameConstants.pieceSize,
      decoration: BoxDecoration(
        color: piece.isMatched
            ? Colors.green.withOpacity(0.3)
            : isTarget
                ? Colors.blue.withOpacity(0.3)
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: piece.isMatched
              ? Colors.green
              : isTarget
                  ? Colors.blue
                  : Colors.grey,
          width: 2,
        ),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            piece.imagePath,
            width: GameConstants.pieceSize * 0.6,
            height: GameConstants.pieceSize * 0.6,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            piece.gujaratiWord,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 