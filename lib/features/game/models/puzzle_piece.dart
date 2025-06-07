import '../../../core/constants/game_constants.dart';

class PuzzlePiece {
  final String id;
  final String imagePath;
  final String gujaratiWord;
  final String audioFile;
  bool isMatched;
  bool isDragging;

  PuzzlePiece({
    required this.id,
    required this.imagePath,
    required this.gujaratiWord,
    required this.audioFile,
    this.isMatched = false,
    this.isDragging = false,
  });

  factory PuzzlePiece.fromId(String id) {
    return PuzzlePiece(
      id: id,
      imagePath: GameConstants.imageFiles[id]!,
      gujaratiWord: GameConstants.gujaratiWords[id]!,
      audioFile: GameConstants.audioFiles[id]!,
    );
  }

  PuzzlePiece copyWith({
    String? id,
    String? imagePath,
    String? gujaratiWord,
    String? audioFile,
    bool? isMatched,
    bool? isDragging,
  }) {
    return PuzzlePiece(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      gujaratiWord: gujaratiWord ?? this.gujaratiWord,
      audioFile: audioFile ?? this.audioFile,
      isMatched: isMatched ?? this.isMatched,
      isDragging: isDragging ?? this.isDragging,
    );
  }
} 