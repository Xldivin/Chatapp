import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';
import '../helper/constant.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  const ConversationScreen({Key? key, required this.chatRoomId }) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageTextEditingController = TextEditingController();

  Stream? chatMessageStream;

  Widget chatMessageList(){
    return Expanded(
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context,AsyncSnapshot  snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                return MessageTile(message:snapshot.data?.docs[index]['message'],
                    isSendByMe:snapshot.data?.docs[index]['sendBy'] == Constants.myname);
              }): Center(child: Text("No data found",
                style: TextStyle(
                color: Colors.grey[100],
                fontSize: 18.0
            ),
          ),
          );
        }
      ),
    );
  }

  sendMessage(){
    if(messageTextEditingController.text.isNotEmpty){
      Map<String,dynamic>messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Constants.myname,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text="";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: appBarMain(context),
      ),
      body: Column(
        children: [
          chatMessageList(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: messageTextEditingController,
                      style: TextStyle(
                        color: Colors.grey[400]
                      ),
                      decoration: InputDecoration(
                          hintText: "Type Your Message...",
                          hintStyle: TextStyle(
                              color: Colors.grey[400]
                          ),
                          border: InputBorder.none
                      )
                  ),
                ),
                IconButton(
                    onPressed: (){
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                    iconSize: 25,
                    color: Colors.teal,
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({Key? key, required this.message, required this.isSendByMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(message);
    return Container(
        padding: EdgeInsets.only(left: isSendByMe ? 0: 15, right: isSendByMe ? 15: 0),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 8),
      alignment: isSendByMe ? Alignment.centerRight :Alignment.centerLeft,
      child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            ),
            borderRadius: isSendByMe ? const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
                const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)
    ),),
        child: Text(message, style: const TextStyle(
            color: Colors.grey,
            fontSize: 17
        )
        ),
    )
    );
  }
}

