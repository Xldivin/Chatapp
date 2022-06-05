import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/ChatRoomScreen.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
class SignUp extends StatefulWidget {
  final Function toogle;
  const SignUp(void Function() toogleView, {Key? key, required this.toogle}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  signPplUp(){
    if(_formKey.currentState!.validate()){
      Map<String, String> userdata= {
        "name":userNameTextEditingController.text,
        "email":emailTextEditingController.text
      };
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      setState(() {
        isloading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value){
        //print("$value.userId");
        databaseMethods.uploadUserInfo(userdata);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        )
        );
      });
    }
  }

  TextEditingController userNameTextEditingController =  TextEditingController();
  TextEditingController emailTextEditingController =  TextEditingController();
  TextEditingController passwordTextEditingController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: appBarMain(context),
      ),
      body: isloading ? const Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val) {
                        return val!.isEmpty || val.length < 2 ? "Username not complete" : null;},
                        style: textColor(),
                        controller: userNameTextEditingController,
                        decoration:textFieldInputDecoration("username")
                  ),
                    TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ? null : "Enter correct email";},
                        style: textColor(),
                        controller: emailTextEditingController,
                        decoration:textFieldInputDecoration("email")
                    ),
                    TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val!.length > 6 ? null : "provide password greater than six characters";},
                        style: textColor(),
                        controller: passwordTextEditingController,
                        decoration:textFieldInputDecoration("password")
                    ),],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerRight,
                child: Text('Forgot password?', style: textColor(),),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: (){
                  signPplUp();
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
                  child: Text("Sign Up",
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
                child: const Text("Sign Up with Google",
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
                  Text("Already have account?", style: textColor2(),),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: (){
                      widget.toogle();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("SignIn Now", style:  TextStyle(
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
    );
  }
}
