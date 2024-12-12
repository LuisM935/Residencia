import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';


class MathGame extends StatefulWidget {
  @override
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  int number1 = 0;  // Valor predeterminado.
  int number2 = 0;  // Valor predeterminado.
  String operation = ''; // Valor predeterminado.
  int correctAnswer = 0; // Valor predeterminado.
  List<int> options = []; // Valor predeterminado.
  late Timer timer;
  int timeLeft = 5; // Tiempo límite por pregunta.
  bool isGameOver = false;
  int puntuacion = 0;
  int record = 0;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

void generateNewQuestion() {
  setState(() {
    // Generar números aleatorios entre 1 y 10
    number1 = Random().nextInt(10) + 1;
    number2 = Random().nextInt(10) + 1;

    // Elegir una operación aleatoria
    int operationIndex = Random().nextInt(4);
    switch (operationIndex) {
      case 0: // Suma
        operation = '+';
        correctAnswer = number1 + number2;
        break;
      case 1: // Resta
        operation = '-';
        // Asegurar que el resultado nunca sea negativo
        if (number1 < number2) {
          int temp = number1;
          number1 = number2;
          number2 = temp;
        }
        correctAnswer = number1 - number2;
        break;
      case 2: // Multiplicación
        operation = 'x';
        correctAnswer = number1 * number2;
        break;
      case 3: // División
        operation = '÷';
        // Asegurar que la división sea exacta
        number1 = number1 * number2; // Hacer que number1 sea múltiplo de number2
        correctAnswer = number1 ~/ number2;
        break;
    }

    // Generar opciones aleatorias, incluyendo la respuesta correcta
    options = [
      correctAnswer,
      correctAnswer + Random().nextInt(10) + 1,
      correctAnswer - Random().nextInt(5) - 1,
      correctAnswer + Random().nextInt(5) + 2
    ]..shuffle();
  });
}



  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          isGameOver = true; // Fin del juego si el tiempo se agota.
          puntuacion = 0;
        }
      });
    });
  }

  void checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      setState(() {
        timeLeft = 5 ; // Reiniciar tiempo.
        puntuacion++;
        if(puntuacion > record){
          record++;
        }
        generateNewQuestion(); // Generar nueva pregunta.
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.qColor,
      appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text('Juego matemático'),
        centerTitle: true,
      ),
      body: isGameOver
          ? Center( 
              
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  
                  
                  Text(
                    '¡Juego Terminado!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isGameOver = false;
                        timeLeft = 5;
                        generateNewQuestion();
                        startTimer();
                      });
                    },
                    child: Text('Reiniciar Juego'),
                  ),
                ],
              ),
            )

            
          : Padding(
              padding: const EdgeInsets.all(16.0),
              
              child: Column(
                
                
                   children: [
                    
                 
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                      Text(
                            'Record: $record',
                            style: TextStyle(fontSize: 28, color: Colores.pColor),
                            textAlign: TextAlign.right,
                          ),
                       Text(
                            'Puntuación: $puntuacion',
                            style: TextStyle(fontSize: 28, color: Colores.pColor),
                            textAlign: TextAlign.right,
                          ),
                     ],
                   ),

                  SizedBox(height: 50),

                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0), 
                        color: Colores.pColor,
                        
                      ),
                      padding: EdgeInsets.all(10.0), // Espacio interno dentro del Container
                      child: Text(
                        '¿Cuánto es $number1 $operation $number2?',
                        style: TextStyle(fontSize: 28, color: Colores.qColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tiempo restante: $timeLeft segundos',
                    style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dos botones por fila
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2, // Relación de ancho/alto (mayor valor = botones más anchos)
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.pColor,
                        ),
                        onPressed: () => checkAnswer(options[index]),
                        child: Text(
                          '${options[index]}',
                          style: TextStyle(fontSize: 20, color: Colores.qColor),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
    );
  }
}
