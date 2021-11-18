import 'package:flutter/material.dart';
import 'package:indriver_clone/ui/app_bar.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: const NavAppbar(title: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ListTile(
              title: Text('Change phone number'),
              subtitle: Text('+237xxxxxxx'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              title: Text('Language'),
              subtitle: Text('English'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              title: Text('About application'),
              subtitle: Text('+237xxxxxxx'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
