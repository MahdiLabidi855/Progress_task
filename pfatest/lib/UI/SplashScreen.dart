import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfatest/UI/admin.dart';
import 'package:pfatest/UI/clienthome.dart';
import 'package:pfatest/UI/employe.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String role ='Employe';
  @override
  void initState(){
    super.initState();
    _checkRole();
  }
  void _checkRole()async{
    final user = FirebaseAuth.instance.currentUser!;

    try {

      final DocumentSnapshot _snap = await
      FirebaseFirestore.instance.collection("users").doc(user.email).get();
      setState(() {
        role = _snap['Role'];
      });


      if (role == 'Employe') {
        navigateNext(const Employe());
      }
      else if (role == 'Chef') {
        navigateNext(const todoadmin());
      }else if (role == 'Client') {
        navigateNext(const clienthome());
      }
    }catch(e){


      _checkRole();


    }
  }
  void navigateNext(Widget route){
    Timer(const Duration(milliseconds: 1500 ),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>route));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff1d1e30),
              Color(0xff252099),
            ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
