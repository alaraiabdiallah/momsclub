
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/screens/community_screen2.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/not_found.dart';

import 'community_item.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {

  Stream<QuerySnapshot> loadCommunities() => Firestore.instance.collection('communities').snapshots();
  final _search_text_ctrl = TextEditingController();
  String _search_keyword = "";

  Community _convertDocument(DocumentSnapshot document) => Community.fromJson(document.data);

  bool _searchQuery(doc){
    String name = doc.name.toLowerCase();
    String loc = doc.location.toLowerCase();
    String keyword = _search_keyword.toLowerCase();
    return name.contains(keyword) || loc.contains(keyword);
  }


  _onSearch(String text){
    setState(() {
      _search_keyword = text;
    });
  }

  Widget _searchBox() {
    double prefix_left_margin = 10;
    double box_radius = 10;
    return CupertinoTextField(
      controller: _search_text_ctrl,
      decoration: BoxDecoration(
          color: AppColor.GREY,
          borderRadius: BorderRadius.circular(box_radius)
      ),
      prefix: Container(
          margin: EdgeInsets.only(left: prefix_left_margin),
          child: Icon(Icons.search, color: Colors.grey,)
      ),
      placeholder: "Search",
      placeholderStyle: TextStyle(color: Colors.grey),
      onSubmitted: _onSearch,
    );
  }


  Widget _buildCommunityGridItem(Community data, BuildContext context){
    return CommunityItem(
        name: data.name,
        location: data.location,
        imageURL: data.imageURL,
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityScreen2(data: data)));
        }
    );
  }

  Widget _buildCommunityGrid(context){
    return StreamBuilder(
        stream: loadCommunities(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError)
            return Container(
                height: commonGridSize(context),
                child: Center(
                    child: Text('Error: ${snapshot.error}')
                )
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Container(
              height: commonGridSize(context),
              child: Center(
                  child: CircularProgressIndicator()
              ),
            );
            default:
              List<Community> comms = snapshot.data.documents.map(_convertDocument).toList();

              if(_search_keyword.isNotEmpty)
                comms = comms.where(_searchQuery).toList();

              if(comms.isEmpty) return NotFoundDisplay();

              return Container(
                height: commonGridSize(context),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 1.8,
                  children: comms.map((Community comm) {
                    return _buildCommunityGridItem(comm, context);
                  }).toList(),
                ),
              );
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: screenBodyPadding,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenTextMarginTop(context), bottom: screenTextMarginBotttom),
          child: Text(StrRes.MEET_COM, style: H1,),
        ),
        _searchBox(),
        _buildCommunityGrid(context)
      ],
    );
  }
}
