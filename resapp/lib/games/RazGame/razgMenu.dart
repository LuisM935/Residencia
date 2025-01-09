import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/games/RazGame/raz_game.dart';
import 'package:resapp/games/memoryGame/memory_game.dart';
import 'package:resapp/pages/menu.dart';

class RazGameMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text('Juego de Razonamiento', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        color: Colores.bgColor, // Fondo de la pantalla
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildInstructionCard(
              text: 'Analiza las analogías presentadas, y selecciona la respuesta correcta',
              backgroundColor: Colores.pColor,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaciado entre los elementos
              children: [
                Expanded(
                  child: _buildInstructionCard(
                    text: 'Por cada respuesta correcta, sumarás puntos',
                    backgroundColor: Colors.green,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RazGame()));
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
