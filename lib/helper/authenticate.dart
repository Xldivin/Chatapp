import 'package:chatapp/views/Signup.dart';
import 'package:chatapp/views/Signin.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool firstUser = true;
  
  void toogleView(){
    setState(() {
      firstUser = !firstUser;
    });

  }


  @override
  Widget build(BuildContext context) {
    if(firstUser){
      return SignIn(toogleView, toogle: toogleView);

    }else{
      return SignUp(toogleView, toogle: toogleView);
    }
  }
}
