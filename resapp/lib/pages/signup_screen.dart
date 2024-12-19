import 'package:flutter/material.dart';
import 'package:resapp/pages/login_screen.dart';
import 'package:resapp/constants/colors.dart';
import 'package:resapp/services/auth_service.dart';



class SignupScreen extends StatefulWidget{
  @override 
  _SignupScreen createState() => _SignupScreen();
}


class _SignupScreen extends State<SignupScreen>{
  


  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController lastnameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  

  @override

  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
            color: Colores.pColor,
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22),
              child: Text('Bienvenido\nCrea una cuenta nueva', style: TextStyle(
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
                topRight: Radius.circular(40),

              ),
              color: Colores.qColor,
            ),
            
            height: double.infinity,
            width: double.infinity,
            
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 18.0,right: 18,top: 60),
              child: Column(
                
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
                        
                      ),
                      
                      )
                    ),

                    obscureText: true,
                  ),
                  
                 
                  SizedBox(height: 100,),
                   
                   ElevatedButton(
                      
                      onPressed: () async{
                        await AuthService().signup(
                          email: emailController.text,
                          password: passwordController.text,
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
                      child: Text('Crear cuenta', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                        ),
                      ),
                      
                    ),
                    
                  
                  SizedBox(height: 50,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Volver', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),),
                        
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
