import 'package:flutter/material.dart';
Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/logo.png", height: 50.0,),
  );
}
InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
        color: Colors.grey[100]
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: (Colors.grey[100])!)
    ),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: (Colors.grey[100])!)
    ),
  );
}
TextStyle textColor(){
  return TextStyle(color: Colors.grey[100]);
}

TextStyle textColor2(){
  return TextStyle(
      color: Colors.grey[100],
      fontSize: 17
  );
}


