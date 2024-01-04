import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_booking/screens/home_screen.dart';
import 'package:pet_booking/screens/profile_screen.dart';

import '../screens/create_pet_post.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    // Implement the content of each tab based on the selected index (_currentIndex)
    // You can use a widget like IndexedStack or a Navigator with multiple pages
    // Here's an example using IndexedStack:
    return IndexedStack(
      index: currentIndex,
      children: const [

        HomeScreen(),
        CreatePetPost(),
        ProfileScreen()


      ],
    );
  }
  Widget _buildBottomNavigationBar() {
    // Set your desired background color here

    return BottomNavigationBar(
      currentIndex: currentIndex,
      // selectedItemColor: GlobalVariables.mainColor,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.orange,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (int newIndex) {
        // Update the selected index when a tab is tapped
        setState(() {
          currentIndex = newIndex;
        });
      },
      items: const [
        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.house),
            label: 'Home',
            activeIcon:FaIcon(FontAwesomeIcons.house,color: Colors.orange,)
        ),

        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.plus),
            label: 'Create',
            activeIcon:FaIcon(FontAwesomeIcons.plus,color: Colors.orange,)
        ),
        BottomNavigationBarItem(
            icon:FaIcon(FontAwesomeIcons.solidUser),
            label: 'Profile',
            activeIcon:FaIcon(FontAwesomeIcons.solidUser,color: Colors.orange,)
        ),
      ],
    );
  }
}
