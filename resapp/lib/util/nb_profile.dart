import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/services/userscores_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  // Lista de IDs de los juegos
  final List<String> gameIds = [
    'mathGame',
    'attentionGame',
    'reasoningGame',
    'memoryGame',
  ];

  // Mapa para almacenar las puntuaciones máximas
  Map<String, int> gameRecords = {};

  @override
  void initState() {
    super.initState();
    _getAllGameRecords(); // Llama al método para obtener todos los récords
  }

  // Método para obtener los récords de todos los juegos
  Future<void> _getAllGameRecords() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'default_user';
      print('Recuperando récords para el usuario: $userId');

      Map<String, int> records = {};

      // Itera sobre los IDs de los juegos y obtiene sus puntuaciones
      for (String gameId in gameIds) {
        int? record = await GameService().getGameRecord(userId, gameId);
        records[gameId] = record ?? 0; // Si el récord es null, asignar 0
      }

      // Actualiza el estado con las puntuaciones recuperadas
      setState(() {
        gameRecords = records;
      });

      print('Récords recuperados: $gameRecords');
    } catch (e) {
      print('Error al obtener los récords: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Esto limita el tamaño al contenido
            crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
            children: [
              // Aquí el primer bloque de texto con el nombre del usuario
              Center(
                child: Container(
                  width: 500, // Definir un ancho fijo de 500px
                  child: ListTile(
                    title: Text(
                      '${user?.displayName ?? 'username'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              // Título de Estadísticas
              Center(
                child: Container(
                  width: 500, // Definir un ancho fijo de 500px
                  child: Text(
                    'Estadísticas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              // Generar dinámicamente las tarjetas para los juegos
              ...gameIds.map((gameId) {
                return Center( // Usar Center para asegurar que el contenido está centrado
                  child: Container(
                    width: 500, // Definir un ancho fijo de 500px
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colores.pColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Icon(
                        _getGameIcon(gameId),
                        color: Colores.txtColor,
                        size: 32,
                      ),
                      title: Text(
                        _getGameName(gameId),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colores.txtColor,
                        ),
                      ),
                      subtitle: Text(
                        'Puntuación máxima: ${gameRecords[gameId] ?? 0}',
                        style: TextStyle(color: Colores.txtColor),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // Método para obtener el nombre del juego según el ID
  String _getGameName(String gameId) {
    switch (gameId) {
      case 'mathGame':
        return 'Juego de Matemáticas';
      case 'attentionGame':
        return 'Juego de Atención';
      case 'reasoningGame':
        return 'Juego de Razonamiento';
      case 'memoryGame':
        return 'Juego de Memoria';
      default:
        return 'Juego Desconocido';
    }
  }

  // Método para obtener el ícono del juego según el ID
  IconData _getGameIcon(String gameId) {
    switch (gameId) {
      case 'mathGame':
        return Icons.calculate; // Ícono de calculadora
      case 'attentionGame':
        return Icons.visibility; // Ícono de ojo
      case 'reasoningGame':
        return Icons.psychology; // Ícono de cerebro/razonamiento
      case 'memoryGame':
        return Icons.memory; // Ícono de chip de memoria
      default:
        return Icons.help_outline; // Ícono genérico por defecto
    }
  }
}
