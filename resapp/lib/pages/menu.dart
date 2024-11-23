import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/util/NavBar.dart';


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
          fontWeight: FontWeight.bold
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

          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('¿Qué vamos a mejorar hoy?', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black,),
              
            ),
          ),
          
          // Aquí, el ListView se asegura de no superponerse
          Positioned(
            top: 100,  
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
                  children: [
                // Contenedor con borde redondeado
                Container(
                  
                  margin: EdgeInsets.all(8.0), // Espacio entre los contenedores
                  decoration: BoxDecoration(
                    color: Colores.sColor, // Color de fondo azul
                    borderRadius: BorderRadius.circular(16), // Bordes redondeados
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0), // Espaciado interno
                    leading: Icon(Icons.gamepad, color: Colors.white), // Icono
                    title: Text(
                      'Juego 1',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Texto blanco
                      ),
                    ),
                    subtitle: Text(
                      'Descripción del juego 1',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Acción al seleccionar
                      print('Juego 1 seleccionado');
                    },
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colores.sColor, // Color de fondo azul
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.gamepad, color: Colors.white),
                    title: Text(
                      'Juego 2',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Descripción del juego 2',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      print('Juego 2 seleccionado');
                    },
                  ),
                ),
        
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colores.sColor, 
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.gamepad, color: Colors.white),
                    title: Text(
                      'Juego 3',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Descripción del juego 3',
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
                    color: Colores.sColor, 
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.gamepad, color: Colors.white),
                    title: Text(
                      'Juego 4',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Descripción del juego 4',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      print('Juego 4 seleccionado');
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