import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
 Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo:username)
        .snapshots();
  }
  getUserByEmail(String userEmail) async {
   return await FirebaseFirestore.instance
       .collection("users")
       .where("email", isEqualTo:userEmail)
       .get();
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
  addConversationMessages(String chatRoomId, messageMap){
   FirebaseFirestore.instance.collection("chatRoom")
       .doc(chatRoomId)
       .collection("chats")
       .add(messageMap).catchError((e){
         print(e.toString());
   });
  }
 Future<Stream<QuerySnapshot>> getConversationMessages(String chatRoomId) async{
   return FirebaseFirestore.instance.collection("chatRoom")
       .doc(chatRoomId)
       .collection("chats")
       .orderBy("time",descending: false)
       .snapshots();
   }
 Future<Stream<QuerySnapshot>> getChatRoom(String userName) async {
   return FirebaseFirestore.instance
       .collection("chatRoom")
       .where("users", arrayContains: userName)
       .snapshots();
 }
}
