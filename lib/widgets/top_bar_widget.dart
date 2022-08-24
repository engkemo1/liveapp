import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/singl_user_model.dart';
import 'package:stars_live/providers/search_provider.dart';
import 'user_info_bottom_sheet.dart';
import '../screens/audiance_screen/audiance.dart';

class TopBarWidget extends StatefulWidget {
  final users, arguments, onIconPressed, recieverID, onBlockHost;
  final String? fromWhere, type;

  TopBarWidget({
    Key? key,
    required this.fromWhere,
    this.type,
    this.users,
    this.arguments,
    this.onIconPressed,
    required this.recieverID,
    this.onBlockHost,
  }) : super(key: key);

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  String totalDiamond = '0';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FirebaseFirestore.instance
          .collection('userDiamonds')
          .doc(widget.fromWhere == '/broadcasterScreen'
              ? widget.arguments['channel']
              : widget.arguments['id'])
          .snapshots()
          .listen((event) {
        setState(() {
          totalDiamond = event.data()!['diamond'];
        });
        print('total diamond = ' + totalDiamond.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  //COMNT : close session after block host
                  onTap: () async {
                    await Get.bottomSheet(
                      UserInfoBottomSheet(
                        user: User.fromJson(widget.arguments['user']),
                        recieverID: widget.recieverID.toString(),
                        isHost: true,
                        // onBlockHost: widget.onIconPressed,
                      ),
                    );
                    // Get.back();
                    // Get.back();
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(widget.arguments['image'].toString()),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(UserInfoBottomSheet(
                              user: User.fromJson(widget.arguments['user']),
                              recieverID: widget.recieverID.toString(),
                            ));
                          },
                          child: Text(
                            (widget.arguments['name'].toString().length > 7)
                                ? '...' +
                                    widget.arguments['name']
                                        .toString()
                                        .characters
                                        .take(7)
                                        .toString()
                                : widget.arguments['name'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.users,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          ' ${widget.users.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    child: ListView.builder(
                        //padding: const EdgeInsets.all(5),
                        itemCount: widget.users.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(2),
                            child: InkWell(
                              onTap: () {
                                Get.bottomSheet(UserInfoBottomSheet(
                                  user: User.fromJson(
                                      widget.users[index].toJson()),
                                  recieverID: widget.recieverID.toString(),
                                ));
                              },
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  widget.users[index].image.toString(),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: widget.onIconPressed,
                color: Colors.black,
                icon: Icon(
                  Icons.close,
                  size: 15,
                ),
                padding: EdgeInsets.all(0),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.solidStar,
                    color: Color.fromARGB(
                      255,
                      255,
                      230,
                      0,
                    ),
                    size: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.arguments[widget.fromWhere == Audiance.id
                            ? 'hostLevel'
                            : 'level']
                        .toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidGem,
                  color: Colors.blue[500],
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                ChangeNotifierProvider(
                  create: (context) => SearchProvider(),
                  child: Consumer<SearchProvider>(
                    builder: (context, value, child) {
                      return Text(
                        totalDiamond,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
