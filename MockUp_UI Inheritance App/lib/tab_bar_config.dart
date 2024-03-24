import 'package:flutter/material.dart';
import 'package:inheritance_app/page/uploads/upload_view.dart';
import 'package:inheritance_app/page/public/public_view.dart';
import 'package:inheritance_app/page/user_profile/profile_view.dart';
import 'package:inheritance_app/page/view/local_widget/tab_bar_indecator_view.dart';
import 'package:inheritance_app/utils/theme/theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TabBarConfig extends StatefulWidget {
  const TabBarConfig({Key? key}) : super(key: key);

  @override
  TabBarConfigState createState() => TabBarConfigState();
}

class TabBarConfigState extends State<TabBarConfig> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const UploadView(),
    const PublicView(),
    const TabBarIndecatorView(),
    const ProfileView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: const Text('相続管理アプリ'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true, // show labels when items are selected
        showUnselectedLabels: true, // show labels when items are not selected
        unselectedItemColor: Color.fromARGB(255, 105, 105, 105), // color when the item is not selected
        selectedItemColor: const Color.fromARGB(255, 97, 13, 112), // color when the item is selected

        items: const <BottomNavigationBarItem>[
          // remove const here
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            // Add this
            icon: Icon(Icons.people),
            label: 'Public',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Profile', 
            
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
