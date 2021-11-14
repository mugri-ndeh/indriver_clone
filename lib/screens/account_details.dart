import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class CompleteSignUp extends StatefulWidget {
  const CompleteSignUp({Key? key}) : super(key: key);

  @override
  CompleteSignUpState createState() => CompleteSignUpState();
}

class CompleteSignUpState extends State<CompleteSignUp> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  var _firstnameController = TextEditingController();

  var _lastNameController = TextEditingController();

  var _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
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
                      controller: _firstnameController,
                      decoration: const InputDecoration(
                          hintText: 'First name',
                          prefixIcon: Icon(Icons.person_outline)),
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          hintText: 'last name',
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline)),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 1),
                onPressed: () async {
                  // print(selectedDate.toString().replaceAll('00:00:00.000', ''));
                  // await FirebaseFirestore.instance.collection('users');
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
