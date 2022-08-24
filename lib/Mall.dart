import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'global/constants.dart';

class Mall extends StatefulWidget {
  const Mall({Key? key}) : super(key: key);

  @override
  State<Mall> createState() => _MallState();
}

class _MallState extends State<Mall> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: GRADIENT),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        title: Text(
          'mall'.tr,
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
      ),
      body: SafeArea(
        child: Column(

          children: [

            Container(
              height: 50,
              alignment: Alignment.topCenter,
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    text: 'tires'.tr,
                  ),
                  Tab(
                    text: 'my income'.tr,
                  ),
                  Tab(
                    text: 'my property'.tr,
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.green,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text(
                      " tires ".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, ),
                    ),
                  ),
                  Center(
                    child: Text("Screen 2"),
                  ),
                  Center(
                    child: Text("Screen 3"),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
