import 'package:flutter/material.dart';
import 'package:pfatest/Get/button.dart';
import 'package:pfatest/Get/textfaild.dart';
import 'package:pfatest/UI/SplashScreen.dart';
import 'package:pfatest/UI/todohome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController _userEmailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final items = ["Chef", "Employe", 'Client'];
  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,


        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  getTextField("Entre UserName", Icons.person_outline, false,
                      _userNameTextController),
                  const SizedBox(height: 10,),
                  getTextField("Entre Email ", Icons.person_outline, false,
                      _userEmailTextController),
                  const SizedBox(height: 10,),
                  getTextField("Entre Password", Icons.lock_outline, true,
                      _passwordTextController),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black,width: 0.6)
                  ),
                    child: DropdownButton<String>(
                      value: value,
                        isExpanded: true,

                        items: items.map(buildMenuItem).toList(),
                        onChanged: (value)=>setState(() {
                          this.value= value;
                        })),
                  ),
                  const SizedBox(height: 10,),
                  SigninupButton(context, false, () {
                    FirebaseFirestore.instance.collection("users").doc(
                        _userEmailTextController.text).set({
                      "Name": _userNameTextController.text,
                      "email": _userEmailTextController.text,
                      "Role": value,
                      "isold": false,
                    });
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _userEmailTextController.text,
                        password: _passwordTextController.text
                    ).then((value) {
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(
                          builder: (_) => const SplashScreen()), (route) => false);
                    }).onError((error, stackTrace) {
                      print("Error : ${error.toString()}");
                      Fluttertoast.showToast(msg: "Error : ${error.toString()}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 9,
                      fontSize: 15);
                    });
                  }),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String item) =>
    DropdownMenuItem(value: item,
      child: Text(
        item, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.grey),
      ),
    );