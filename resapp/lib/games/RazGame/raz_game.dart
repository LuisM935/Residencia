import 'dart:math';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/pages/menu.dart';

class RazGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Analogías Aleatorias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnalogiesGame(),
    );
  }
}

class AnalogiesGame extends StatefulWidget {
  @override
  _AnalogiesGameState createState() => _AnalogiesGameState();
}

class _AnalogiesGameState extends State<AnalogiesGame> {
  final Random _random = Random();

  // Lista ampliada de categorías con más palabras
  List<Map<String, List<String>>> categories = [
    {
      'fruta': ['manzana', 'banana', 'naranja', 'pera', 'uva', 'kiwi', 'sandía', 'cereza', 'mango', 'piña'],
      'animal': ['perro', 'gato', 'elefante', 'león', 'conejo', 'tigre', 'ballena', 'zebra', 'jirafa', 'tortuga'],
      'deporte': ['fútbol', 'baloncesto', 'tenis', 'beisbol', 'hockey', 'atletismo', 'boxeo', 'golf', 'natación', 'rugby'],
      'vehículo': ['auto', 'bicicleta', 'avión', 'barco', 'moto', 'camión', 'tren', 'helicóptero', 'patinete', 'cohete'],
      'profesión': ['médico', 'abogado', 'ingeniero', 'profesor', 'arquitecto', 'científico', 'artista', 'escritor', 'veterinario', 'enfermero'],
      'color': ['rojo', 'azul', 'verde', 'amarillo', 'naranja', 'morado', 'rosa', 'blanco', 'negro', 'gris'],
      'instrumento musical': ['piano', 'guitarra', 'batería', 'violín', 'flauta', 'trombón', 'saxofón', 'arpa', 'cello', ' acordeón'],
      'dispositivo' : ['móvil','tablet','computadora','laptop','smartwatch','radio',],
      'flor' : ['tulipan','girasol','orquidea','gerbera','peonia','lirio']
    }
  ];

  Map<String, String> currentAnalogy = {};
  List<String> options = [];
  
  int score = 0; // Variable para llevar la puntuación

  // Generar una analogía aleatoria
  void _generateRandomAnalogy() {
    // Seleccionar dos categorías aleatorias
    var category1 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
    var category2 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];

    // Asegurarse de que las categorías sean diferentes
    while (category1 == category2) {
      category2 = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
    }

    // Seleccionar elementos aleatorios de ambas categorías
    var item1 = categories[0][category1]![_random.nextInt(categories[0][category1]!.length)];
    var item2 = categories[0][category2]![_random.nextInt(categories[0][category2]!.length)];

    // Crear la analogía: "X es a Y como A es a B"
    setState(() {
      currentAnalogy = {
        'question': '$item1 es a $category1 como $item2 es a _______',
        'correctAnswer': category2
      };

      // Generar opciones de respuesta
      options = [
        category1, // Primer categoría seleccionada
        category2, // Segunda categoría seleccionada
        categories[0].keys.toList()[_random.nextInt(categories[0].length)],  // Una categoría aleatoria
      ];

      // Evitar repetir categorías en las opciones
      while (options.length < 4) {
        var newCategory = categories[0].keys.toList()[_random.nextInt(categories[0].length)];
        if (!options.contains(newCategory)) {
          options.add(newCategory);  // Solo agregar si no está ya en la lista
        }
      }
    });
  }

  // Comprobar la respuesta seleccionada
  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == currentAnalogy['correctAnswer']) {
      setState(() {
        score++;  // Incrementar la puntuación si la respuesta es correcta
      });
      _generateRandomAnalogy();  // Generar nueva analogía solo si la respuesta es correcta
    }
    // Si la respuesta es incorrecta, no hacemos nada
  }

  @override
  void initState() {
    super.initState();
    _generateRandomAnalogy(); // Inicializar el primer conjunto de analogías
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de Razonamiento', style: TextStyle(color: Colors.white)),
        backgroundColor: Colores.pColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colores.sColor, Colores.qColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Indicador de puntuación
            Text(
              'Puntaje: $score',  // Mostrar el puntaje en tiempo real
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),

            // Pregunta actual
            Text(
              currentAnalogy['question'] ?? 'Cargando...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),

            // Opciones de respuesta
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

            SizedBox(height: 50,),

            // Botón para regresar al menú
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu()));
                },
                child: Text('Volver al Menú'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
