import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfatest/fingerprint.dart';
import 'package:pfatest/utils/variable.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  late final Map<String, dynamic> document;
  final user = FirebaseAuth.instance.currentUser!;
  final FingerPrint _fingerPrint = FingerPrint();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> _stream =
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.email)
            .snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.all(0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xffd9d9d9),
            Color(0xffafacac),
          ])),
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      "User Name : ",
                      style: TextStyle(
                          fontSize: 16.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2),
                    ),
                    Text(
                      user.displayName.toString(),
                      style: const TextStyle(
                          fontSize: 16.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "User Email : ",
                      style: TextStyle(
                          fontSize: 16.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2),
                    ),
                    Text(
                      user.email.toString(),
                      style: const TextStyle(
                          fontSize: 16.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      isSwitchChecked
                          ? "Disable fingerprint"
                          : "Activate the fingerprint",
                      style: const TextStyle(
                          fontSize: 16.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2),
                    ),
                    Switch(
                      value: isSwitchChecked,
                      onChanged: (value) {
                        _enableFingerPrint(value);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  void _enableFingerPrint(value) async {
    if (value) {
      bool isFingerPrintEnabled = await _fingerPrint.isFingerPrintEnabled();
      if (isFingerPrintEnabled) {
        await flutterSecureStorage.write(key: "fingerprint", value: "checked");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Finger Print Enabled")));
      }
    } else {
      await flutterSecureStorage.delete(key: "fingerprint");
    }
    setState(() {
      isSwitchChecked = value;
    });
  }
}
