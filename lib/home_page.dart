import 'package:flutter/material.dart';
import 'package:gym_app_real/macros_page.dart';
import 'package:gym_app_real/schedule_view_page.dart';
import 'package:gym_app_real/update_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  int? caloriesConsumed;
  int? proteinConsumed;
  int? carbsConsumed;
  int? totalCalories;
  int? totalProtein;
  int? totalCarbs;
  String? Monday;
  String? Tuesday;
  String? Wednesday;
  String? Thursday;
  String? Friday;
  String? Saturday;
  String? Sunday;

  String getTodayWorkout() {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;

    String? workout;
    switch (dayOfWeek) {
      case 1:
        workout = Monday;
        break;
      case 2:
        workout = Tuesday;
        break;
      case 3:
        workout = Wednesday;
        break;
      case 4:
        workout = Thursday;
        break;
      case 5:
        workout = Friday;
        break;
      case 6:
        workout = Saturday;
        break;
      case 7:
        workout = Sunday;
        break;
    }

    return workout ?? 'Rest Day';
  }

  Stream<DocumentSnapshot> userStream() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData && snapshot.data != null) {
            var userDoc = snapshot.data!;
            name = userDoc.get('name');
            caloriesConsumed = userDoc.get('Calories Consumed');
            proteinConsumed = userDoc.get('Protein Consumed');
            carbsConsumed = userDoc.get('Carbs Consumed');
            totalCalories = userDoc.get('Daily Calories');
            totalProtein = userDoc.get('Daily Protein');
            totalCarbs = userDoc.get('Daily Carbs');
            Monday = userDoc.get('Monday');
            Tuesday = userDoc.get('Tuesday');
            Wednesday = userDoc.get('Wednesday');
            Thursday = userDoc.get('Thursday');
            Friday = userDoc.get('Friday');
            Saturday = userDoc.get('Saturday');
            Sunday = userDoc.get('Sunday');
            return Column(
              children: [
                Expanded(
                  flex: 15,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 20, bottom: 10, top: 10),
                          child: Text(
                            'Welcome ${name ?? ''}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(title: 'Profile Page')),
                            );
                          },
                          icon: const Icon(Icons.account_box_rounded),
                          iconSize: 45,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Split Day',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              getTodayWorkout(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 15, right: 5, top: 20, bottom: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.deepOrange),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3.0),
                                  ),
                                )),
                              ),
                              child: Text(
                                'Update Schedule',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WorkoutSchedulePage()),
                                );
                              },
                            ),
                          ),
                          TextButton(
                            child: Text(
                              'View Schedule',
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SchedulePage()),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Column(
                    children: [
                      //calories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Calories Consumed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  '${caloriesConsumed ?? ''}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                    style: BorderStyle.solid)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.deepOrange),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(3.0),
                                  ),
                                )),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateMacros()),
                                );
                              },
                              child: Text('+'),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Calories Needed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  '${totalCalories! - caloriesConsumed!}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //protein
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Protein Consumed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  '${proteinConsumed ?? ''}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                  style: BorderStyle.solid)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3.0),
                                ),
                              )),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateMacros()),
                              );
                            },
                            child: Text('+'),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Protein Needed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  '${totalProtein! - proteinConsumed!}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //carbs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Carbs Consumed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  '${carbsConsumed ?? ''}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                  style: BorderStyle.solid)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3.0),
                                ),
                              )),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateMacros()),
                              );
                            },
                            child: Text('+'),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Carbs Needed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  '${totalCarbs! - carbsConsumed!}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.only(bottom: 10),
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          //reset consumed macros to 0 and update to firebase
                          _resetMacros();
                        },
                        child: Text('Reset Macros'),
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.black,
                              width: 2.0,
                              style: BorderStyle.solid)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3.0),
                            ),
                          )),
                        ),
                      ),
                    ))
              ],
            );
          } else {
            return Text("No data available");
          }
        },
      ),
    );
  }

  void _resetMacros() async {
    User? curr = FirebaseAuth.instance.currentUser;
    if (curr != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(curr.uid)
          .update({
            'Calories Consumed': 0,
            'Carbs Consumed': 0,
            'Protein Consumed': 0,
          })
          .then((_) {})
          .catchError((error) {});
    }
  }
}
