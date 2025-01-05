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
  // Obtener el tamaño de la pantalla
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Reducir el tamaño máximo del tablero con un factor de escala
  final scaleFactor = 0.8; // Ajusta este factor para reducir el tamaño del tablero
  final boardSize = (screenWidth < screenHeight
          ? screenWidth - 32
          : screenHeight - 120) *
      scaleFactor; // Escalar el tamaño máximo

  final squareSize = boardSize / gridSize; // Tamaño de cada celda

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colores.pColor,
      title: Text(
        'Juego de Patrón de Memoria',
        style: TextStyle(color: Colores.txtColor),
      ),
    ),
    body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white,Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      child: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar la puntuación
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Puntuación: $score',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Tablero de juego ajustado
            Container(
              
              width: boardSize,
              height: boardSize,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Deshabilitar desplazamiento
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
                      decoration: BoxDecoration(
                        color: showPattern && isPatternSquare
                            ? Colors.red
                            : isUserSelected
                                ? Colors.green
                                : Colores.pColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

    
  }

