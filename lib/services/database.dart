import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
 Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo:username)
        .snapshots();
  }
  uploadUserInfo(data){
    FirebaseFirestore.instance.collection("users")
        .add(data).catchError((e){
      print(e.toString());
    });
  }
  createChatRooms(String chatRoomId, chatRoomMap){
   FirebaseFirestore.instance.collection("chatRoom")
       .doc(chatRoomId).set(chatRoomMap).catchError((e){
         print(e.toString());
   });
  }
}
