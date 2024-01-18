import 'package:flutter/material.dart';
import 'package:gym_app_real/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app_real/password_reset.dart';
import 'package:gym_app_real/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailControl = TextEditingController();
  final _passwordControl = TextEditingController();

  @override
  void dispose() {
    _emailControl.clear();
    _passwordControl.clear();
    _emailControl.dispose();
    _passwordControl.dispose();
    super.dispose();
  }

  void _login() {
    String email = _emailControl.text;
    String password = _passwordControl.text;

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print("Successful log in"!);
      _emailControl.clear();
      _passwordControl.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
    }).catchError((error) {
      print("Error logging in!");
      print(error);
      _showErrorDialog(error.toString());
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(color: Colors.black), // Custom title style
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                message,
                style: TextStyle(color: Colors.white), // Custom content style
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Dismiss',
                style:
                    TextStyle(color: Colors.white)), // Custom button text style
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
          ),
        ],
        backgroundColor:
            Colors.deepOrange, // Set the background color to deep orange
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)), // Rounded corners
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            // Image
            Image(
              image: NetworkImage(
                  'https://static.vecteezy.com/system/resources/thumbnails/013/146/831/small/body-builder-lifting-a-dumbbell-png.png'),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height *
                  0.35, // Adjust the height as needed
            ),

            // Login Text and Text Fields
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: _emailControl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: _passwordControl,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),

            // Forgot Password and Sign Up Prompts
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordResetPage()),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.deepOrange,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SignupPage(title: "Sign up page")),
                    );
                  },
                  child: Text(
                    'New? Sign Up!',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.deepOrange,
                    ),
                  ),
                ),
              ],
            ),

            // Login Button
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(
                      color: Colors.black,
                      width: 2.0,
                      style: BorderStyle.solid)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepOrange),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                  ),
                ),
                child: Text('Login'),
                onPressed: () {
                  _login();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
