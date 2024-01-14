// login_screen.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthProvider authProvider = AuthProvider();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AuthControlWidget(
          isLoggedIn: authProvider.isLoggedIn(), // Check if the user is logged in
          onLogout: () async {
            await authProvider.signOut();
            // Optionally, navigate to the login screen or handle post-logout logic
            setState(() {
            });
          },
          myevent: false,
        ),
      ),
     body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: Icon(
          Icons.pets,
          size: 300.0,
          color: Colors.green,
        ),
      ),
      SizedBox(height: 120.0),
      TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Enter your email',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.green,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
      SizedBox(height: 16.0),
      TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Enter your password',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.green,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
      SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () async {
          firebase_auth.User? user =
              await authProvider.signInWithEmailAndPassword(
            emailController.text.trim(),
            passwordController.text.trim(),
          );

          if (user != null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/guardian_event_screen',
              (route) => false,
            );
          } else {
            setState(() {
              errorMessage = 'Login failed. Please check your credentials.';
            });
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green, // Background color for the Login button
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3.0,
        ),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      if (errorMessage != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
        ),
    ],
  ),
),
);
}
}