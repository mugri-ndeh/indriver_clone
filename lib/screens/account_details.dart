import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/screens/homepage.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:provider/provider.dart';

class CompleteSignUp extends StatefulWidget {
  const CompleteSignUp({Key? key}) : super(key: key);

  @override
  CompleteSignUpState createState() => CompleteSignUpState();
}

class CompleteSignUpState extends State<CompleteSignUp> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  final _firstnameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<Authentication>(context);
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
                      validator: (val) =>
                          val!.isEmpty ? 'Cannot be Empty' : null,
                      decoration: const InputDecoration(
                          hintText: 'First name',
                          prefixIcon: Icon(Icons.person_outline)),
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      validator: (val) =>
                          val!.isEmpty ? 'Cannot be Empty' : null,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          hintText: 'last name',
                          prefixIcon: Icon(Icons.person_outline)),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      validator: (val) =>
                          val!.isEmpty ? 'Cannot be Empty' : null,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                          hintText: 'username',
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
                      validator: (val) =>
                          val!.isEmpty ? 'Cannot be Empty' : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline)),
                    ),
                  ],
                ),
              ),
              BotButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      provider.completeprofile(
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
    ));
  }
}
