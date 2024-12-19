import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/util/NavBar.dart';
import 'package:resapp/games/mathGame/math_game.dart';
import 'package:resapp/games/memoryGame/memory_game.dart';
import 'package:resapp/games/attentionGame/attention_game.dart';


class MainMenu extends StatelessWidget{
  const MainMenu({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context){
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text('Brain+', style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
       
      ),

    

      body: Stack(
        children: [
          //Background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colores.qColor
            ),
          ),

          
          
          // Aquí, el ListView se asegura de no superponerse
          Positioned(
            top: 50,  
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
                  children: [
                  Center(
                    child: Container(
                      width: 500,
                      margin: EdgeInsets.all(20.0), // Espacio entre los contenedores
                      decoration: BoxDecoration(
                        color: Colores.pColor, // Color de fondo azul
                        borderRadius: BorderRadius.circular(16), // Bordes redondeados
                      ),
                      child: ListTile(
                       // Espaciado interno
                      
                      title: Text(
                        '¿Qué vamos a mejorar hoy?',textAlign: TextAlign.center,
                        style: TextStyle(
                          
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colores.txtColor, // Texto blanco
                          
                        ),
                      
                      ),
                     
                    ),
                                    ),
                  ),
                // Contenedor con borde redondeado
                Container(
                  
                  margin: EdgeInsets.all(8.0), // Espacio entre los contenedores
                  decoration: BoxDecoration(
                    color: Color(0xFF8174A0), // Color de fondo azul
                    borderRadius: BorderRadius.circular(16), // Bordes redondeados
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0), // Espaciado interno
                    leading: Icon(Icons.gamepad, color: Colores.txtColor), // Icono
                    title: Text(
                      'Juego de Atención',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colores.txtColor, // Texto blanco
                      ),
                    ),
                    subtitle: Text(
                      'Prueba de Stroop',
                      style: TextStyle(color: Colores.txtColor),
                    ),
                    onTap: () {
                      // Acción al seleccionar
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AttentionGame()));
                    },
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFED7D31), // Color de fondo azul
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.gamepad, color: Colors.white),
                    title: Text(
                      'Juego de Memoria',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Matriz de memoria',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MemoryGame()));
                    },
                  ),
                ),
        
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF005B41), 
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.gamepad, color: Colors.white),
                    title: Text(
                      'Juego de Razonamiento',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'RushHour',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      print('Juego 3 seleccionado');
                    },
                  ),
                ),
        
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFB31312), 
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.gamepad, color: Colors.white),
                    title: Text(
                      'Juego matemático',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      '¡Demuestra tus habilidades numéricas!',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MathGame()));
                    },
                  ),
                ),
              ],
            ),
        
        
          
        
        
      )],
        ),
    );

        
   

  
  }
}