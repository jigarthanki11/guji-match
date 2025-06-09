import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controllers/drag_drop_controller.dart';
import '../../../core/widgets/draggable_puzzle_piece.dart';
import '../models/puzzle_piece.dart';
import '../../../core/constants/game_constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _tickController;
  late Animation<double> _tickScale;
  bool _showDescription = false;
  bool _audioPlayed = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _lastCompletedWord;

  @override
  void initState() {
    super.initState();
    _tickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _tickScale = CurvedAnimation(parent: _tickController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _tickController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSuccessAudio(String word) async {
    // Play only the Gujarati pronunciation placeholder (testsound.mp3)
    await _audioPlayer.play(AssetSource('audio/testsound.mp3'));
  }

  void _onPuzzleCompleted(String word) async {
    print('[_onPuzzleCompleted] Triggered for word: $word');
    setState(() {
      _showDescription = false;
      _audioPlayed = false;
      _lastCompletedWord = word;
    });
    _tickController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _showDescription = true;
      print('[_onPuzzleCompleted] Showing description for word: $word');
    });
    await Future.delayed(const Duration(milliseconds: 100));
    if (!_audioPlayed) {
      _audioPlayed = true;
      print('[_onPuzzleCompleted] Playing audio for word: $word');
      _playSuccessAudio(word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FF),
      appBar: AppBar(
        title: const Text('Little Learners: Gujarati Match'),
        actions: [
          Consumer<DragDropController>(
            builder: (context, controller, _) => Row(
              children: [
                Text('Score: [32m${controller.score}[0m', style: const TextStyle(fontWeight: FontWeight.bold)),
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
          // Listen for puzzle completion and trigger animation/audio
          if (controller.puzzleCompleted && controller.completedWord != null && controller.completedWord != _lastCompletedWord) {
            print('[GameScreen] Puzzle completed detected in UI for word: ${controller.completedWord}');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onPuzzleCompleted(controller.completedWord!);
            });
          }
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
                                print('[DragTarget] onAccept called for piece: [32m${piece.id}[0m, type: ${piece.pieceType}');
                                controller.placePieceOnCanvas(piece.id, piece.pieceType);
                              },
                            ),
                          );
                        }).toList(),
                        // Green tick animation and description
                        if (controller.puzzleCompleted && controller.completedWord != null) ...[
                          Positioned(
                            top: 10,
                            left: 150,
                            child: ScaleTransition(
                              scale: _tickScale,
                              child: SvgPicture.asset(
                                'assets/images/tick.svg',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          if (_showDescription)
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  controller.completedWord!,
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ),
                            ),
                        ],
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
    );
  }
} 