import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/games/attentionGame/attention_game.dart';

import 'package:resapp/pages/menu.dart';

class agMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text('Juego de atención', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        color: Colores.bgColor, // Fondo de la pantalla
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildInstructionCard(
              text: 'Selecciona el COLOR del texto que aparece en pantalla en el tiempo establecido.',
              backgroundColor: Colores.pColor,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaciado entre los elementos
              children: [
                Expanded(
                  child: _buildInstructionCard(
                    text: 'Realiza la mayor cantidad de puntos.',
                    backgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 10), // Espaciado entre los contenedores
                Expanded(
                  child: _buildInstructionCard(
                    text: 'El juego termina al acabar el tiempo.',
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 150,), // Empuja el siguiente contenido hacia la parte inferior de la pantalla
            const Text(
              '¿Estás listo para jugar?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Acción para el botón "Jugar"
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AttentionGame()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colores.pColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: const Text(
                    'Jugar',
                    style: TextStyle(fontSize: 18, color: Colores.txtColor, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainMenu()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colores.pColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: const Text(
                    'Regresar',
                    style: TextStyle(fontSize: 18, color: Colores.txtColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Espaciado adicional al final
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard({
    required String text,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colores.txtColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
