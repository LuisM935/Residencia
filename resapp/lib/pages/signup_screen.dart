import 'package:flutter/material.dart';
import 'package:resapp/pages/login_screen.dart';
import 'package:resapp/constants/colors.dart';


class SignupScreen extends StatelessWidget{
  const SignupScreen({Key? key}) : super(key: key);

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
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person, color: Colors.black,),
                      label: Text('Nombre(s)', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                      ),)
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person, color: Colors.black,),
                      label: Text('Apellido(s)', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                      ),)
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.mail, color: Colors.black,),
                      label: Text('Correo electrónico', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                      ),)
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.key, color: Colors.black,),
                      label: Text('Contraseña', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        
                      ),)
                    ),
                  ),
                  
                 
                  SizedBox(height: 100,),
                  Container(
                    
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colores.pColor,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Text('Crear cuenta', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),),),
                    
                  ),
                  SizedBox(height: 50,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen()));
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
