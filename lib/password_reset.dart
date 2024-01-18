import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    super.dispose();
  }

  void _sendPasswordResetEmail() async {
    String email = _emailController.text;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show a success message
      _showErrorDialog('Success', 'Password reset email sent');
      _emailController.clear();
    } catch (error) {
      // Handle error, e.g., show an error message
      _showErrorDialog('Error', 'Error sending password reset email');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
            )
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
                'Dismiss',
                style: TextStyle(
                  color: Colors.white,
                )
            ),
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
          ),
        ],
        backgroundColor: Colors.deepOrange, // Deep orange background for the dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners for the dialog
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Reset Password'
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: Text(
                'Send Password Reset Email',
                style: TextStyle(color: Colors.black), // Black text color
              ),
              style: ButtonStyle(
                side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 2.0, style: BorderStyle.solid)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
