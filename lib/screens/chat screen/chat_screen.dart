import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/chat_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/chat%20screen/widgets/send_msg.dart';
import 'package:stars_live/screens/chat%20screen/widgets/receive_msg.dart';
import 'package:stars_live/screens/chat%20screen/widgets/type_msg.dart';

import '../../global/constants.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final int ?id ;
  final String ?imgurl;
  final String ?name;


  ChatScreen({required this.id ,required this.imgurl ,required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool first = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
      String myId = context.read<UserProvider>().userData?.data?.first.id.toString()??'';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myId)
          .collection('chats')
          .doc(widget.id.toString())
          .update({'read':true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Consumer<UserProvider>(
          builder: (context , value , child){
            var me = value.userData?.data?.first;
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: GRADIENT
                  ),
                ),
                titleSpacing: 0.0,
                centerTitle: true,
                title: Text(
                  '${widget.name}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${widget.imgurl}'),
                      radius: 20.0,
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  var height = constraints.constrainHeight();

                  return ChangeNotifierProvider(
                    create: (ctx) => ChatProvider(),
                    child: Consumer<ChatProvider>(
                      builder: (ctx , val , child){
                        if(first)
                        {
                      val.getMessages(
                          receiverId: widget.id.toString(),
                          uId: me?.id.toString());
                          first=false;
                     }
                    var chat = List.from(val.chat.reversed);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: height - 60.0 ,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    reverse: true,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if (chat[index].receiverUid != me?.id.toString())
                                        return sendMsg(chat[index]);
                                      else
                                        return receiveMsg(chat[index]);
                                    },
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: 10.0,
                                    ),
                                    itemCount: chat.length,
                                  ),
                                )),
                            SizedBox(height: 10,),
                            typeMsg(widget.id , value.userData?.data?.first,widget.name??'',widget.imgurl??''),
                          ],
                        );
                      },
                    ),
                  );
                }),
              ),
            );
          },
        ));
  }
}
