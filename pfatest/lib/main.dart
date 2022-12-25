import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pfatest/UI/SplashScreen.dart';
import 'package:pfatest/UI/topnavigationbar.dart';
import 'package:provider/provider.dart';
import 'package:pfatest/Moudel/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) => ChangeNotifierProvider(
      create:(_)=> GoogleSignInProvider(),
      child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login ',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context,snapshot) {
          if(snapshot.hasData){

            return const SplashScreen();
              }
          else{
            return const Topnavigationbar();
          }
          },
          ),
      ),
    );
  }


