import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutSchedulePage extends StatefulWidget {
  @override
  _WorkoutSchedulePageState createState() => _WorkoutSchedulePageState();
}

class _WorkoutSchedulePageState extends State<WorkoutSchedulePage> {
  Map<String, TextEditingController> _controllers = {};
  final _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    for (var day in _daysOfWeek) {
      _controllers[day] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Stream<DocumentSnapshot> getWorkoutStream() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  _updateWorkout(String day) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      day: _controllers[day]?.text ?? '',
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$day workout updated successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating $day workout')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Weekly Workout Schedule'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getWorkoutStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData && snapshot.data != null) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            for (var day in _daysOfWeek) {
              _controllers[day]?.text = userData[day] ?? '';
            }
            return buildScheduleView();
          } else {
            return Text("No workout data available");
          }
        },
      ),
    );
  }

  Widget buildScheduleView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: _daysOfWeek.map((day) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _controllers[day],
                ),
                ElevatedButton(
                  onPressed: () => _updateWorkout(day),
                  child: Text('Update $day'),
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
    );
  }
}
