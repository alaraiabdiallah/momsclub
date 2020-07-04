
import 'package:flutter/material.dart';
import 'package:momsclub/screens/search_screen.dart';
import 'package:momsclub/utils/infos.dart';

class AppBottomNav extends StatefulWidget {

  final Function onItemTapped;

  const AppBottomNav({Key key, this.onItemTapped}) : super(key: key);

  @override
  _AppBottomNavState createState() => _AppBottomNavState();
}



class _AppBottomNavState extends State<AppBottomNav> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemTapped(index);
    switch(index){
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Explore'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('History'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('User'),
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: AppColor.PRIMARY,
      selectedItemColor: AppColor.PRIMARY_DARKER,
      onTap: _onItemTapped,
    );
  }
}
