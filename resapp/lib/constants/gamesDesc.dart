import 'package:flutter/material.dart';

class Game {
  final String id; // Este es el campo 'id' que usaremos para identificar cada juego
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final IconData icon;
  final String dialogTitle;
  final String description;

  // Constructor para inicializar los campos
  Game({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.icon,
    required this.dialogTitle,
    required this.description,
  });
}


final List<Game> games = [
  Game(
    id: 'attentionGame',
    title: 'Atención',
    subtitle: '¡Mídete con la prueba de Stroop!',
    icon: Icons.psychology,
    dialogTitle: 'Prueba de Stroop',
    description: 'Beneficios:\n- Mejora el autocontrol.\n- Estimula la rapidez mental.\n- Ayuda a desarrollar el control de los impulsos.',
    backgroundColor: Color(0xFF8174A0),
  ),
  Game(
    id: 'memoryGame',
    title: 'Memoria',
    subtitle: 'Ejercita tu memoria con patrones desafiantes.',
    icon: Icons.memory,
    dialogTitle: 'Matriz de Memoria',
    description: 'Beneficios:\n- Refuerza la memoria a corto plazo.\n- Mejora la retención de información.\n- Ayuda en la prevención del Alzheimer.',
    backgroundColor: Color(0xFF6C63FF),
  ),
  Game(
    id: 'reasoningGame',
    title: 'Razonamiento',
    subtitle: 'Pon a prueba tu lógica y habilidades analíticas.',
    icon: Icons.lightbulb,
    dialogTitle: 'Desafío de Razonamiento',
    description: 'Beneficios:\n- Mejora la resolución de problemas.\n- Desarrolla el pensamiento crítico.\n- Incrementa la creatividad.',
    backgroundColor: Color(0xFF58C9B9),
  ),
  Game(
    id: 'mathGame',
    title: 'Cálculo',
    subtitle: 'Entrena tu agilidad mental con ejercicios matemáticos.',
    icon: Icons.calculate,
    dialogTitle: 'Juego de Cálculo',
    description: 'Beneficios:\n- Incrementa la rapidez en cálculos.\n- Mejora las habilidades numéricas.\n- Desarrolla el pensamiento lógico.',
    backgroundColor: Color(0xFFE57373),
  ),
];
