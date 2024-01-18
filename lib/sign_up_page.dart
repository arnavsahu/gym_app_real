import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app_real/nav_bar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});

  final String title;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailControl = TextEditingController();
  final _passwordControl = TextEditingController();
  final _nameControl = TextEditingController();
  final _addressControl = TextEditingController();

  @override
  void dispose() {
    _emailControl.clear();
    _passwordControl.clear();
    _nameControl.clear();
    _passwordControl.clear();
    _emailControl.dispose();
    _passwordControl.dispose();
    _nameControl.dispose();
    _addressControl.dispose();
    super.dispose();
  }

  void _signup() {
    String email = _emailControl.text;
    String password = _passwordControl.text;
    String name = _nameControl.text;
    String address = _addressControl.text;

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print("Successful Sign up!");
      _emailControl.clear();
      _passwordControl.clear();
      _nameControl.clear();
      _addressControl.clear();
      if (value.user != null) {
        String userId = value.user!.uid;
        FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': email,
          'name': name,
          'address': address,
          'Calories Consumed': 0,
          'Protein Consumed': 0,
          'Carbs Consumed': 0,
          'Daily Calories': 0,
          'Daily Protein': 0,
          'Daily Carbs': 0,
          'Monday': '',
          'Tuesday': '',
          'Wednesday': '',
          'Thursday': '',
          'Friday': '',
          'Saturday': '',
          'Sunday': '',
        }).then((value) {
          print('Successfully added user to firestore');
        }).catchError((error) {
          print("Failed to add user to firestore");
          print(error);
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavBar()),
        );
      }
    }).catchError((error) {
      print("Error signing up!");
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text('Sign Up',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 40, bottom: 10, top: 5),
              child: TextField(
                controller: _emailControl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 40, bottom: 5, top: 5),
              child: TextField(
                controller: _passwordControl,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 40, bottom: 5, top: 5),
              child: TextField(
                controller: _nameControl,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name (Optional)',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 40, bottom: 5, top: 5),
              child: TextField(
                controller: _addressControl,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Address (Optional)',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 35),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),
                    ),
                  )),
                ),
                child: Text('Sign up'),
                onPressed: () {
                  _signup();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
