import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/constants/evaluation.dart';
import 'package:resapp/pages/menu.dart';
import 'package:resapp/services/userscores_service.dart';

class AttentionGame extends StatefulWidget {
  @override
  _AttentionGameState createState() => _AttentionGameState();
}

class _AttentionGameState extends State<AttentionGame> {
  final List<String> _colorNames = ['Rojo', 'Verde', 'Azul','Naranja'];
  final List<Color> _colors = [Colors.red, Colors.green, Colors.blue, Colors.orange];
  late String _currentColorName;
  late Color _currentColorText;
  late List<Color> _answerOptions;
  int _score = 0;
  int _timeLeft = 60; // Tiempo en segundos
  late Timer _timer;
  bool _isGameOver = false;
   final player = AudioPlayer();

  // Probabilidad de que el nombre del color coincida con el color (0.0 a 1.0)
  double _matchProbability = 0.3;


  int attGameRecord = 0;
  String gameId = "attentionGame";

  //Sonidos
  void soundCorrect() async {
    await player.play(AssetSource('audio/correct.mp3')); 
  }
   void soundError() async {
    await player.play(AssetSource('audio/error.mp3')); 
  }
     void soundEnd() async {
    await player.play(AssetSource('audio/game-over.mp3')); 
  }

  Future<void> _getAttGameRecord() async {
    try {
    // Obtener el userId desde Firebase Authentication
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'default_user';
    print('Recuperando el récord para el usuario: $userId');
    
    // Llamar al servicio para obtener el récord
    int? record = await GameService().getGameRecord(userId, gameId);

    // Verificar el valor que se ha recuperado
    print('Recibido el récord: $record');
    
    // Actualizar el estado con el récord recuperado
    setState(() {
      attGameRecord = record ?? 0; // Si el récord es null, asignar 0
    });

  } catch (e) {
    print('Error al obtener el récord: $e');
  }
}

  @override
  void initState() {
    super.initState();
    _generateRandomColor();
    _startTimer();
    _getAttGameRecord();
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
    soundEnd();
    setState(() {
      _isGameOver = true;
    });
    _timer.cancel();
  }

  // Comprobar la respuesta
  void _checkAnswer(Color selectedColor) {
    bool isCorrect = selectedColor == _currentColorText;
    if (isCorrect) {
      soundCorrect();
      setState(() {
        _score++;
        if (_score > attGameRecord) {
            attGameRecord = _score;
            print("Nuevo récord alcanzado: $attGameRecord");
            
            // Actualizar el récord en Firestore
            GameService().saveGameRecord(gameId: gameId, record: attGameRecord);
          }
      });
    } else {
      soundError();
    }
    _generateRandomColor(); // Generar una nueva pregunta
    
  }

  // Reiniciar el juego
  void _resetGame() {
    setState(() {
      _score = 0;
      _timeLeft = 60;
      _isGameOver = false;
    });
    _generateRandomColor();
    _startTimer();
  }

    String valoracion(){

    if (_score >= 70 ){

      return "Avanzado \n" + AttLevels.Avanzado;

    }else if (_score >= 50 ){
      return "Intermedio \n" + AttLevels.Intermedio;
    }

    return "Bajo \n" + AttLevels.Bajo;
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text('Juego de atención', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background2.png'),
                  fit: BoxFit.cover,
              ),
              
            ), // Color de fondo
      child: _isGameOver
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text('¡Se acabó el tiempo!', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
                      Text('Puntuación: $_score', style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
                      SizedBox(height: 50,),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colores.pColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text('Nivel: ${valoracion()}',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        ))
                        
                        ),

                        SizedBox(height: 50,),
                      ElevatedButton(
                        onPressed: _resetGame,
                        child: Text('Reiniciar', style: TextStyle(color: Colores.txtColor, fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 50),
                          backgroundColor: Colores.pColor,
                          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                                // Navegar al menú principal (a la pantalla 'menu.dart')
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => MainMenu()), // Asegúrate de tener la clase Menu importada
                                );
                              },
                      child: Text('Volver al Menú', style: TextStyle(color: Colores.txtColor, fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(300, 50),
                        backgroundColor: Colores.pColor,
                        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
            ]),
        )
        
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tiempo restante: $_timeLeft s',
                  style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Text(
                  _currentColorName, // Nombre del color
                  style: TextStyle(
                    fontSize: 50,
                    color: _currentColorText, // Color del texto
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                Wrap( // Uso de Wrap para manejar múltiples opciones
                  spacing: 10, // Espacio horizontal entre botones
                  runSpacing: 10, // Espacio vertical entre filas
                  children: _answerOptions.map((color) {
                    return ElevatedButton(
                      onPressed: () => _checkAnswer(color),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                         // Contraste
                      ),
                      child:SizedBox(),
                    );
                  }).toList(),
                ),
                SizedBox(height: 50),
                Text(
                  'Puntuación: $_score',
                  style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    ),
  );
}



  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
