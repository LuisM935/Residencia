import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:resapp/constants/colors.dart';

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
  int score = 0; // Variable para la puntuación


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

    // Reproducir sonido al empezar el juego
    

    Timer(Duration(seconds: 3), () {
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

    // Si el jugador selecciona correctamente
    if (_isGameWon()) {
      setState(() {
        score++;

        _resetGame(); // Incrementa la puntuación cuando acierta toda la matriz
      });
     
      
    } else if (_isGameLost()) {
      
      _showResultDialog("¡Perdiste! Puntuación: $score");
      score = 0;
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
        backgroundColor: Colores.pColor,
        title: Text('Juego de Patrón de Memoria', style: TextStyle(color: Colores.txtColor),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:50,left: 32,right: 32,bottom:0 ),
        child: Column(
          children: [
            // Mostrar la puntuación
            Text(
              'Puntuación: $score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50,),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
