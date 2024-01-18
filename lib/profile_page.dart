import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String? userName;
  String? address;

  @override
  void dispose() {
    _nameController.clear();
    _addressController.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    User? curr = FirebaseAuth.instance.currentUser;
    if (curr != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(curr.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc.get('name');
            address = userDoc.get('address');
          });
        }
      } catch (error) {
        print("Error fetching user data: $error");
      }
    }
  }

  _updateUserName() async {
    User? curr = FirebaseAuth.instance.currentUser;
    if (curr != null) {
      {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(curr.uid)
              .update({
            'name': _nameController.text,
          });
        } on Exception catch (error) {
          // TODO
          print("Error fetching user data: $error");
        }
      }
    }
  }

  _updateUserAddress() async {
    User? curr = FirebaseAuth.instance.currentUser;
    if (curr != null) {
      {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(curr.uid)
              .update({
            'address': _addressController.text,
          });
        } on Exception catch (error) {
          // TODO
          print("Error fetching user data: $error");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Your Profile',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${userName ?? ''}',
                      style: TextStyle(fontSize: 20)),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Update Name?',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _nameController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  ElevatedButton(
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
                    child: Text('Update'),
                    onPressed: () {
                      setState(() {
                        if (_nameController.text.isNotEmpty) {
                          _updateUserName();
                          userName = _nameController.text;
                          _nameController.clear();
                        }
                      });
                    },
                  ),
                  Text('Address: ${address ?? ''}',
                      style: TextStyle(fontSize: 20)),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Update address?',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _addressController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  ElevatedButton(
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
                    child: Text('Update'),
                    onPressed: () {
                      setState(() {
                        if (_addressController.text.isNotEmpty) {
                          _updateUserAddress();
                          address = _addressController.text;
                          _addressController.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
