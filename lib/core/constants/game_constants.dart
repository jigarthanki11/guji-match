class GameConstants {
  static const int gridSize = 2;
  static const double pieceSize = 150.0;
  static const double spacing = 20.0;
  
  static const Map<String, String> gujaratiWords = {
    'dog': 'કુતરો',
  };
  
  static const Map<String, String> imageFiles = {
    'dog': 'assets/images/dog.svg',
  };
  
  static const Map<String, String> audioFiles = {
    'dog': 'dog.wav',
  };

  // Puzzle piece types
  static const String leftPiece = 'left';
  static const String rightPiece = 'right';

  // Puzzle piece shapes
  static const Map<String, List<double>> pieceShapes = {
    leftPiece: [0.0, 0.0, 0.5, 1.0],  // x, y, width, height
    rightPiece: [0.5, 0.0, 0.5, 1.0], // x, y, width, height
  };

  // Card types for matching
  static const String imageCard = 'image';
  static const String wordCard = 'word';
} 