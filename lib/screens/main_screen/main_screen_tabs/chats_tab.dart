
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/chat_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/chat%20screen/chat_screen.dart';
import '../../../global/constants.dart';
import '../../search_screen/search_screen.dart';
import 'package:intl/intl.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key,}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
   bool first = true;
   bool firstmessg = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: GRADIENT,
          ),
        ),
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                // color: Colors.yellow,
                width: double.maxFinite,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'message'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(SearchScreen.id);
              },
              icon: const Icon(
                FontAwesomeIcons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),

      ),
      body: Column(
        children: [

          ChangeNotifierProvider(
            create: (context) => ChatProvider(),
            child: Consumer<ChatProvider>(
              builder: (context, value, child) {
                final String id = Provider.of<UserProvider>(context).userData?.data?.first.id.toString()??'';
                if(first)
                {
                  value.getAllChats(id);
                  first = false;
                }

                return value.userChats.length!=0? Flexible(
                  child: ListView.builder(
                    itemCount: value.userChats.length,
                    padding: const EdgeInsets.all(5),
                    itemBuilder: (contect, index) {
                     if(firstmessg) {
                              value.getMessages(
                                  receiverId: value.userChats[index].id,
                                  uId: id);

                              firstmessg= false;
                            }
                            return value.chat.length>0?InkWell(
                        onTap: (){
                          Get.to(ChatScreen(id: int.parse(value.userChats[index].id??'0'),imgurl:value.userChats[index].image,name: value.userChats[index].name,));
                        },
                        child:Container(
                          padding: const EdgeInsets.all(8.0),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: value.userChats[index].read!=null &&value.userChats[index].read==true ?Colors.transparent:Colors.grey[400],
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25.sp,
                                backgroundImage: NetworkImage(value.userChats[index].image??''),
                                backgroundColor: Colors.grey[300],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    Row(
                                      children: [
                                        Text(
                                          value.userChats[index].name??'username',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      value.userChats[index].lastMessage??'new message here',//'new message from'.tr+ ( value.userChats[index].name??'username'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: value.userChats[index].read!=null &&value.userChats[index].read==true ?const Color(0xffC1C0C9):Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight:value.userChats[index].read!=null &&value.userChats[index].read==true ? FontWeight.normal:FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  Text(DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd").parse(value.userChats[index].dateTime!)),style: Get.theme.textTheme.caption,),
                                  Text(value.userChats[index].dateTime!.split(' ').last.split(':').first+':'+value.userChats[index].dateTime!.split(' ').last.split(':')[1],style: Get.theme.textTheme.caption,)
                                ],
                              )
                              //SizedBox(width: 5,),
                            ],
                          ),
                        ),
                      ):Container();
                    },
                  ),
                ):Center(child: Text('no chats yet'.tr),);
              },
            ),
          ),
        ],
      ),
    );
  }
}