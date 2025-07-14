import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pokepedia/screens/home_screen.dart';
import 'package:pokepedia/screens/login_screen.dart';
import 'package:pokepedia/widgets/button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();
bool obscureText = true;

final formKey = GlobalKey<FormState>();

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 232, 81),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Container(
                    height: 300,
                    width: 300,
                    child: Lottie.asset('assets/animations/lottie2.json')),
              ),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "Enter valid Email and password",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                    prefixIconColor: Colors.teal[300],
                    suffixIcon: nameController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            onPressed: () {
                              nameController.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.teal[300],
                            )),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconColor: Colors.teal[300],
                    suffixIcon: emailController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            onPressed: () {
                              emailController.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.teal[300],
                            )),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: TextFormField(
                  obscureText: obscureText,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.password_outlined),
                    prefixIconColor: Colors.teal[300],
                    suffixIcon: passwordController.text.isEmpty
                        ? Container(width: 0)
                        : GestureDetector(
                            child: Icon(
                              Icons.visibility_outlined,
                              color: Colors.teal[300],
                            ),
                            onLongPress: () {},
                            onLongPressUp: () {},
                          ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Container(
              //     height: 55,
              //     width: 200,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.teal[300],
              //     ),
              //     child: Center(
              //         child: Text(
              //       "Login",
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //     )),
              //   ),
              // )
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: LoadingAnimatedButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    registerUser();
                    final form = formKey.currentState;
                    String email = emailController.text;
                    String password = passwordController.text;
                    String name = nameController.text;
                    print("$name is the name");
                    print("$email is the email");
                    print("$password is the password");
                    if(form!.validate()){
                      final email = emailController.text;
                      final password = passwordController.text;
                    }
                    else{}
                  },
                ),
              ),
              Text(
                "Already a user?",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.teal[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() {
    if (passwordController.text == "") {
      Fluttertoast.showToast(
        msg: "Please enter your password",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else if (emailController.text == "") {
      Fluttertoast.showToast(
        msg: "Please enter your email",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else if (nameController.text == "") {
      Fluttertoast.showToast(
        msg: "Please enter your name",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      String email = emailController.text;
      String password = passwordController.text;
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value != null) {
          var user = value.user;
          var uid = user!.uid;
          addUserData(uid);
        }
      }).catchError((e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      });
    }
  }
  void addUserData(String uid) {
    Map<String, dynamic> usersData = {
      'name': nameController.text,
      'password': passwordController.text,
      'email': emailController.text,
      'uid': uid,
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(usersData)
        .then((value) {
       Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: error.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      });
}

}
