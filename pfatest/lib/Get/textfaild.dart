import 'package:flutter/material.dart';

TextField getTextField(String text, IconData icon, bool isPasswordtype,
TextEditingController controller){

  return TextField(
    controller: controller,
    obscureText: isPasswordtype,
    enableSuggestions:!isPasswordtype,
    autocorrect: !isPasswordtype,
    cursorColor: Colors.blue,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.blue,),
    labelText: text,
    labelStyle: TextStyle( color: Colors.grey.withOpacity(0.9)),
    filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey.withOpacity(0.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(width: 0,style:BorderStyle.solid )),
    ),
  keyboardType: isPasswordtype ? TextInputType.visiblePassword:TextInputType.emailAddress,
  );
}