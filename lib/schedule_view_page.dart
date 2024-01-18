import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Map<String, String> workouts = {};
  StreamSubscription<DocumentSnapshot>? userSubscription;

  @override
  void initState() {
    super.initState();
    _startListeningToWorkoutSchedule();
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    super.dispose();
  }

  void _startListeningToWorkoutSchedule() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    userSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen(
      (userDoc) {
        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          setState(() {
            workouts = {
              'Monday': userData['Monday'] ?? 'Rest',
              'Tuesday': userData['Tuesday'] ?? 'Rest',
              'Wednesday': userData['Wednesday'] ?? 'Rest',
              'Thursday': userData['Thursday'] ?? 'Rest',
              'Friday': userData['Friday'] ?? 'Rest',
              'Saturday': userData['Saturday'] ?? 'Rest',
              'Sunday': userData['Sunday'] ?? 'Rest',
            };
          });
        }
      },
      onError: (error) => print(error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Workout Schedule'),
      ),
      body: workouts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                String day = workouts.keys.elementAt(index);
                return ListTile(
                  title: Text(day),
                  subtitle: Text(workouts[day] ?? 'Rest'),
                );
              },
            ),
    );
  }
}
