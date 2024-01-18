import 'package:flutter/material.dart';
import 'package:gym_app_real/find_gym.dart';
import 'package:gym_app_real/home_page.dart';
import 'package:gym_app_real/profile_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int myIndex = 0;
  List<Widget> widgetList = const [
    HomePage(title: 'Home Page'),
    FindGym(),
    ProfilePage(title: 'Profile Page')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: widgetList,
        index: myIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_city_rounded), label: 'Find Gym'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
