import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';

class PuzzlePiece {
  final String id;
  final String imagePath;
  final String gujaratiWord;
  final String audioFile;
  final String pieceType;  // 'left' or 'right'
  bool isMatched;
  bool isDragging;
  Offset position;
  final bool isOnCanvas;

  PuzzlePiece({
    required this.id,
    required this.imagePath,
    required this.gujaratiWord,
    required this.audioFile,
    required this.pieceType,
    this.isMatched = false,
    this.isDragging = false,
    this.position = Offset.zero,
    this.isOnCanvas = false,
  });

  factory PuzzlePiece.fromId(String id, String pieceType) {
    return PuzzlePiece(
      id: id,
      pieceType: pieceType,
      imagePath: GameConstants.imageFiles[id]!,
      gujaratiWord: GameConstants.gujaratiWords[id]!,
      audioFile: GameConstants.audioFiles[id]!,
      isOnCanvas: false,
    );
  }

  PuzzlePiece copyWith({
    String? id,
    String? imagePath,
    String? gujaratiWord,
    String? audioFile,
    String? pieceType,
    bool? isMatched,
    bool? isDragging,
    Offset? position,
    bool? isOnCanvas,
  }) {
    return PuzzlePiece(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      gujaratiWord: gujaratiWord ?? this.gujaratiWord,
      audioFile: audioFile ?? this.audioFile,
      pieceType: pieceType ?? this.pieceType,
      isMatched: isMatched ?? this.isMatched,
      isDragging: isDragging ?? this.isDragging,
      position: position ?? this.position,
      isOnCanvas: isOnCanvas ?? this.isOnCanvas,
    );
  }

  bool canConnectWith(PuzzlePiece other) {
    return id == other.id && 
           ((pieceType == GameConstants.leftPiece && other.pieceType == GameConstants.rightPiece) ||
            (pieceType == GameConstants.rightPiece && other.pieceType == GameConstants.leftPiece));
  }
} 