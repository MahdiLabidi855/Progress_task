import 'dart:core';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pfatest/Moudel/google_sign_in.dart';
import 'package:pfatest/UI/client.dart';
import 'package:pfatest/UI/clientinfo.dart';
import 'package:pfatest/UI/settings.dart';
import 'package:pfatest/UI/topnavigationbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class clienthome extends StatefulWidget {
  const clienthome({Key? key}) : super(key: key);

  @override
  State<clienthome> createState() => _clienthomeState();
}

class _clienthomeState extends State<clienthome> {
  late final Map<String, dynamic> document;
  final user = FirebaseAuth.instance.currentUser!;
  String fprint = "";
  int _page = 0;
  bool  isactivecolorhome=true;
  bool  isactivecolorinfo=false;
  bool  isactivecolorsetting=false;


  @override
  Widget build(BuildContext context) {
    final List = <Widget>[const client(),const clientinfo(), const settings()];
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
        .collection("list")
        .doc(user.email)
        .collection("users")
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffd9d9d9),
              Color(0xffafacac),
            ]),
          ),
        ),

        title:
            const Text(
              "Today's Tasks ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:  Color(0xfffe9000),
              ),
            ),
        actions: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFFFF),
            backgroundImage:
            NetworkImage(user.photoURL == null ? "" : user.photoURL!),
          ),
          const SizedBox(
            width: 25,
          ),
          InkWell(
            onTap: () {
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const Topnavigationbar()),
                      (route) => false);
            },
            child: const Icon(
              Icons.logout,
              size: 32,
              color: Colors.black,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffd9d9d9),
              Color(0xffafacac),
            ])),
        child: CurvedNavigationBar(
          height: 50,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(
              Icons.home,
              size: 32,
              color: isactivecolorhome? Colors.orange:Colors.grey,
            ),
            Icon(
              Icons.add,
              size: 32,
              color: isactivecolorinfo? Colors.orange:Colors.grey,
            ),
            Icon(
              Icons.settings,
              size: 32,
              color: isactivecolorsetting? Colors.orange:Colors.grey,
            ),

          ],
          onTap: (index) {
            setState(() {
              _page = index;
              if(_page==0) {
                isactivecolorhome = true;
                isactivecolorinfo=false;
                isactivecolorsetting=false;
              }else if(_page==1) {
                isactivecolorhome = false;
                isactivecolorinfo = true;
                isactivecolorsetting=false;
              } else if(_page==2) {
                isactivecolorhome = false;
                isactivecolorinfo = false;
                isactivecolorsetting = true;
              }
            });
          },
        ),
      ),
      body: List[_page],
    );
  }
}
