import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final int gridSize = 6;
  List<int> pattern = [];
  List<bool> userSelection = List.filled(36, false);
  bool showPattern = true;
  bool gameActive = false;
  int patternLength = 5;

  @override
  void initState() {
    super.initState();
    _generatePattern();
    _startGame();
  }

  void _generatePattern() {
    pattern.clear();
    Random random = Random();
    for (int i = 0; i < patternLength; i++) {
      int index = random.nextInt(gridSize * gridSize);
      if (!pattern.contains(index)) {
        pattern.add(index);
      } else {
        i--;
      }
    }
  }

void _startGame() {
  setState(() {
    showPattern = true;
    gameActive = false;
  });

  Timer(Duration(seconds: 3), () {
    // Verifica si el widget todavía está montado antes de llamar a setState
    if (mounted) {
      setState(() {
        showPattern = false;
        gameActive = true;
      });
    }
  });
}


  void _checkSelection(int index) {
    if (!gameActive || showPattern) return;

    setState(() {
      userSelection[index] = !userSelection[index];
    });

    if (_isGameWon()) {
      _showResultDialog("¡Ganaste!");
    } else if (_isGameLost()) {
      _showResultDialog("¡Perdiste!");
    }
  }

  bool _isGameWon() {
    for (int i = 0; i < pattern.length; i++) {
      if (!userSelection[pattern[i]]) {
        return false;
      }
    }
    return true;
  }

  bool _isGameLost() {
    for (int i = 0; i < userSelection.length; i++) {
      if (userSelection[i] && !pattern.contains(i)) {
        return true;
      }
    }
    return false;
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(result),
          actions: [
            TextButton(
              child: Text("Reiniciar"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      userSelection = List.filled(gridSize * gridSize, false);
      _generatePattern();
      _startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de Patrón de Memoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            bool isPatternSquare = pattern.contains(index);
            bool isUserSelected = userSelection[index];

            return GestureDetector(
              onTap: () => _checkSelection(index),
              child: Container(
                color: showPattern && isPatternSquare
                    ? Colors.green
                    : isUserSelected
                        ? Colors.blue
                        : Colors.grey[300],
              ),
            );
          },
        ),
      ),
    );
  }
}
