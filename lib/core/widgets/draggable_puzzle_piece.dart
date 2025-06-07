import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../features/game/models/puzzle_piece.dart';
import '../constants/game_constants.dart';

class DraggablePuzzlePiece extends StatelessWidget {
  final PuzzlePiece piece;
  final VoidCallback onDragStarted;
  final Function(PuzzlePiece) onDragEnded;
  final bool isTarget;
  final bool isDraggable;

  const DraggablePuzzlePiece({
    super.key,
    required this.piece,
    required this.onDragStarted,
    required this.onDragEnded,
    this.isTarget = false,
    this.isDraggable = true,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPiece(context);
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
      child: ClipRect(
        child: Transform.translate(
          offset: Offset(
            piece.pieceType == GameConstants.leftPiece ? 0 : -GameConstants.pieceSize,
            0,
          ),
          child: SvgPicture.asset(
            piece.imagePath,
            width: GameConstants.pieceSize * 2,
            height: GameConstants.pieceSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
} 