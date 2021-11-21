import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:indriver_clone/ui/constants.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final _firstnameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _usernameController = TextEditingController();

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
            color: primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<Authentication>(
        builder: (_, provider, __) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: size.height * 0.8,
                    child: Column(
                      children: [
                        const Center(
                          child: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                            radius: 80,
                          ),
                        ),
                        TextFormField(
                          controller: _firstnameController,
                          //initialValue: provider.loggedUser.firstName,
                          decoration: InputDecoration(
                              hintText: provider.loggedUser.firstName,
                              prefixIcon: const Icon(Icons.person_outline)),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          // initialValue: provider.loggedUser.lastName,
                          decoration: InputDecoration(
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              hintText: provider.loggedUser.lastName,
                              prefixIcon: const Icon(Icons.person_outline)),
                        ),
                        TextFormField(
                          controller: _usernameController,
                          //initialValue: provider.loggedUser.username,
                          decoration: InputDecoration(
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              hintText: provider.loggedUser.username,
                              prefixIcon: const Icon(Icons.person_outline)),
                        ),
                        DateTimeField(
                            mode: DateTimeFieldPickerMode.date,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
                                hintText: provider.loggedUser.dob),
                            selectedDate: selectedDate,
                            onDateSelected: (DateTime value) {
                              setState(() {
                                selectedDate = value;
                              });
                            }),
                        TextFormField(
                          controller: _emailController,
                          //initialValue: provider.loggedUser.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: provider.loggedUser.email,
                              prefixIcon: const Icon(Icons.mail_outline)),
                        ),
                      ],
                    ),
                  ),
                  BotButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          provider.updateProfile(
                              _firstnameController.text,
                              _lastNameController.text,
                              _usernameController.text,
                              selectedDate.toString(),
                              _emailController.text,
                              context);
                        }
                      },
                      title: 'Save')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
