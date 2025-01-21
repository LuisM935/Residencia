import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/pages/menu.dart';
import 'package:resapp/constants/evaluation.dart';
import 'package:resapp/services/userscores_service.dart';






class RazGame extends StatefulWidget {
  @override
  _RazGameState createState() => _RazGameState();
}


class _RazGameState extends State<RazGame> {
  int _timeLeft = 60;
  int _score = 0;
  int _totalQuestions = 0; // Para contar el total de analogías hechas
  int _totalCorrect = 0; // Para contar los aciertos
  double _avgResponseTime = 0; // Para calcular el tiempo promedio de respuesta
  int _startTime = 0; // Para medir el tiempo de respuesta por analogía
  late Timer _timer;
  bool _isGameOver = false;
  final Random _random = Random();
  //Firebase stuff
  int razGameRecord = 0;
  String gameId = "reasoningGame";

  List<Map<String, List<String>>> categories = [
    {
      'Fruta': ['Manzana', 'Banana', 'Naranja', 'Pera', 'Uva', 'Kiwi', 'Sandía', 'Cereza', 'Mango', 'Piña'],
      'Animal': ['Perro', 'Gato', 'Elefante', 'León', 'Conejo', 'Tigre', 'Ballena', 'Zebra', 'Jirafa', 'Tortuga'],
      'Deporte': ['Fútbol', 'Baloncesto', 'Tenis', 'Beisbol', 'Hockey', 'Atletismo', 'Boxeo', 'Golf', 'Natación', 'Rugby'],
      'Vehículo': ['Auto', 'Bicicleta', 'Avión', 'Barco', 'Moto', 'Camión', 'Tren', 'Helicóptero', 'Patinete', 'Cohete'],
      'Profesión': ['Médico', 'Abogado', 'Ingeniero', 'Profesor', 'Arquitecto', 'Científico', 'Artista', 'Escritor', 'Veterinario', 'Enfermero'],
      'Color': ['Rojo', 'Azul', 'Verde', 'Amarillo', 'Naranja', 'Morado', 'Rosa', 'Blanco', 'Negro', 'Gris'],
      'Instrumento musical': ['Piano', 'Guitarra', 'Batería', 'Violín', 'Flauta', 'Trombón', 'Saxofón', 'Arpa', 'Cello', 'Acordeón'],
      'Dispositivo': ['Móvil', 'Tablet', 'Computadora', 'Laptop', 'Smartwatch', 'Radio'],
      'Flor': ['Tulipan', 'Girasol', 'Orquidea', 'Gerbera', 'Peonia', 'Lirio']
    }
  ];

  Map<String, String> currentAnalogy = {};
  List<String> options = [];

Future<void> _getRazGameRecord() async {
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
      razGameRecord = record ?? 0; // Si el récord es null, asignar 0
    });

  } catch (e) {
    print('Error al obtener el récord: $e');
  }
}

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

  void _endGame() {
    setState(() {
      _isGameOver = true;
    });
    _timer.cancel();
  }

  void _resetGame() {
    setState(() {
      _score = 0;
      _timeLeft = 60;
      _totalQuestions = 0;
      _totalCorrect = 0;
      _avgResponseTime = 0;
      _isGameOver = false;
    });
    _generateRandomAnalogy();
    _startTimer();
  }

  void _generateRandomAnalogy() {
    var category1 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
    var category2 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];

    while (category1 == category2) {
      category2 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
    }

    var item1 = categories[0][category1]![_random.nextInt(categories[0][category1]!.length)];
    var item2 = categories[0][category2]![_random.nextInt(categories[0][category2]!.length)];

    setState(() {
      currentAnalogy = {
        'question': '$item1 es a $category1 como $item2 es a _______',
        'correctAnswer': category2
      };

      options = [category1, category2];
      while (options.length < 4) {
        var newCategory = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
        if (!options.contains(newCategory)) {
          options.add(newCategory);
        }
      }
      options.shuffle();
      _startTime = DateTime.now().millisecondsSinceEpoch; // Marca el inicio de la respuesta
    });
  }

void _checkAnswer(String selectedAnswer) async {
  int endTime = DateTime.now().millisecondsSinceEpoch;

  // Calcular el tiempo de respuesta
  double newResponseTime = (endTime - _startTime) / 1000;
  _avgResponseTime = ((_avgResponseTime * _totalQuestions) + newResponseTime) / (_totalQuestions + 1);

  setState(() {
    _totalQuestions++;

    // Verificar si la respuesta es correcta
    if (selectedAnswer == currentAnalogy['correctAnswer']) {
      _score++;
      _totalCorrect++;

      // Si se supera el récord, actualízalo y guárdalo en Firebase
      if (_score > razGameRecord) {
        razGameRecord = _score;

        // Llamar al servicio para guardar el récord
        GameService().saveGameRecord(gameId: gameId, record: razGameRecord);
      }
    }

    // Generar una nueva analogía
    _generateRandomAnalogy();
  });
}


  String calculatePerformanceLevel() {
    double accuracy = (_totalQuestions == 0) ? 0 : (_totalCorrect / _totalQuestions) * 100;

    if (_totalCorrect >= 30 && _avgResponseTime <= 2) {
      return "Avanzado \n" + RazLevels.Avanzado;
    } else if (_totalCorrect >= 15 && _totalCorrect < 30 && _avgResponseTime <= 3) {
      return "Intermedio \n" + RazLevels.Intermedio;
    } else return "Bajo \n" + RazLevels.Bajo;
  }

  
  @override
  void initState() {
    super.initState();
    _generateRandomAnalogy();
    _startTimer();
    _getRazGameRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de Razonamiento', style: TextStyle(color: Colors.white)),
        backgroundColor: Colores.pColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colores.bgColor),
        padding: const EdgeInsets.all(20.0),
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
                          child: Text('Nivel: ${calculatePerformanceLevel()}', 
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        ))
                        
                        ),

                        SizedBox(height: 50,),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Precisión: ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            TextSpan(
                              text: '${((_totalCorrect / _totalQuestions) * 100).toStringAsFixed(2)}%',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Tiempo promedio: ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            TextSpan(
                              text: '${_avgResponseTime.toStringAsFixed(2)} segundos',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 50),
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
                  ],
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Tiempo restante: $_timeLeft s',
                    style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Puntuación: $_score',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 40),
                  Text(
                    currentAnalogy['question'] ?? 'Cargando...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Colores.pColor, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 30),
                  ...options.map<Widget>((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.pColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          elevation: 5,
                        ),
                        child: Text(
                          option,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 50),
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

