import 'package:flutter/material.dart';
import 'package:pfatest/UI/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfatest/UI/topnavigationbar.dart';

class home extends StatelessWidget {
   const home({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
      }else if(snapshot.hasData){

          return const SplashScreen();
        }
        else if(snapshot.hasError){
          return const Center(child: Text('Something went wrong!'));
        }
        else {
        return const Topnavigationbar();
      }
    },

    ),
  );
}

