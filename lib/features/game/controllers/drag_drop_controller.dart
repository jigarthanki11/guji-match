import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';
import '../../../core/constants/game_constants.dart';

class DragDropController extends ChangeNotifier {
  List<PuzzlePiece> _pieces = [];
  PuzzlePiece? _draggedPiece;
  int _score = 0;

  List<PuzzlePiece> get pieces => _pieces;
  PuzzlePiece? get draggedPiece => _draggedPiece;
  int get score => _score;

  DragDropController() {
    _initializePieces();
  }

  void _initializePieces() {
    _pieces = GameConstants.gujaratiWords.keys
        .map((id) => PuzzlePiece.fromId(id))
        .toList();
    _pieces.shuffle();
  }

  void startDragging(PuzzlePiece piece) {
    _draggedPiece = piece;
    _updatePieceState(piece.id, isDragging: true);
    notifyListeners();
  }

  void stopDragging() {
    if (_draggedPiece != null) {
      _updatePieceState(_draggedPiece!.id, isDragging: false);
      _draggedPiece = null;
      notifyListeners();
    }
  }

  bool checkMatch(PuzzlePiece targetPiece) {
    if (_draggedPiece == null) return false;

    bool isMatch = _draggedPiece!.id == targetPiece.id;
    if (isMatch) {
      _score += 10;
      _updatePieceState(_draggedPiece!.id, isMatched: true);
      _updatePieceState(targetPiece.id, isMatched: true);
    }

    stopDragging();
    return isMatch;
  }

  void _updatePieceState(String id, {bool? isDragging, bool? isMatched}) {
    final index = _pieces.indexWhere((piece) => piece.id == id);
    if (index != -1) {
      _pieces[index] = _pieces[index].copyWith(
        isDragging: isDragging,
        isMatched: isMatched,
      );
    }
  }

  void resetGame() {
    _score = 0;
    _draggedPiece = null;
    _pieces.forEach((piece) {
      piece.isMatched = false;
      piece.isDragging = false;
    });
    _pieces.shuffle();
    notifyListeners();
  }
} 