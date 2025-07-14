import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pokepedia/screens/home_screen.dart';
import 'package:pokepedia/screens/login_screen.dart';
import 'package:pokepedia/screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCnkoGdCGksN9j-Mqhc7Tc6VJJQGxQoSUE",
        authDomain: "pokepedia-34b2a.firebaseapp.com",
        projectId: "pokepedia-34b2a",
        storageBucket: "pokepedia-34b2a.firebasestorage.app",
        messagingSenderId: "226813547238",
        appId: "1:226813547238:web:19d3a65d9c139f4b6d6127",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(Pokedex());
}

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
