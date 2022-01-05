import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:indriver_clone/ui/constants.dart';
import 'package:path/path.dart';

class VerifyDriver extends StatefulWidget {
  const VerifyDriver({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  _VerifyDriverState createState() => _VerifyDriverState();
}

class _VerifyDriverState extends State<VerifyDriver> {
  Future<String> getUrl(String img) async {
    var url;
    await FirebaseStorage.instance.ref(img).getDownloadURL().then((value) {
      url = value;
    });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          child: Image.network(widget.user.photo!),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.username!),
                            Text(widget.user.phoneNumber!),
                            Text(widget.user.firstName! +
                                ' ' +
                                widget.user.lastName!)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 130,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width * 0.5,
                            child: Image.network(
                              widget.user.idNo!,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Text('National ID'),
                        ]),
                    //decoration: const BoxDecoration(color: primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 130,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width * 0.5,
                            child: Image.network(
                              widget.user.licenceNo!,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Text('Driver License'),
                        ]),
                    //decoration: const BoxDecoration(color: primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 130,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width * 0.5,
                            child: Image.network(
                              widget.user.carplatenum!,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stacktrace) {
                                return DecoratedBox(
                                    child: const Center(
                                        child: Text(
                                            'Could not load image\nCheck Internet Connection')),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)));
                              },
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Text('Car image'),
                        ]),
                    //decoration: const BoxDecoration(color: primaryColor),
                  ),
                ),
                BotButton(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.user.id!)
                          .update({
                        'verified': true,
                        'submittedStatus': 'verified'
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User verified'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    title: 'Verify driver'),
                BotButton(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.user.id!)
                          .update({
                        'verified': false,
                        'submittedStatus': 'denied'
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification denied'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.pop(context);
                      });
                    },
                    title: 'Deny')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
