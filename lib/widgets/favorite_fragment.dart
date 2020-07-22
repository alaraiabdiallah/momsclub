import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/screens/community_screen2.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/local_db.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/utils/infos.dart';

import 'community_item.dart';
import 'not_found.dart';

class FavoriteFragment extends StatefulWidget {
  @override
  _FavoriteFragmentState createState() => _FavoriteFragmentState();
}

class _FavoriteFragmentState extends State<FavoriteFragment> {
  
  Stream<QuerySnapshot> loadCommunities() => Firestore.instance.collection('communities').snapshots();
  List<String> _ids = [];
  
  void getIds() async{
    var favs = await getAllFavs();
    setState(() => _ids = favs);
  }

  _onChange(){
    getIds();
  }
  
  @override
  void initState() {
    getIds();
  }

  Community _convertDocument(DocumentSnapshot document) {
    var data = document.data;
    data['id'] = document.documentID;
    return Community.fromJson(data);
  }

  Widget _buildCommunityGridItem(Community data, BuildContext context){
    return CommunityItem(
        name: data.name,
        location: data.location,
        imageURL: data.imageURL,
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityScreen2(data: data, onChange: _onChange,)));
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
              List<Community> comms = snapshot.data.documents.map(_convertDocument)
                  .where((d)=>  _ids.contains(d.id)).toList();
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
          child: Text(StrRes.FAV_COM, style: H1,),
        ),
        _buildCommunityGrid(context)
      ],
    );
  }
}
