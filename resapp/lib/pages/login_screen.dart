
import 'package:flutter/material.dart';
import 'package:resapp/pages/password_reset.dart';

import 'package:resapp/pages/signup_screen.dart';
import 'package:resapp/constants/colors.dart';
//firebase

import 'package:resapp/services/auth_service.dart';


class LoginScreen extends StatefulWidget{
  @override 
  _LoginScreen createState() => _LoginScreen();
}
class _LoginScreen extends State<LoginScreen>{
  
  
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  @override

  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [

          
          Container(

        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colores.pColor
        ),
        child: Padding(
         padding: const EdgeInsets.only(top: 60.0, left: 22),
          child: Text('Bienvenido a Brain+\nInicia sesión', style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
          

        )
      ),
        Padding(padding: const EdgeInsets.only(top:200.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40)
              ),
              color: Colores.qColor,
            ),
            
            height: double.infinity,
            width: double.infinity,

            child: Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.mail, color: Colors.black,),
                      label: Text('Correo electrónico', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                      ),)
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.key, color: Colors.black,),
                      label: Text('Contraseña', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                      ),)
                      
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20,),
                  Align(
                    
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ForgotPasswordScreen()));
                      },
                      child: Text('¿Olvidaste tu contraseña?', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                      ),
                    ),
                  ),
                  ),
                  SizedBox(height: 50,),
                  ElevatedButton(
                      
                      onPressed: () async{
                        await AuthService().signin(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context,
                          
                          );

                        
                      
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(350, 50),
                      backgroundColor: Colores.pColor, 
                       
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ))
                      ,
                      child: Text('Iniciar sesion', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                        ),
                      ),
                      
                    ),

                  
                  SizedBox(height: 30,),
                  
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignupScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('¿No tienes una cuenta?', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        ),),
                        Text('Regístrate', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),)
                      ],
                    )
                    )
                  )
              ],
              ),
            ),
          ),
        )
        ],
      )

    );
  }
}