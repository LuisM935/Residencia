import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/pages/login_screen.dart';
//Firebase






class NavBar extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
    Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print('Usuario cerrado sesión correctamente');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      
      child: Container(
        decoration: BoxDecoration(
          color: Colores.qColor
        ),
        child: ListView(
          
          padding: EdgeInsets.zero,
          
          children: [
            
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colores.pColor
              ),
              accountName: Text(user?.displayName ?? 'Nombre no disponible'),
              accountEmail: Text(user?.email ?? 'Email no disponible'),
              currentAccountPicture: CircleAvatar(
                
                child: ClipOval(
                  //child: Image.x();
                ),
              ),),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: (){
                
              },
        
        
            ),
           
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: (){
                
              },
        
        
            ),
             ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () async {
                // Espera a que la función de cerrar sesión se complete
                await _signOut();

                // Después de cerrar sesión, navega a la pantalla MainMenu
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              
        
        
            ),
          ],
        
        ),
      ),
    );
  }
}