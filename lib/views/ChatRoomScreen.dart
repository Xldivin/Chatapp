import 'package:chatapp/helper/constant.dart';
import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/Search.dart';
import "package:flutter/material.dart";
import '../helper/authenticate.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream? chatRoomStream;

  Widget  chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder:(context, AsyncSnapshot  snapshot){
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return ChatRoomList(userName: snapshot.data?.docs[index]['message'],

              );
            }
          );
        });
  }

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getChatRoom(Constants.myname);
    super.initState();
  }

  getUserInfo() async{
    Constants.myname = (await HelperFunctions.getUserNameSharedPreference()) as String;
    print("${Constants.myname}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
          height: 50,),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
class ChatRoomList extends StatelessWidget {
  final String userName;
  const ChatRoomList({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40)
            ),
            child: Text("${userName.substring(0,1).toUpperCase()}"),
          ),
          SizedBox(width: 8,),
          Text(userName, style: TextStyle(),),
        ],
      ),
    );
  }
}

