import 'package:flutter/material.dart';

class GuessTeamScreen extends StatefulWidget {
  const GuessTeamScreen({ Key? key }) : super(key: key);

  @override
  State<GuessTeamScreen> createState() => _GuessTeamScreenState();
}

class _GuessTeamScreenState extends State<GuessTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Padding(padding: EdgeInsets.symmetric(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          child: Column(children: [
            Card(
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('')),
                        SizedBox(height: 10,),
                        Text('TeamName')
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('')),
                        SizedBox(height: 10,),
                        Text('TeamName')
                      ],
                    )

                  ],
                )
              ]),
            )
          ]),

        ),
        SizedBox(height: 20,),
        Container()
      ]),) ,
    );
  }
}