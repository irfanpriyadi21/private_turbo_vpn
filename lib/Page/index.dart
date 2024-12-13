import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:vpn_mobile/Page/Home/home.dart';
import 'package:vpn_mobile/Page/Profile/profile.dart';

import '../main.dart';


class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;

  List _pages = const<Widget>[
    Home(),
    Profile()
  ];

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:GoogleFonts.poppins(
          textStyle:  TextStyle(color: context.iconColor)
      ),
      selectedItemColor: context.iconColor,
      unselectedLabelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(color: gray)
      ),
      iconSize: 20,
      unselectedItemColor: gray,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Scaffold(
        bottomNavigationBar: _bottomTab(),
        body: Center(child: _pages.elementAt(_selectedIndex)),
      ),
    );
  }
}
