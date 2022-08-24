import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stars_live/models/game_model.dart';
import 'package:stars_live/providers/game_provider.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/widgets/custom_widgets.dart';
import 'package:get/get.dart';

import '../../../global/constants.dart';

class GuessScreen extends StatefulWidget {
  static String id = '/guessScreen';

  const GuessScreen({Key? key}) : super(key: key);

  @override
  State<GuessScreen> createState() => _GuessScreenState();
}

class _GuessScreenState extends State<GuessScreen> {
  int? res = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GuessGameProvider>(
      create: (ctx) => GuessGameProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GRADIENT),
          ),
          centerTitle: true,
          // toolbarHeight: 50,
          title: Text(
            'guess game'.tr,
            style: Get.theme.textTheme.headline5?.copyWith(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context, builder: (context) => rulesDialog());
                },
                icon: Icon(Icons.info))
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 10),
              /*GestureDetector(
                onTap: () {
                  showDialog(
                      context: context, builder: (context) => rulesDialog());
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      gradient: GRADIENT,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      Icon(
                        FontAwesomeIcons.gamepad,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'game rules'.tr,
                        style: Get.textTheme.headline5
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              */
              SizedBox(height: 10),
              Expanded(
                flex: 2,
                child: Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.circular(20),
                  //       bottomRight: Radius.circular(20)),
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     colors: [
                  //       Color(0xffB83AF3),
                  //       Color(0xff6950FB),
                  //     ],
                  //   ),
                  // ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        offset: Offset(1.0, 4.0),
                      ),
                    ],
                  ),
                  child: Consumer<GuessGameProvider>(
                    builder: (context, game, child) =>
                        FutureBuilder<List<GameData>>(
                            future: game.getGamesList(),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                var gamesList = snapshot.data;
                                if (gamesList != null && gamesList.length > 0) {
                                  return ListView.builder(
                                    itemCount: gamesList.length,
                                    itemBuilder: (ctx, index) => matchItem(
                                      context,
                                      gameData: gamesList[index],
                                      // teamOneName: gamesList[index].teamOneName!,
                                      // teamOneImage:
                                      //     gamesList[index].teamOneImg ?? '',
                                      // teamTwoName: gamesList[index].teamTwoName!,
                                      // teamTwoImage:
                                      //     gamesList[index].teamTwoImg ?? '',
                                      // gameStartTime: gamesList[index].startAt,
                                      // gameDate: gamesList[index].gameDate,
                                    ),
                                    // reverse: true,
                                  );
                                }
                              }

                              return Text('No Matches Now');
                            }),
                  ),
                ),
              ),
              SizedBox(height: 10),

              /*    
             //List of winners
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text("Yesterday Winners")),
                        ),
    
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(5),
                            itemBuilder: (context, index) => winners(),
                            separatorBuilder: (ctx, index) => const Divider(color: Colors.grey,),
                            itemCount: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ), */
            ],
          ),
        ),
      ),
    );
  }

  void gameBet(
    BuildContext context, {
    required gameId,
    required amount,
    required String winner,
  }) async {
    final respond =
        await Provider.of<GuessGameProvider>(context, listen: false).betOnGame(
      gameId,
      amount,
      winner,
    );
    print(respond);
    customSnackBar(text: respond, context: context);
  }

  Widget matchItem(
    BuildContext context, {
    required GameData gameData,
  }) {
    var team1name = gameData.teamOneName?.trim() ?? '';
    var team2name = gameData.teamTwoName?.trim() ?? '';
    var team1Image = gameData.teamOneImg?.trim() ?? '';
    var team2Image = gameData.teamTwoImg?.trim() ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 90,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: team1Image.isEmpty
                        ? Image.asset(
                            ('assets/images/team.png'),
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            '$baseUrl/storage/$team1Image',
                            fit: BoxFit.fill,
                          ),
                  ),
                  Text(
                    team1name,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 90,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    //FIXME: Handle placeHolder

                    child: team2Image.isEmpty
                        ? Image.asset(
                            ('assets/images/team.png'),
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            '$baseUrl/storage/$team2Image',
                            fit: BoxFit.fill,
                          ),
                  ),
                  Text(
                    team2name,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Text(
                gameData.startAt ?? 'لم يتم تحديد ميعاد المبارة',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                gameData.gameDate != null
                    ? DateFormat('yyyy-MM-dd').format(gameData.gameDate!)
                    : 'لم يتم تحديد التاريخ',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (gameData.teamOneVoted!)
                  ? buildBetButton(team1name, () {}, Colors.grey)
                  : buildBetButton(team1name, () {
                      showDialog(
                          context: context, builder: (context) => alert()).then(
                        (value) {
                          if (value != null) {
                            print('bet with ======= $value =======');
                            gameBet(
                              context,
                              gameId: gameData.id,
                              amount: value,
                              winner: team1name,
                            );
                          }
                        },
                      );
                    }, Colors.amber),
              (gameData.drawVoted!)
                  ? buildBetButton('draw', () {}, Colors.grey)
                  : buildBetButton('draw', () {
                      showDialog(
                          context: context, builder: (context) => alert()).then(
                        (value) {
                          if (value != null) {
                            print('bet with ======= $value =======');
                            gameBet(
                              context,
                              gameId: gameData.id,
                              amount: value,
                              winner: 'draw',
                            );
                          }
                        },
                      );
                    }, Colors.amber),
              (gameData.teamTwoVoted!)
                  ? buildBetButton(team2name, () {}, Colors.grey)
                  : buildBetButton(team2name, () {
                      showDialog(
                          context: context, builder: (context) => alert()).then(
                        (value) {
                          if (value != null) {
                            print('bet with ======= $value =======');
                            gameBet(
                              context,
                              gameId: gameData.id,
                              amount: value,
                              winner: team2name,
                            );
                          }
                        },
                      );
                    }, Colors.amber),
            ],
          ),
          Divider(thickness: 1)
        ],
      ),
    );
  }

  ElevatedButton buildBetButton(
    String teamName,
    Function() onPressed,
    Color primaryColor,
  ) {
    return ElevatedButton(
      child: FittedBox(
        child: !teamName.contains('draw')
            ? Text('فوز ' + teamName)
            : Text('تعادل'),
      ),
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        onPrimary: Colors.black,
        maximumSize: Size(MediaQuery.of(context).size.width * 0.3,
            MediaQuery.of(context).size.height * 0.05),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.orange[700]!),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget winners() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
                "https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png"),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text("Winner 1"),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.solidStar,
                      color: Color.fromARGB(255, 255, 230, 0),
                      size: 10,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '45',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/coin.svg',
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '23112',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget alert() {
    return AlertDialog(
      content: Container(
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                child: buildRadioValues(10),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop(10);
                  });
                }),
            InkWell(
                child: buildRadioValues(100),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop(100);
                  });
                }),
            InkWell(
                child: buildRadioValues(1000),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop(1000);
                  });
                }),
            InkWell(
                child: buildRadioValues(5000),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop(5000);
                  });
                }),
            // // SizedBox(
            // //   height: 15,
            // // ),
            // buildRadioValues(1000),
            // // SizedBox(
            // //   height: 15,
            // // ),
            // buildRadioValues(5000),
          ],
        ),
      ),
    );
  }

  Widget rulesDialog() {
    String text = """ هذه المباريات حقيقية و يمكن مشاهدتها علي ارض الواقع
يمكنك التخمين مرة واحدة فقط على كل فريق
يمكنك التخمين على الفريق الاول والفريق الثاني والتعادل في كل مبارة
يمكنك التخمين على عدد لا محدود من المباريات في نفس الوقت
يحصل الاعب الفائز على ضعف التخمين الذي قام به يتم اضافة الجوائز خلال 24 ساعة من انتهاء المباراة ترجع حقوق التفسير الى STARS LIVE
    """;
    return AlertDialog(
      content: Container(
        height: 240,
        width: Get.width,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Row buildRadioValues(int valu) {
    return Row(
      children: [
        // Radio(
        //   value: valu,
        //   groupValue: res,
        //   onChanged: (int? val) async {
        //     // setState(() {
        //     //   res = val;
        //     //   print(res);
        //     //   Navigator.pop(context);
        //     // });
        //   },
        // ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/coin.svg',
                height: 24,
                width: 24,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '$valu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
