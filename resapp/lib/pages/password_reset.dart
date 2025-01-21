import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resapp/constants/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Enviar correo de restablecimiento
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());

      setState(() {
        _isLoading = false;
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Se ha enviado un correo de restablecimiento a ${_emailController.text.trim()}"),
          backgroundColor: Colors.green,
        ),
      );

      // Navegar a la pantalla anterior
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colores.pColor,
        title: Text('Restablecer contraseña', style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colores.qColor
            ),


          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Introduce tu correo electrónico para recibir un enlace de restablecimiento de contraseña:",
              style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                        
                      ), textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Correo electrónico"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text("Enviar Enlace de Restablecimiento", style: TextStyle(
                        color: Colors.white,
                      ),),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 50),
                        backgroundColor: Colores.pColor, 
                         
                        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ))
                        ,
                    ),
                ),
          ],
        ),
            
      ),
    );
  }
}
