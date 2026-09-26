// Tests for the real matching-game logic (not the leftover Flutter
// counter-app template test that used to live here).

import 'package:flutter_test/flutter_test.dart';
import 'package:gujarati_match/features/game/models/puzzle_piece.dart';
import 'package:gujarati_match/features/game/controllers/drag_drop_controller.dart';
import 'package:gujarati_match/core/constants/game_constants.dart';

void main() {
  group('PuzzlePiece.canConnectWith', () {
    test('matches when ids are equal and piece types are opposite', () {
      final left = PuzzlePiece(
        id: 'dog',
        imagePath: 'dog.svg',
        gujaratiWord: 'કુતરો',
        audioFile: 'dog.wav',
        pieceType: GameConstants.leftPiece,
      );
      final right = PuzzlePiece(
        id: 'dog',
        imagePath: 'dog.svg',
        gujaratiWord: 'કુતરો',
        audioFile: 'dog.wav',
        pieceType: GameConstants.rightPiece,
      );

      expect(left.canConnectWith(right), isTrue);
      expect(right.canConnectWith(left), isTrue);
    });

    test('does not match when ids differ', () {
      final dogLeft = PuzzlePiece(
        id: 'dog',
        imagePath: 'dog.svg',
        gujaratiWord: 'કુતરો',
        audioFile: 'dog.wav',
        pieceType: GameConstants.leftPiece,
      );
      final catRight = PuzzlePiece(
        id: 'cat',
        imagePath: 'cat.svg',
        gujaratiWord: 'બિલાડી',
        audioFile: 'cat.wav',
        pieceType: GameConstants.rightPiece,
      );

      expect(dogLeft.canConnectWith(catRight), isFalse);
    });

    test('does not match when both pieces are the same side', () {
      final left1 = PuzzlePiece(
        id: 'dog',
        imagePath: 'dog.svg',
        gujaratiWord: 'કુતરો',
        audioFile: 'dog.wav',
        pieceType: GameConstants.leftPiece,
      );
      final left2 = PuzzlePiece(
        id: 'dog',
        imagePath: 'dog.svg',
        gujaratiWord: 'કુતરો',
        audioFile: 'dog.wav',
        pieceType: GameConstants.leftPiece,
      );

      expect(left1.canConnectWith(left2), isFalse);
    });
  });

  group('DragDropController.checkMatch', () {
    late DragDropController controller;

    setUp(() {
      controller = DragDropController();
    });

    PuzzlePiece pieceOf(String pieceType) =>
        controller.pieces.firstWhere((p) => p.pieceType == pieceType);

    test('a correct match increases the score and completes the puzzle', () {
      final left = pieceOf(GameConstants.leftPiece);
      final right = pieceOf(GameConstants.rightPiece);

      controller.startDragging(left);
      final isMatch = controller.checkMatch(right);

      expect(isMatch, isTrue);
      expect(controller.score, 10);
      expect(controller.puzzleCompleted, isTrue);
      expect(controller.completedWord, 'dog');
    });

    test('dragging a piece onto its own side is not a match and awards no score', () {
      final left = pieceOf(GameConstants.leftPiece);

      controller.startDragging(left);
      final isMatch = controller.checkMatch(left);

      expect(isMatch, isFalse);
      expect(controller.score, 0);
      expect(controller.puzzleCompleted, isFalse);
    });
  });
}
