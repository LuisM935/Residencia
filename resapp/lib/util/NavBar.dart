import 'package:flutter/material.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/pages/login_screen.dart';

class NavBar extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
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
              accountName: Text('username'), 
              accountEmail: Text('email@email.com'),
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen()));
              },
        
        
            ),
          ],
        
        ),
      ),
    );
  }
}