import 'package:flutter/material.dart';
import 'package:indriver_clone/driver/screens/earnings.dart';
import 'package:indriver_clone/driver/screens/rating.dart';
import 'package:indriver_clone/driver/screens/ride_requests.dart';
import 'package:indriver_clone/ui/constants.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class MainDriverPage extends StatefulWidget {
  MainDriverPage({Key? key}) : super(key: key);

  @override
  _MainDriverPageState createState() => _MainDriverPageState();
}

class _MainDriverPageState extends State<MainDriverPage> {
  PageController? pageController;
  int _selectedIndex = 0;
  int toggleIndex = 0;
  final List<Widget> _screens = [
    const RideRequests(),
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
      drawer: const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: FlutterToggleTab(
            selectedBackgroundColors: const [primaryColor],
            width: 40,
            height: 30,
            borderRadius: 25,
            selectedTextStyle: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            unSelectedTextStyle: const TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
            labels: const ["offline", "online"],
            //icons: const [Icons.person, Icons.pregnant_woman],
            selectedLabelIndex: (index) {
              setState(() {
                toggleIndex = index;
              });

              print("Selected Index $index");
            },
            selectedIndex: toggleIndex,
          ),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: primaryColor,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          )
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
        selectedItemColor: primaryColor,
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
