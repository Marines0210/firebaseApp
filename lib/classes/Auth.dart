import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


class Auth{
  //Creamos una instancia de la clase  FirebaseAuth para manejar la autenticacion.
   FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Recibimos el correo y la contraseña para poder iniciar session
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  //Recibimos el correo y la contraseña para poder crear la cuenta
  Future<String> createUser(String email, String password) async {
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  //ontener usuario
  Future<String> currentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  //cerrar sesion
  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

}