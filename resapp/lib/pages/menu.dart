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
                        '¿Qué vamos a mejorar hoy, ${user?.displayName ?? 'username'}?',textAlign: TextAlign.center,
                        style: TextStyle(
                          
                          fontSize: 20,
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
                      '¡Mídete con la prueba de Stroop!',
                      style: TextStyle(color: Colores.txtColor),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),  // Ícono de información
                        onPressed: () {
                          // Muestra un cuadro de diálogo con el texto que desees
                          showDialog(
                            
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF8174A0),
                                title: Text('Prueba de Stroop',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                content: Description.AttentionGameDesc,   
                                actions: [
                                  TextButton(
                                    child: Text('Cerrar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },),
                    onTap: () {
                      // Acción al seleccionar
                      Navigator.push(context, MaterialPageRoute(builder: (context) => agMenu()));
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
                    trailing: IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),  // Ícono de información
                        onPressed: () {
                          // Muestra un cuadro de diálogo con el texto que desees
                          showDialog(
                            
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFFED7D31),
                                title: Text('Matriz de Memoria',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                content: Description.MemGDesc,   
                                actions: [
                                  TextButton(
                                    child: Text('Cerrar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MemGameMenu()));
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
                      'Example',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),  // Ícono de información
                        onPressed: () {
                          // Muestra un cuadro de diálogo con el texto que desees
                          showDialog(
                            
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF005B41),
                                title: Text('Juego de Razonamiento',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                content: Description.RazGameDesc,   
                                actions: [
                                  TextButton(
                                    child: Text('Cerrar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RazGameMenu()));
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
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),  // Ícono de información
                        onPressed: () {
                          // Muestra un cuadro de diálogo con el texto que desees
                          showDialog(
                            
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFFB31312),
                                title: Text('Juego matemático',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                content: Description.MathGameDesc,   
                                actions: [
                                  TextButton(
                                    child: Text('Cerrar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MathGameMenu()));
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