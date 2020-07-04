import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/screens/community_screen.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/bottom_navs.dart';
import 'package:momsclub/widgets/community_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  EdgeInsets _screen_body_padding =  EdgeInsets.symmetric(vertical: 0, horizontal: 25);

  void _onBottomNavTapped(index){
    print(index);
  }

  double _meet_comm_text_margin_bot = 15;
  double _MeetCommTextMarginTop(context) => (MediaQuery.of(context).size.height * (1/7));
  double _CommGridSize(context) => (MediaQuery.of(context).size.height * (6/7));

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> loadCommunities() => Firestore.instance.collection('communities').snapshots();


  Widget _buildCommunityGridItem(Community data, BuildContext context){
    return CommunityItem(
        name: data.name,
        location: data.location,
        imageURL: data.imageURL,
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityScreen(data: data)));
        }
    );
  }

  Widget _buildCommunityGrid(context){
    return StreamBuilder(
        stream: loadCommunities(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError)
            return Container(
                height: _CommGridSize(context),
                child: Center(
                    child: Text('Error: ${snapshot.error}')
                )
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Container(
              height: _CommGridSize(context),
              child: Center(
                  child: CircularProgressIndicator()
              ),
            );
            default:
              return Container(
                height: _CommGridSize(context),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 1.8,
                  children: snapshot.data.documents.map((DocumentSnapshot document) {

                    Community comm = Community.fromJson(document.data);
                    return _buildCommunityGridItem(comm, context);
                  }).toList(),
                ),
              );
          }
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        padding: _screen_body_padding,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: _MeetCommTextMarginTop(context), bottom: _meet_comm_text_margin_bot),
            child: Text(StrRes.MEET_COM, style: H1,),
          ),
          _buildCommunityGrid(context)
//          Container(
//            height: _CommGridSize(context),
//            child: GridView.count(
//              crossAxisCount: 2,
//              crossAxisSpacing: 10,
//              mainAxisSpacing: 10,
//              childAspectRatio: 1 / 1.8,
//              children: <Widget>[
//                CommunityItem(name: "ajdwawi", location: "Bandung", onTap: (){
//                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityScreen()));
//                },),
//                CommunityItem(name: "ajdwawi", location: "Bandung", onTap: (){},),
//                CommunityItem(name: "ajdwawi", location: "Bandung", onTap: (){},),
//                CommunityItem(name: "ajdwawi", location: "Bandung", onTap: (){},),
//                CommunityItem(name: "ajdwawi", location: "Bandung", onTap: (){},),
//                CommunityItem(name: "ajdwawi", location: "Bandung", onTap: (){},),
//                CommunityItem(name: "ajdwawi", location: "Bandung", onTap: (){},),
//              ],
//            ),
//          )


        ],
      ),
        bottomNavigationBar: AppBottomNav(onItemTapped: _onBottomNavTapped)
    );
  }

}

