import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/views/ChatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'helper/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';


void main()  {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn= false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value!;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor:  Color(0xff1f1f1f),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? ChatRoom() : Authenticate()

    );
  }
}



