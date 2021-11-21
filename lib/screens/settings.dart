import 'package:flutter/material.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/ui/app_bar.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var provider = Provider.of<Authentication>(context, listen: false);
    return Scaffold(
      drawer: const NavDrawer(),
      // appBar: const NavAppbar(title: 'Settings'),
      body: Consumer<Authentication>(
        builder: (_, provider, __) => SingleChildScrollView(
          child: Column(
            children: const [
              ListTile(
                title: Text('Phone number'),
                subtitle: Text('+237xxxxxxx'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                title: Text('Language'),
                subtitle: Text('English'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                title: Text('About application'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
