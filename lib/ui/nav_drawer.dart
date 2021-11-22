import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/driver/screens/main_page.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/screens/help.dart';
import 'package:indriver_clone/screens/homepage.dart';
import 'package:indriver_clone/screens/profile_settings.dart';
import 'package:indriver_clone/screens/request_history.dart';
import 'package:indriver_clone/screens/settings.dart';
import 'package:indriver_clone/screens/support.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:indriver_clone/ui/constants.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: size.height * 0.9,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    ),
                    child: DrawerHeader(
                      curve: Curves.easeIn,
                      padding: const EdgeInsets.all(4),
                      margin: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 50,
                              child: Icon(Icons.person),
                            ),
                            flex: 1,
                          ),
                          Consumer<Authentication>(
                            builder: (_, provider, __) => Expanded(
                              flex: 4,
                              child: ListTile(
                                leading: Text(provider.loggedUser.username!),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: const ListTile(
                      leading: Icon(Icons.location_city_sharp),
                      title: Text('Home'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RequestHistory()));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.timer),
                      title: Text('Request History'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Setting(),
                        ),
                      );
                    },
                    child: const ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text('Settings'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Help()));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Help'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Support()));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.support_agent),
                      title: Text('Support'),
                    ),
                  ),
                  Consumer<Authentication>(
                    builder: (_, provider, __) => GestureDetector(
                      onTap: () {
                        provider.logout();
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(builder: (context) => MainDriverPage()),
            //         (route) => false);
            //   },
            //   child: const Text('Switch to Driver'),
            // )
            Consumer<Authentication>(
              builder: (_, auth, __) => BotButton(
                onTap: () {
                  auth.setDriver();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainDriverPage(),
                      ),
                      (route) => false);
                },
                title: 'Switch to driver',
              ),
            )
          ],
        ),
      ),
    );
  }
}
