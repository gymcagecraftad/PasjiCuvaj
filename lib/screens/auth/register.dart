// register_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';
import '/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthProvider authProvider = AuthProvider();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
            setState(() {
            });
          },
          myevent: false,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your account',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            Padding(
  padding: EdgeInsets.symmetric(vertical: 16.0),
  child: TextFormField(
    controller: usernameController,
    style: TextStyle(
      fontSize: 18.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: 'Username',
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: Icon(Icons.person, color: Colors.green),
    ),
  ),
),
            Padding(
  padding: EdgeInsets.symmetric(vertical: 16.0),
  child: TextFormField(
    controller: nameController,
    style: TextStyle(
      fontSize: 18.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: 'Name',
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: Icon(Icons.person, color: Colors.green),
    ),
  ),
),
            Padding(
  padding: EdgeInsets.symmetric(vertical: 16.0),
  child: TextFormField(
    controller: surnameController,
    style: TextStyle(
      fontSize: 18.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: 'Surname',
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: Icon(Icons.person, color: Colors.green),
    ),
  ),
),
            Padding(
  padding: EdgeInsets.symmetric(vertical: 16.0),
  child: TextFormField(
    controller: emailController,
    style: TextStyle(
      fontSize: 18.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: 'Email',
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: Icon(Icons.email, color: Colors.green),
    ),
  ),
),
            
          Padding(
  padding: EdgeInsets.symmetric(vertical: 16.0),
  child: TextFormField(
    controller: passwordController,
    style: TextStyle(
      fontSize: 18.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: 'Password',
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: Icon(Icons.lock, color: Colors.green),
    ),
  ),
),
            Padding(
  padding: EdgeInsets.symmetric(vertical: 16.0),
  child: TextFormField(
    controller: confirmPasswordController,
    style: TextStyle(
      fontSize: 18.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: 'Confirm password',
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      prefixIcon: Icon(Icons.lock, color: Colors.green),
    ),
  ),
),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  setState(() {
                    errorMessage = 'Passwords do not match. Please check again.';
                  });
                  return;
                }
                

                firebase_auth.User? user =
                    await authProvider.registerWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  nameController.text.trim(),
                  surnameController.text.trim(),
                  usernameController.text.trim()
                );

                if (user != null) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/guardian_event_screen',
                    (route) => false,
                  );;
                } else {
                  setState(() {
                    errorMessage = 'Registration failed. Please try again.';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
    primary: Colors.green, // Background color for the Register button
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    elevation: 3.0,
  ),
  child: Text(
    'Register',
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