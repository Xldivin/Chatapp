import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/ConversationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:chatapp/helper/constant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Stream? usersStream;
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  searchUser() async{
   setState(() {});
   usersStream = await databaseMethods.getUserByUsername(searchTextEditingController.text);
   setState(() {});
  }
 /// this widget sends the searched user to chatroooms
  createChatroomConversation(String userName ){
    if(userName != Constants.myname){
      String chatRoomId = getChatRoomId(userName,Constants.myname);
      List<String>  users = [userName, Constants.myname];
      Map<String, dynamic> chatRoomMap = {
        "users":users,
        "chatroomId":chatRoomId
      };
      databaseMethods.createChatRooms(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (builder) => ConversationScreen(chatRoomId: chatRoomId,)
      ));
    }else{
      print("you can not send messege to your self");
    }
    }

/// this function(widget) returns the row of searched username
  Widget finishedList({ required String name, email}){
    return GestureDetector(
      onDoubleTap: (){
        createChatroomConversation(name);
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 20.0
                ),),
                Text(email, style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 20.0
                ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
/// this widget returns the listview builder with the name of searched username
  Widget searchUsersList(){
    return StreamBuilder(
        stream: usersStream,
        builder:(context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data?.docs[index];
              return finishedList(name:ds['name'], email:ds['email']);
            },
          ): Center(child: Text("search for the username",
            style: TextStyle(
            color: Colors.grey[100],
            fontSize: 18.0
          ),
          ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 50,),
    ),
        body: Column(
          children: [
            Container(
              color: Colors.grey[700],
              padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16),
              child: Row(
                children:  [
                  Expanded(
                      child: TextField(
                          controller: searchTextEditingController,
                          style: TextStyle(
                            color: Colors.grey[400]
                            ),
                          decoration: InputDecoration(
                            hintText: "search username...",
                            hintStyle: TextStyle(
                              color: Colors.grey[400]
                            ),
                            border: InputBorder.none
                          )
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      if(searchTextEditingController!=""){
                        searchUser();
                      }
                    },
                    child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Image.asset("assets/images/search_white.png")
                    ),
                  ),
                ],
              ),
            ),
            searchUsersList()
          ],
        ),
    );
  }
}
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}



