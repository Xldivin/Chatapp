import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/ChatRoomScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth.dart';
import '../helper/helperFunctions.dart';
import '../widgets/widget.dart';


class SignIn extends StatefulWidget {
  final Function toogle;
  const SignIn(void Function() toogleView, {Key? key, required this.toogle}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  late QuerySnapshot snapshot;
  String error = '';
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();


  signPplIn() async {
    var userName;
    if(_formKey.currentState!.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      databaseMethods.getUserByEmail(emailTextEditingController.text).then((val){
        snapshot = val;
        userName = (snapshot.docs[0].data()!as Map<String, dynamic>)['name'];
        HelperFunctions.saveUserNameSharedPreference(userName);
      });
      dynamic result = await authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text);
      if(result!=null){
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        )
        );
      }if(result == null){
        setState(() {
          error = 'Login failed please give right credentials';
        });
      }
    }
  }

    TextEditingController emailTextEditingController = TextEditingController();
    TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: PreferredSize(
             preferredSize: const Size.fromHeight(50),
             child: appBarMain(context),
        ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -50,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ? null : "Enter correct email";},
                        style: textColor(),
                        decoration:textFieldInputDecoration("email"),
                        controller: emailTextEditingController,
                    ),
                    TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val!.length > 6 ? null : "provide password greater than six characters";},
                        style: textColor(),
                        decoration:textFieldInputDecoration("password"),
                        controller: passwordTextEditingController,
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text('Forgot password?', style: textColor(),),
                    ),
                    const SizedBox(height: 10.0),
                    Text(error,
                    style:TextStyle(
                      color: Colors.redAccent[200],
                      fontSize: 14.0
                    )
                    ),
                    GestureDetector(
                      onTap: (){
                        signPplIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1976D2),
                              Color(0xFF1976D2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("Sign In",
                          style: textColor2()
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF5F5F5),
                            Color(0xFFEEEEEE),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text("Sign In with Google",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account?", style: textColor2(),),
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: (){
                           widget.toogle();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Register Now", style:  TextStyle(
                                color: Colors.grey[100],
                                fontSize: 17,
                                decoration: TextDecoration.underline
                            ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          ) ,
    );
  }
}
