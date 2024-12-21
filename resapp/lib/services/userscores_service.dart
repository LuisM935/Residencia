import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para guardar la puntuación
  Future<void> saveGameRecord({
    required String gameId,  // Identificador único del juego
    required int record,      // Puntuación que el usuario ha obtenido
  }) async {
    try {
      // Obtener el usuario actual
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Referencia al documento del usuario
        DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

        // Actualizar el registro de puntuación para el juego en el campo 'records'
        await userDoc.set({
          'records': {
            gameId: record, // Guarda la puntuación del juego
          }
        }, SetOptions(merge: true)); // merge: true permite combinar con datos existentes
      }
    } catch (e) {
      print('Error al guardar el récord: $e');
    }
  }


  // Método para obtener el récord de puntuación del juego de matemáticas
Future<int?> getMathGameRecord(String userId) async {
  try {
    // Acceder al documento del usuario en Firestore
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot snapshot = await userDocRef.get();

    // Verifica si el documento existe
    if (snapshot.exists) {
      // Asegúrate de que los datos son un Map
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Verifica si 'records' es un mapa y contiene 'mathGame'
      if (data.containsKey('records') && data['records'] is Map<String, dynamic>) {
        Map<String, dynamic> records = data['records'] as Map<String, dynamic>;
        
        if (records.containsKey('mathGame')) {
          int record = records['mathGame'];  // Accede al campo mathGame dentro del mapa 'records'
          print('Récord recuperado desde Firestore: $record');
          return record;
        } else {
          print('El campo mathGame no está presente dentro de records, devolviendo 0');
          return 0;  // Si no se encuentra el campo mathGame, devuelve 0
        }
      } else {
        print('El campo records no está presente o no es un mapa válido');
        return 0;  // Si records no existe o no es un mapa, devuelve 0
      }
    } else {
      print('Documento no encontrado, devolviendo 0');
      return 0;  // Si el documento no existe, devuelve 0
    }
  } catch (e) {
    print('Error al recuperar el récord de Firestore: $e');
    return 0;  // Si ocurre un error, devuelve 0
  }
}




}
