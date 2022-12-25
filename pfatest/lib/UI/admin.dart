import 'dart:core';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfatest/Moudel/google_sign_in.dart';
import 'package:pfatest/UI/adminclient.dart';
import 'package:pfatest/UI/adminlistclient.dart';
import 'package:pfatest/UI/client.dart';
import 'package:pfatest/UI/info.dart';
import 'package:pfatest/UI/settings.dart';
import 'package:pfatest/UI/topnavigationbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class todoadmin extends StatefulWidget {
  const todoadmin({Key? key}) : super(key: key);

  @override
  State<todoadmin> createState() => _todoadminState();
}

class _todoadminState extends State<todoadmin> {
  late final Map<String, dynamic> document;
  final user = FirebaseAuth.instance.currentUser!;
  String fprint = "";
  int _page = 0;
  bool  isactivecolorhome=true;
  bool  isactivecolorinfo=false;
  bool  isactivecolorsetting=false;
  bool privet =false;


  @override
  Widget build(BuildContext context) {
    final List = <Widget>[privet?const client():const Adminlc(), privet?const adminclientinfo():const info(), const settings()];
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

        title: Row(
          children: [
            InkWell(
              onTap: (){
                setState(() {
                  privet=!privet;
                });
              },
              child: FaIcon(
                privet?FontAwesomeIcons.lock:FontAwesomeIcons.unlock,
                size: 20,
                color:privet?const Color(0xff000000):const Color(0xffffffff) ,
              ),
            ),
            const SizedBox(width: 7,),
            const Text(
              "Admin Today's Schedule ",
              style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:  Color(0xfffe9000),
              ),
            ),
          ],
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
            gradient:  LinearGradient(colors: [
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
