import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';

import 'community_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final _search_text_ctrl = TextEditingController();

  List<String> _recent_search = List<String>();

  _headerHeight(context) => (MediaQuery.of(context).size.height * (1/6));
  _bodyHeight(context) => (MediaQuery.of(context).size.height * (5/6));

  EdgeInsets _box_padd = EdgeInsets.symmetric(horizontal: 15);

  _backButton() => GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back,size: H1.fontSize),
          SizedBox(width: 10,),
          Text(StrRes.BACK.toLowerCase(), style: H4.copyWith(color: Colors.black),)
        ],
      ),
  );

  String _search_state = "INIT";

  List<Community> _search_result_data = List<Community>();

  _onSearch(String text) async {
    if(text.toString().isNotEmpty){
      setState(() => _search_state = "LOADING");
      var query = await Firestore.instance.collection('communities').getDocuments(source: Source.server);
      _search_result_data = query.documents.map((doc) => Community.fromJson(doc.data))
          .where((doc) => doc.name.toLowerCase().contains(text.toLowerCase()) || doc.location.toLowerCase().contains(text.toLowerCase())).toList();
      setState(() {
        _search_state = "DONE";
        _recent_search.add(text);
        if(_recent_search.length > 4) _recent_search.removeAt(0);
      });
    }
  }

  Widget _searchBox() {
    double prefix_left_margin = 10;
    double box_radius = 25;
    return CupertinoTextField(
      controller: _search_text_ctrl,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(box_radius)
      ),
      prefix: Container(
          margin: EdgeInsets.only(left: prefix_left_margin),
          child: Icon(Icons.search, color: Colors.grey,)
      ),
      placeholder: "Search",
      onSubmitted: _onSearch,
      onTap: (){
        setState(() => _search_state = "INIT");
        _search_text_ctrl.text = "";
      },
    );
  }

  Widget _buildHeader(context) {

    BoxDecoration _header_decor = BoxDecoration(
        color: AppColor.SECONDARY
    );

    return Material(
      elevation: 2,
      child: Container(
        width: double.infinity,
        height: _headerHeight(context),
        decoration: _header_decor,
        padding: _box_padd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _backButton(),
            SizedBox(height: 10,),
            _searchBox()
          ],
        ),
      ),
    );
  }

  Widget _recentSearchItem({text, Function onTap}){
    BorderRadius br = BorderRadius.circular(25);
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Material(
        child: InkWell(
          borderRadius: br,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: br,
              border: Border.all(color: Colors.grey,)
            ),
            child: Center(
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }

  Widget _recentSearch() {
    TextStyle heading_style = H5.copyWith(color: Colors.black);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(StrRes.RECENT, style: heading_style,),
        SizedBox(height: 10,),
        Container(
          height: 32,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _recent_search.reversed.map((e) => _recentSearchItem(text: e,onTap: (){
              _search_text_ctrl.text = e;
            })).toList(),
          ),
        )

      ],
    );
  }

  Widget _searchResultItem({Community data}) {

    Widget _image = Container(
      width: 125,
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(data.imageURL),
          fit: BoxFit.fill
        )
      ),
    );

    Widget _text = Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data.name, style: H5.copyWith(color: Colors.black), textAlign: TextAlign.left, softWrap: true,),
            Text(data.location, style: ThinText.copyWith(color: Colors.black),textAlign: TextAlign.left)
          ],
        )
    );

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityScreen(data: data)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              _image,
              SizedBox(width: 10,),
              _text
          ],
        ),
      ),
    );
  }

  Widget _searchResults() {
    switch(_search_state){
      case "START":
        return Container();
        break;
      case "LOADING":
        return Center(child: CircularProgressIndicator());
        break;
      case "DONE":
        return Container(
          child: Column(
            children: _search_result_data.map((e) => _searchResultItem(data: e)).toList(),
          ),
        );
        break;
      default:
        return Container();
    }
  }

  Widget _buildBody(context){
    EdgeInsets padd = EdgeInsets.symmetric(vertical: 25, horizontal: _box_padd.horizontal);
    return Container(
      width: double.infinity,
      child: ListView(
        padding: padd,
        children: <Widget>[
          if(_recent_search.length > 0 && _search_state == "INIT")...[
            _recentSearch(),
          ],
          SizedBox(height: 10,),
          _searchResults()
        ],
      ),
    );
  }
  
  @override
  void initState() {
    _search_text_ctrl.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: _buildBody(context),
            )
          ],
        ),
      ),
    );
  }
}
