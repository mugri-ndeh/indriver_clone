import 'package:flutter/material.dart';
import 'package:indriver_clone/driver/screens/earnings.dart';
import 'package:indriver_clone/driver/screens/rating.dart';
import 'package:indriver_clone/driver/screens/ride_requests.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';

class MainDriverPage extends StatefulWidget {
  MainDriverPage({Key? key}) : super(key: key);

  @override
  _MainDriverPageState createState() => _MainDriverPageState();
}

class _MainDriverPageState extends State<MainDriverPage> {
  PageController? pageController;
  int _selectedIndex = 0;
  List<Widget> _screens = [
    RideRequests(),
    Earnings(),
    Ratings(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: ElevatedButton(
          onPressed: () {},
          child: Text('Offline'),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined))
        ],
      ),
      body: PageView(
        children: _screens,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), label: 'Ride Requests'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'My earnings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border), label: 'Rating'),
        ],
      ),
    );
  }
}
