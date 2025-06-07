import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';
import '../../../core/constants/game_constants.dart';

class DragDropController extends ChangeNotifier {
  List<PuzzlePiece> _pieces = [];
  PuzzlePiece? _draggedPiece;
  int _score = 0;
  final Map<String, Offset> _initialPositions = {};

  List<PuzzlePiece> get pieces => _pieces;
  PuzzlePiece? get draggedPiece => _draggedPiece;
  int get score => _score;

  DragDropController() {
    _initializePieces();
  }

  void _initializePieces() {
    _pieces = [];
    _initialPositions.clear();
    
    // Create left and right pieces for each word
    for (String id in GameConstants.gujaratiWords.keys) {
      final leftPiece = PuzzlePiece.fromId(id, GameConstants.leftPiece);
      final rightPiece = PuzzlePiece.fromId(id, GameConstants.rightPiece);
      
      // Set initial positions
      leftPiece.position = const Offset(50, 150);
      rightPiece.position = const Offset(200, 150);
      
      _pieces.addAll([leftPiece, rightPiece]);
      
      // Store initial positions
      _initialPositions[leftPiece.id + leftPiece.pieceType] = leftPiece.position;
      _initialPositions[rightPiece.id + rightPiece.pieceType] = rightPiece.position;
    }
  }

  void startDragging(PuzzlePiece piece) {
    _draggedPiece = piece;
    _updatePieceState(piece.id, isDragging: true);
    notifyListeners();
  }

  void updatePiecePosition(String id, String pieceType, Offset newPosition) {
    final index = _pieces.indexWhere((piece) => piece.id == id && piece.pieceType == pieceType);
    if (index != -1) {
      _pieces[index] = _pieces[index].copyWith(position: newPosition);
      notifyListeners();
    }
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

    bool isMatch = _draggedPiece!.canConnectWith(targetPiece);
    
    if (isMatch) {
      _score += 10;
      _updatePieceState(_draggedPiece!.id, isMatched: true);
      _updatePieceState(targetPiece.id, isMatched: true);
      
      // Snap pieces together
      final centerX = (targetPiece.position.dx + _draggedPiece!.position.dx) / 2;
      final centerY = (targetPiece.position.dy + _draggedPiece!.position.dy) / 2;
      
      updatePiecePosition(_draggedPiece!.id, _draggedPiece!.pieceType, 
          Offset(centerX - GameConstants.pieceSize / 2, centerY));
      updatePiecePosition(targetPiece.id, targetPiece.pieceType, 
          Offset(centerX + GameConstants.pieceSize / 2, centerY));
    } else {
      // Return pieces to their initial positions
      final draggedKey = _draggedPiece!.id + _draggedPiece!.pieceType;
      final targetKey = targetPiece.id + targetPiece.pieceType;
      
      if (_initialPositions.containsKey(draggedKey)) {
        updatePiecePosition(_draggedPiece!.id, _draggedPiece!.pieceType, 
            _initialPositions[draggedKey]!);
      }
      if (_initialPositions.containsKey(targetKey)) {
        updatePiecePosition(targetPiece.id, targetPiece.pieceType, 
            _initialPositions[targetKey]!);
      }
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

  void placePieceOnCanvas(String id, String pieceType) {
    final index = _pieces.indexWhere((p) => p.id == id && p.pieceType == pieceType);
    if (index != -1) {
      _pieces[index] = _pieces[index].copyWith(isOnCanvas: true);
      notifyListeners();
    }
  }

  @override
  void resetGame() {
    _score = 0;
    _draggedPiece = null;
    _pieces = _pieces.map((p) => p.copyWith(isOnCanvas: false, isMatched: false, isDragging: false)).toList();
    notifyListeners();
  }
} 