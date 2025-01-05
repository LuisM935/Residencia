import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:resapp/pages/menu.dart';




class AuthService {

  //Registro
   Future<void> signup({
    required String email,
    required String password,
    required String username, // Se añade el parámetro username
  }) async {
    try {
      // Crear usuario con Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Actualizar displayName en Firebase Auth
        await user.updateDisplayName(username);

        // Guardar información adicional en Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username, // Guardar el nombre de usuario
        });

        // Mostrar mensaje de éxito
        Fluttertoast.showToast(
          msg: "Registro exitoso",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  //Iniciar sesion
Future<void> signin({
  required String email, 
  required String password, 
  required BuildContext context,
}) async {
  try {
    // Intentamos iniciar sesión con FirebaseAuth
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password,
    );
    
    // Si el inicio de sesión es exitoso, navegamos al menú principal
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (BuildContext context) => MainMenu())
    );
    
  } on FirebaseAuthException catch (e) {
    // Esto captura errores específicos de FirebaseAuth
    String message = '';
    
    if (e.code == 'user-not-found') {
      message = 'No existe un usuario con ese correo electrónico.';
    } else if (e.code == 'wrong-password') {
      message = 'Contraseña incorrecta.';
    } else {
      message = 'An error occurred. Please try again later.';
    }

    // Mostrar el mensaje de error en un Toast
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14,
    );
  } catch (e) {
    // Aquí capturamos cualquier otro tipo de error (no relacionado con FirebaseAuthException)
    print('Unexpected Error: $e');  // Esto ayuda a depurar qué error realmente ocurre
    Fluttertoast.showToast(
      msg: 'An unexpected error occurred. Please try again.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}
}