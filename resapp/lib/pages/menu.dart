import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resapp/util/NavBar.dart';
//constants
import 'package:resapp/constants/colors.dart';
import 'package:resapp/constants/gamesDesc.dart';




//AttentionGame
import 'package:resapp/games/attentionGame/agMenu.dart';
//Mathgame
import 'package:resapp/games/mathGame/mgMenu.dart';
//MemoryGame
import 'package:resapp/games/memoryGame/memgMenu.dart';
//RazGame
import 'package:resapp/games/RazGame/razgMenu.dart';


class MainMenu extends StatefulWidget{
  @override 
  _MainMenu createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu>{
  
  User? user = FirebaseAuth.instance.currentUser;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(), // Tu widget de navegación lateral
      appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text(
          'Brain+',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colores.qColor,
            ),
          ),

          // ListView para mostrar los juegos
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView.builder(
              itemCount: games.length + 1, // +1 para incluir el mensaje inicial
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Mostrar mensaje inicial al principio
                  return _buildIntroTile(context);
                } else {
                  // Mostrar los juegos
                  final game = games[index - 1]; // Ajustar índice para los juegos
                  return _buildGameTile(context, game);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget para el mensaje inicial
  Widget _buildIntroTile(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        margin: EdgeInsets.all(20.0), // Espacio entre los contenedores
        decoration: BoxDecoration(
          color: Colores.pColor, // Color de fondo azul
          borderRadius: BorderRadius.circular(16), // Bordes redondeados
        ),
        child: ListTile(
          title: Text(
            '¿Qué vamos a mejorar hoy, ${user?.displayName ?? 'username'}?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colores.txtColor, // Texto blanco
            ),
          ),
        ),
      ),
    );
  }

  // Función para construir cada tile de juego
  Widget _buildGameTile(BuildContext context, Game game) {
    return Center(
      child: Container(
        width: 500,
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: game.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: Icon(game.icon, color: Colors.white, size: 30),
          title: Text(
            game.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            game.subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.info_outline_rounded, color: Colors.white, size: 28),
            onPressed: () {
              _showGameDialog(context, game);
            },
          ),
          onTap: () {
            // Navega a la pantalla del juego correspondiente
            _navigateToGame(context, game);
          },
        ),
      ),
    );
  }

  // Función para navegar a la pantalla correspondiente
  void _navigateToGame(BuildContext context, Game game) {
    switch (game.id) {
      case 'attentionGame':
        Navigator.push(context, MaterialPageRoute(builder: (context) => agMenu()));
        break;
      case 'mathGame':
        Navigator.push(context, MaterialPageRoute(builder: (context) => MathGameMenu()));
        break;
      case 'memoryGame':
        Navigator.push(context, MaterialPageRoute(builder: (context) => MemGameMenu()));
        break;
      case 'reasoningGame':
        Navigator.push(context, MaterialPageRoute(builder: (context) => RazGameMenu()));
        break;
      default:
        // Si no se encuentra ningún juego con ese ID
        print('Juego no encontrado');
        break;
    }
  }

  // Función para mostrar el cuadro de diálogo del juego
  void _showGameDialog(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: game.backgroundColor,
          title: Center(
            child: Text(
              game.dialogTitle,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              game.description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}