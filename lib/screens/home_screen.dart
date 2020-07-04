import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/screens/community_screen.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/bottom_navs.dart';
import 'package:momsclub/widgets/community_item.dart';
import 'package:momsclub/widgets/favorite_fragment.dart';
import 'package:momsclub/widgets/home_fragment.dart';
import 'package:momsclub/widgets/mycomminity_fragment.dart';

import 'community_screen2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _navIndex = 0;
  void _onBottomNavTapped(index){
    setState(() => _navIndex = index );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: <Widget>[
          HomeFragment(),
          FavoriteFragment(),
          MyCommunityFragment(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(onItemTapped: _onBottomNavTapped)
    );
  }

}

