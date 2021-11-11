import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: size.height * 0.8,
                  child: Column(
                    children: [
                      const Center(
                        child: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 80,
                          ),
                          radius: 80,
                        ),
                      ),
                      TextFormField(
                        initialValue: 'Frunwi',
                        decoration: const InputDecoration(
                            hintText: 'First name',
                            prefixIcon: Icon(Icons.person_outline)),
                      ),
                      TextFormField(
                        initialValue: 'Mugri Ndeh',
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            hintText: 'First name',
                            prefixIcon: Icon(Icons.person_outline)),
                      ),
                      DateTimeField(
                          mode: DateTimeFieldPickerMode.date,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              hintText: 'Date of Birth'),
                          selectedDate: selectedDate,
                          onDateSelected: (DateTime value) {
                            setState(() {
                              selectedDate = value;
                            });
                          }),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.mail_outline)),
                      ),
                      TextFormField(
                        initialValue: 'Buea',
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.location_city_outlined)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
