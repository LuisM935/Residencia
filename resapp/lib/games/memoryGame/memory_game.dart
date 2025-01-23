import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/pages/menu.dart';
import 'package:resapp/services/userscores_service.dart';
import 'package:resapp/constants/evaluation.dart';
import 'package:audioplayers/audioplayers.dart';

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  
  final int gridSize = 6;
  final player = AudioPlayer();
  List<int> pattern = [];
  List<bool> userSelection = List.filled(36, false);
  bool showPattern = true;
  bool gameActive = false;
  int patternLength = 5;
  int score = 0; // Variable para la puntuación
  int tempscore = 0;

  int memGameRecord = 0;
  String gameId = "memoryGame";


  

  //Sonidos
  void soundCorrect() async {
    await player.play(AssetSource('audio/correct.mp3'), volume: 1); 
  }

  void soundEnd() async {
    await player.play(AssetSource('audio/game-over2.mp3')); 
  }
    void soundTap() async {
    await player.play(AssetSource('audio/click.mp3')); 
  }



  Future<void> _getMemGameRecord() async {
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
      memGameRecord = record ?? 0; // Si el récord es null, asignar 0
    });

  } catch (e) {
    print('Error al obtener el récord: $e');
  }
}

  @override
  void initState() {
    super.initState();
    _generatePattern();
    _startGame();
    _getMemGameRecord();
    
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
      soundCorrect();
      setState(() {
        score++;
        if (score > memGameRecord) {
            memGameRecord = score;
            print("Nuevo récord alcanzado: $memGameRecord");
            
            // Actualizar el récord en Firestore
            GameService().saveGameRecord(gameId: gameId, record: memGameRecord);
          }
        
        _resetGame(); 
      });
     
      
    } else if (_isGameLost()) {
      soundEnd();
      tempscore = score;
      score = 0;
      soundEnd();
      
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

  void resetScore(){
    score = 0;
  }

  void _resetGame() {
    
    setState(() {
      userSelection = List.filled(gridSize * gridSize, false);
      _generatePattern();
      _startGame();
    });
  }
  


  String valoracion(){

    if (tempscore >= 10 ){

      return "Avanzado \n" + MemLevels.Avanzado;

    }else if (tempscore > 5 ){
      return "Intermedio \n" + MemLevels.Intermedio;
    }

    return "Bajo \n" + MemLevels.Bajo;
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
                image: DecorationImage(
                  image: AssetImage('assets/images/background2.png'),
                  fit: BoxFit.cover,
              ),
              
            ), // Color d
        child: _isGameLost() ? 
        Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text('¡Perdiste!', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
                      Text('Puntuación: $tempscore', style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
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
        
        : Center(
        
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

