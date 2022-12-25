import 'package:flutter/material.dart';

Container SigninupButton(BuildContext context,bool isLogin, Function onTap){
  return Container(width: MediaQuery.of(context).size.width,
  height: 50,
  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(onPressed: (){
      onTap();
    },
    child: Text(isLogin ? 'Login' : 'Sign UP', style: const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize:16),
    ),
      style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states){
        if(states.contains(MaterialState.pressed)) {
          return Colors.blue;
        }
        return Colors.blue;
      }), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ))
      ),
    )
  );
}