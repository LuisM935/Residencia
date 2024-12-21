import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/pages/menu.dart';
//Firebase
import 'package:resapp/services/userscores_service.dart';


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
  int score = 0; //Puntuacion actual
  int mathGameRecord = 0; //Record de juego

  //ID DEL JUEGO
  String gameId = "mathGame";

  final Random random = Random();




  

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
    startTimer();
    _getMathGameRecord();
  }
  // Función para obtener el récord desde Firestore
Future<void> _getMathGameRecord() async {
  try {
    // Obtener el userId desde Firebase Authentication
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'default_user';
    print('Recuperando el récord para el usuario: $userId');
    
    // Llamar al servicio para obtener el récord
    int? record = await GameService().getMathGameRecord(userId);

    // Verificar el valor que se ha recuperado
    print('Recibido el récord: $record');
    
    // Actualizar el estado con el récord recuperado
    setState(() {
      mathGameRecord = record ?? 0; // Si el récord es null, asignar 0
    });

  } catch (e) {
    print('Error al obtener el récord: $e');
  }
}




@override
void dispose() {
  if (timer != null) {
    timer.cancel(); // Asegúrate de que el timer no sea null antes de cancelarlo
  }
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
          
        }
      });
    });
  }

  void checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      setState(() {
        timeLeft = 5 ; // Reiniciar tiempo.
        score++;
if (score > mathGameRecord) {
  mathGameRecord = score;
  print("Nuevo récord alcanzado: $mathGameRecord");
  
  // Actualizar el récord en Firestore
  GameService().saveGameRecord(gameId: gameId, record: mathGameRecord);
}


        generateNewQuestion(); // Generar nueva pregunta.
       
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.bgColor,
      appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text('Juego matemático', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: isGameOver
          ? Center( 
              
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  
                  
                  Text(
                    '¡Juego Terminado!',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Text(
                            'Puntuación: $score',
                            style: TextStyle(fontSize: 20, color: Colores.pColor, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    child: Text('Reiniciar', style: TextStyle(color: Colors.white, fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                      backgroundColor: Colores.pColor, 
                       
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                    
                    onPressed: () {
                      setState(() {
                        isGameOver = false;
                        timeLeft = 5;
                        generateNewQuestion();
                        startTimer();
                        score = 0;
                      });
                    },
                    
                  ),
                  SizedBox(height: 25,),
                  ElevatedButton(
                    child: Text('Salir', style: TextStyle(color: Colors.white, fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                      backgroundColor: Colores.pColor, 
                       
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                    
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu()),
                      (Route<dynamic> route) => false, // Esto elimina todas las rutas de la pila
                    );

                    },
                    
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
                            'Record: $mathGameRecord',
                            style: TextStyle(fontSize: 20, color: Colores.pColor, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                       Text(
                            'Puntuación: $score',
                            style: TextStyle(fontSize: 20, color: Colores.pColor, fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 28, color: Colores.qColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tiempo restante: $timeLeft segundos',
                    style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 30, color: Colores.qColor, fontWeight: FontWeight.bold),
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
