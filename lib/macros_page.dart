import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMacros extends StatefulWidget {
  const UpdateMacros({super.key});

  @override
  State<UpdateMacros> createState() => _UpdateMacrosState();
}

class _UpdateMacrosState extends State<UpdateMacros> {
  Map<String, TextEditingController> _controllers = {};
  final _fields = [
    'Calories Consumed',
    'Carbs Consumed',
    'Protein Consumed',
    'Daily Calories',
    'Daily Carbs',
    'Daily Protein',
  ];

  @override
  void initState() {
    super.initState();
    for (var field in _fields) {
      _controllers[field] = TextEditingController();
    }
    _fetchCurrentMacros();
  }

  void _fetchCurrentMacros() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        _controllers['Calories Consumed']?.text =
            userDoc.get('Calories Consumed').toString();
        _controllers['Carbs Consumed']?.text =
            userDoc.get('Carbs Consumed').toString();
        _controllers['Protein Consumed']?.text =
            userDoc.get('Protein Consumed').toString();
        _controllers['Daily Calories']?.text =
            userDoc.get('Daily Calories').toString();
        _controllers['Daily Carbs']?.text =
            userDoc.get('Daily Carbs').toString();
        _controllers['Daily Protein']?.text =
            userDoc.get('Daily Protein').toString();
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  _updateMacros(String field) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    int? value = int.tryParse(_controllers[field]?.text ?? '');

    if (value != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        field: value,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$field updated successfully')));
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error updating $field')));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid input for $field')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Daily Macros'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: _fields.map((field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(field,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _controllers[field],
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () => _updateMacros(field),
                    child: Text('Update $field'),
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
                  ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
