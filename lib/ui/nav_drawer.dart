import 'package:flutter/material.dart';
import 'package:indriver_clone/screens/profile_settings.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key? key}) : super(key: key);

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Expanded(
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            flex: 4,
                            child: ListTile(
                              leading: Text('Frunwi'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.location_city_sharp),
                    title: Text('City'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.timer),
                    title: Text('Request History'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text('Settings'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Help'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.support_agent),
                    title: Text('Support'),
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Switch to Driver'))
          ],
        ),
      ),
    );
  }
}
