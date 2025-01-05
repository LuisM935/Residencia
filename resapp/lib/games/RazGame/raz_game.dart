import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/pages/menu.dart';



class RazGame extends StatefulWidget {
  @override
  _RazGameState createState() => _RazGameState();
}

class _RazGameState extends State<RazGame> {
  int _timeLeft = 60;
  int _score = 0;
  late Timer _timer;
  bool _isGameOver = false;
  final Random _random = Random();

  // Lista ampliada de categorías con más palabras
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

  // Temporizador
void _startTimer() {
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    if (_timeLeft == 0) {
      _endGame();
    } else {
      if (mounted) { // Verificamos si el widget está montado antes de llamar a setState
        setState(() {
          _timeLeft--;
        });
      }
    }
  });
}

void _endGame() {
  if (mounted) { // Verificamos si el widget está montado antes de llamar a setState
    setState(() {
      _isGameOver = true;
    });
  }
  _timer.cancel();
}

void _resetGame() {
  if (mounted) { // Verificamos si el widget está montado antes de llamar a setState
    setState(() {
      _score = 0;
      _timeLeft = 60;
      _isGameOver = false;
    });
  }
  _generateRandomAnalogy();
  _startTimer();
}




  // Generar una analogía aleatoria
  void _generateRandomAnalogy() {
    var category1 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
    var category2 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];

    // Asegurarse de que las categorías sean diferentes
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

      // Generar opciones de respuesta
      options = [category1, category2];

      // Añadir más categorías sin duplicar
      while (options.length < 4) {
        var newCategory = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
        if (!options.contains(newCategory)) {
          options.add(newCategory);
        }
      }

      // Mezclar las opciones para evitar que siempre aparezcan en el mismo orden
      options.shuffle();
    });
  }

  // Verificar la respuesta seleccionada
  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == currentAnalogy['correctAnswer']) {
      setState(() {
        _score++; // Incrementar la puntuación
      });
      _generateRandomAnalogy(); // Generar una nueva analogía si la respuesta es correcta
    }
  }

  @override
  void initState() {
    super.initState();
    _generateRandomAnalogy(); // Inicializar el primer conjunto de analogías
    _startTimer();
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colores.bgColor, const Color.fromARGB(255, 202, 186, 144)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: _isGameOver
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¡Se acabó el tiempo!',
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Puntuación: $_score',
                      style: TextStyle(fontSize: 20, color: Colors.red),
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
  _timer.cancel(); // Cancelamos el temporizador cuando el widget se destruye
  super.dispose(); // Llamamos a dispose del padre
}
}
