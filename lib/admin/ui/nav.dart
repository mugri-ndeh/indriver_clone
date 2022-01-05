import 'package:flutter/material.dart';
import 'package:indriver_clone/admin/screens/monitor_drivers.dart';

class DashboardNav extends StatefulWidget {
  DashboardNav({Key? key}) : super(key: key);

  @override
  DashboardNavState createState() => DashboardNavState();
}

class DashboardNavState extends State<DashboardNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: const Text('All drivers'),
                leading: Icon(Icons.drive_eta_outlined),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonitorDrivers(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Unverified drivers'),
                leading: Icon(Icons.person_add_disabled),
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
