import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';

class AttentionGame extends StatefulWidget {
  @override
  _AttentionGameState createState() => _AttentionGameState();
}

class _AttentionGameState extends State<AttentionGame> {
  final List<String> _colorNames = ['Rojo', 'Verde', 'Azul', 'Amarillo', 'Naranja'];
  final List<Color> _colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange];
  late String _currentColorName;
  late Color _currentColorText;
  late List<Color> _answerOptions;
  int _score = 0;
  int _timeLeft = 10; // Tiempo en segundos
  late Timer _timer;
  bool _isGameOver = false;

  // Probabilidad de que el nombre del color coincida con el color (0.0 a 1.0)
  double _matchProbability = 0.3;

  @override
  void initState() {
    super.initState();
    _generateRandomColor();
    _startTimer();
  }

  // Generar el color y el texto del nombre con opciones de respuesta
  void _generateRandomColor() {
    final random = Random();
    int colorIndex = random.nextInt(_colorNames.length);
    String selectedColorName = _colorNames[colorIndex];
    Color selectedColor = _colors[colorIndex];

    // Generar el color de texto aleatorio (puede coincidir o no)
    Color textColor;
    if (random.nextDouble() < _matchProbability) {
      textColor = selectedColor; // Coincide con el color
    } else {
      do {
        textColor = _colors[random.nextInt(_colors.length)];
      } while (textColor == selectedColor); // Asegurarnos de que no coincidan
    }

    // Crear opciones de respuesta (una correcta y dos incorrectas)
    List<Color> availableColors = List.from(_colors);  // Copiar la lista original
    availableColors.remove(textColor);  // Eliminar la opción correcta
    availableColors.shuffle();  // Mezclar las opciones incorrectas

    // Añadir la opción correcta
    _answerOptions = [textColor]..addAll(availableColors.take(2)); // Añadir una opción correcta y dos incorrectas
    _answerOptions.shuffle(); // Mezclar las opciones

    setState(() {
      _currentColorName = selectedColorName;
      _currentColorText = textColor;
    });
  }

  // Iniciar el temporizador
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        _endGame();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  // Finalizar el juego
  void _endGame() {
    setState(() {
      _isGameOver = true;
    });
    _timer.cancel();
  }

  // Comprobar la respuesta
  void _checkAnswer(Color selectedColor) {
    bool isCorrect = selectedColor == _currentColorText;
    if (isCorrect) {
      setState(() {
        _score++;
      });
    } else {
      setState(() {
        _score = _score > 0 ? _score - 1 : 0; // Restar si la respuesta es incorrecta
      });
    }
    _generateRandomColor(); // Generar una nueva pregunta
    setState(() {
      _timeLeft = 10; // Resetear el tiempo
    });
  }

  // Reiniciar el juego
  void _resetGame() {
    setState(() {
      _score = 0;
      _timeLeft = 10;
      _isGameOver = false;
    });
    _generateRandomColor();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colores.qColor,
      child: _isGameOver
          ? Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Juego Terminado',
                  style: TextStyle(fontSize: 30, color: Colores.pColor),
                ),
                Text(
                  'Puntuación: $_score',
                  style: TextStyle(fontSize: 25, color: Colores.pColor),
                ),
                ElevatedButton(
                  onPressed: _resetGame,
                  child: Text('Reiniciar'),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tiempo restante: $_timeLeft s',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
                SizedBox(height: 50),
                Text(
                  _currentColorName, // Nombre del color
                  style: TextStyle(
                    fontSize: 50,
                    color: _currentColorText, // Color del texto
                  ),
                ),
                SizedBox(height: 50),
                Column(
                  children: _answerOptions.map((color) {
                    return ElevatedButton(
                      onPressed: () => _checkAnswer(color),
                      style: ElevatedButton.styleFrom(backgroundColor: color), // Correcto
                      child: Text(
                        '',
                        style: TextStyle(color: Colores.pColor),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 50),
                Text(
                  'Puntuación: $_score',
                  style: TextStyle(fontSize: 25, color: Colores.pColor),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
