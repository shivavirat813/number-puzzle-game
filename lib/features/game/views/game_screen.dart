import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<int?> numbers;
  final int cols = 5; // 5x5 board. change to 4 for 4x4
  late int totalTiles;

  @override
  void initState() {
    super.initState();
    totalTiles = cols * cols;
    _initNumbers();
  }

  void _initNumbers() {
    numbers = List<int?>.generate(totalTiles, (i) => i < totalTiles - 1 ? i + 1 : null);
    numbers.shuffle();
    if (!numbers.contains(null)) {
      numbers[totalTiles - 1] = null;
    }
    // ensure not null
    setState(() {});
  }

  void _shuffleSafe() {
    setState(() {
      numbers.shuffle();
      if (!numbers.contains(null)) numbers[totalTiles - 1] = null;
    });
  }

  void _onTileTap(int index) {
    final emptyIndex = numbers.indexOf(null);
    if (emptyIndex == -1) return;

    final rTapped = index ~/ cols;
    final cTapped = index % cols;
    final rEmpty = emptyIndex ~/ cols;
    final cEmpty = emptyIndex % cols;

    final bool isNeighbor =
        (rTapped == rEmpty && (cTapped - cEmpty).abs() == 1) ||
            (cTapped == cEmpty && (rTapped - rEmpty).abs() == 1);

    if (isNeighbor) {
      setState(() {
        numbers[emptyIndex] = numbers[index];
        numbers[index] = null;
      });
    }
  }

  bool _isSolved() {
    for (int i = 0; i < totalTiles - 1; i++) {
      if (numbers[i] != i + 1) return false;
    }
    return numbers[totalTiles - 1] == null;
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final double boardMax = min(screenW * 0.75, 320); // small fixed-limit board
    const double spacing = 6;
    final double cellSize = (boardMax - (cols - 1) * spacing) / cols;

    return Scaffold(
      appBar: AppBar(title: const Text('Number Puzzle')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSolved())
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '🎉 Solved! Tap Restart',
                  style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(
              width: boardMax,
              height: boardMax,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: 1,
                ),
                itemCount: totalTiles,
                itemBuilder: (context, index) {
                  final val = numbers[index];
                  return GestureDetector(
                    onTap: val == null ? null : () => _onTileTap(index),
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: val == null ? Colors.grey[300] : Colors.blueAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: val == null
                            ? const SizedBox.shrink()
                            : Text(
                          '$val',
                          style: TextStyle(
                            fontSize: max(12.0, cellSize * 0.45),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(onPressed: _initNumbers, child: const Text('Restart')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _shuffleSafe, child: const Text('Shuffle')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}