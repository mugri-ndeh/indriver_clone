import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/admin/util/data.dart';
import 'package:indriver_clone/driver/ui/driver_provider.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UploadDocs extends StatefulWidget {
  const UploadDocs({Key? key}) : super(key: key);

  @override
  _UploadDocsState createState() => _UploadDocsState();
}

class _UploadDocsState extends State<UploadDocs> {
  UploadTask? task1;
  UploadTask? task2;
  UploadTask? task3;
  UploadTask? task4;

  File? passport;
  File? id;

  File? driverLicense;

  File? carImage;

  @override
  Widget build(BuildContext context) {
    final passportName =
        passport != null ? basename(passport!.path) : 'No File Selected';
    final idName = id != null ? basename(id!.path) : 'No File Selected';

    final licenseName = driverLicense != null
        ? basename(driverLicense!.path)
        : 'No File Selected';
    final carName =
        carImage != null ? basename(carImage!.path) : 'No File Selected';
    var user = Provider.of<Authentication>(context, listen: false).loggedUser;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  text: 'Passport photo',
                  icon: Icons.attach_file,
                  onClicked: selectFile1,
                ),
                const SizedBox(height: 8),
                Text(
                  passportName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                task1 != null ? buildUploadStatus1(task1!) : Container(),

                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'National ID',
                  icon: Icons.attach_file,
                  onClicked: selectFile2,
                ),
                const SizedBox(height: 8),
                Text(
                  idName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                task2 != null ? buildUploadStatus2(task2!) : Container(),

                const SizedBox(height: 48),

                ButtonWidget(
                  text: 'Driver license',
                  icon: Icons.attach_file,
                  onClicked: selectFile3,
                ),
                const SizedBox(height: 8),
                Text(
                  licenseName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                task3 != null ? buildUploadStatus3(task3!) : Container(),

                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Car image',
                  icon: Icons.attach_file,
                  onClicked: selectFile4,
                ),
                const SizedBox(height: 8),
                Text(
                  carName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                task4 != null ? buildUploadStatus4(task4!) : Container(),

                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Upload Files',
                  icon: Icons.cloud_upload_outlined,
                  onClicked: () {
                    uploadFile1(user);
                    uploadFile2(user);
                    uploadFile3(user);
                    uploadFile4(user);
                  },
                ),
                const SizedBox(height: 20),

                ButtonWidget(
                  text: 'Submit',
                  icon: Icons.done,
                  onClicked: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.id)
                        .update({'submittedStatus': 'waiting'});
                    var provider =
                        Provider.of<Authentication>(context, listen: false);
                    provider.returnUser();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
                //task != null ? buildUploadStatus(task!) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future selectFile1() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => passport = File(path));
  }

  Future uploadFile1(UserModel user) async {
    if (passport == null) return;

    final fileName = basename(passport!.path);
    final destination = 'users/${user.id}/$fileName';

    task1 = FirebaseApi.uploadFile(destination, passport!);
    setState(() {});

    if (task1 == null) return;

    final snapshot = await task1!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'photo': urlDownload});
  }

  Widget buildUploadStatus1(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  Future selectFile2() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => id = File(path));
  }

  Future uploadFile2(UserModel user) async {
    if (id == null) return;

    final fileName = basename(id!.path);
    final destination = 'users/${user.id}/$fileName';

    task2 = FirebaseApi.uploadFile(destination, id!);
    setState(() {});

    if (task2 == null) return;

    final snapshot = await task2!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'idNo': urlDownload});
  }

  Widget buildUploadStatus2(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  Future selectFile3() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => driverLicense = File(path));
  }

  Future uploadFile3(UserModel user) async {
    if (driverLicense == null) return;

    final fileName = basename(driverLicense!.path);
    final destination = 'users/${user.id}/$fileName';

    task3 = FirebaseApi.uploadFile(destination, driverLicense!);
    setState(() {});

    if (task3 == null) return;

    final snapshot = await task3!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'licenceNo': urlDownload});
  }

  Widget buildUploadStatus3(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  Future selectFile4() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => carImage = File(path));
  }

  Future uploadFile4(UserModel user) async {
    if (carImage == null) return;

    final fileName = basename(carImage!.path);
    final destination = 'users/${user.id}/$fileName';

    task4 = FirebaseApi.uploadFile(destination, carImage!);
    setState(() {});

    if (task4 == null) return;

    final snapshot = await task4!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'carplatenum': urlDownload});
  }

  Widget buildUploadStatus4(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  void uploadFiles(UserModel user) {
    uploadFile1(user);
    uploadFile2(user);
    uploadFile3(user);
    uploadFile4(user);
  }
}
