import 'package:flutter/material.dart';
import 'package:indriver_clone/admin/screens/dashboard.dart';
import 'package:indriver_clone/admin/screens/monitor_drivers.dart';
import 'package:indriver_clone/ui/constants.dart';

class AdminRoot extends StatefulWidget {
  AdminRoot({Key? key}) : super(key: key);

  @override
  _AdminRootState createState() => _AdminRootState();
}

class _AdminRootState extends State<AdminRoot> {
  PageController? pageController;
  int _selectedIndex = 0;
  final List<Widget> _screens = [Dashboard(), MonitorDrivers()];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController!.dispose();
  }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController!.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Unverified Drivers' : 'All Drivers'),
      ),
      body: PageView(
        children: _screens,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person_remove), label: 'Unverified Drivers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.drive_eta_rounded), label: 'All drivers'),
        ],
      ),
    );
  }
}
