import 'package:flutter/material.dart';
import 'package:pfatest/Get/button.dart';
import 'package:pfatest/Get/textfaild.dart';
import 'package:pfatest/Moudel/google_sign_in.dart';
import 'package:pfatest/UI/Home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfatest/utils/variable.dart';
import 'package:provider/provider.dart';
import 'package:pfatest/fingerprint.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _userEmailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FingerPrint _fingerPrint=FingerPrint();
  String fprint="";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIffingerPrintEnabled();
  }
  void checkIffingerPrintEnabled()async{
    fprint =await flutterSecureStorage.read(key:"fingerprint")??"";
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    getTextField("mail", Icons.email_outlined, false,
                        _userEmailTextController),
                    const SizedBox(
                      height: 10,
                    ),
                    getTextField("Passwrod", Icons.lock_outline, true,
                        _passwordTextController),
                    SigninupButton(context, true, () {
                       flutterSecureStorage.write(key:"useremail",value:_userEmailTextController.text);
                       flutterSecureStorage.write(key:"password",value:_passwordTextController.text);

                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _userEmailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => home()),
                            (route) => false);
                      }).onError((error, stackTrace) {
                        print("Error : ${error.toString()}");
                      });
                    }),
                    const SizedBox(height: 5,),
                    fprint.isNotEmpty? ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states){
                      if(states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return Colors.blue;
                    }), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ))
                    ),
                      onPressed: (){
                        _fingerPrintLogin();
                      },
                      child:Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: const Center(
                          child: Text("Login Rapide with Finger Print"),
                        ),
                      ),
                    ):Container(),
                    Row(children: <Widget>[
                      Expanded(
                        child:  Container(
                            margin:
                                const EdgeInsets.only(left: 30.0, right: 15.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),

                      const Text("OR"),
                      Expanded(
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 30.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                    ]),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            minimumSize: const Size(150, 50),
                            padding:
                                const EdgeInsets.only(left: 10, right: 15)),
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                        ),
                        label: const Text('  Login with Google'),
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.googleLogin();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => home()),
                              (route) => false);
                        }),


                  ],
                ),
              )
            ],
          )),
    );
  }
  void _fingerPrintLogin()async{
  bool isFingerPrintEnabled =await _fingerPrint.isFingerPrintEnabled();
  if(isFingerPrintEnabled){
    bool isAuth = await _fingerPrint.isAuth("login with finger print");
    if(isAuth){

      String password =await flutterSecureStorage.read(key: "password")??"";
      String useremail =await flutterSecureStorage.read(key: "useremail")??"";
      FirebaseAuth.instance
          .signInWithEmailAndPassword( email: useremail.toString() ,password: password.toString() )
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => home()),
                (route) => false);
      }).onError((error, stackTrace) {
        print("Error : ${error.toString()}");
        final provider = Provider.of<GoogleSignInProvider>(
            context,
            listen: false);
        provider.googleLogin();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => home()),
                (route) => false);
      });



    }
  }
  }
}
