import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/models/favorite_model.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/local_db.dart';
import 'package:momsclub/widgets/contact_comm_tab.dart';
import 'package:momsclub/widgets/info_comm_tab.dart';

class CommunityScreen2 extends StatefulWidget {
  final Community data;

  final Function onChange;

  const CommunityScreen2({Key key, this.data, this.onChange}) : super(key: key);
  @override
  _CommunityScreen2State createState() => _CommunityScreen2State();
}

class _CommunityScreen2State extends State<CommunityScreen2> {

  bool _isFavorite = false;

  void checkFavorite() async{
    var isFav = await isFavorite(widget.data.id);
    setState(() => _isFavorite = isFav);
  }

  @override
  void initState() {
    checkFavorite();
  }

  _backButton() => GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: Container(
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back,size: H1.fontSize, color: Colors.white),
          SizedBox(width: 10,),
          Expanded(
            child: Text(widget.data.name, style: H4.copyWith(color: Colors.white)),
          )

        ],
      ),
    ),
  );

  Widget _header(){
    double _padding = 25;
      return Container(
        decoration: BoxDecoration(
            color: AppColor.GREY2,
            image: DecorationImage(
                image: NetworkImage(widget.data.imageURL),
                fit: BoxFit.cover
            )
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 3,
        child: Container(
            padding: EdgeInsets.all(_padding),
            color: Colors.black.withOpacity(0.3),
            child: Column(
              children: <Widget>[
                _backButton()
              ],
            ),
        ),
      );
  }

  Widget _body(){
    double _radius = 50;
    double _margin_offset = (MediaQuery.of(context).size.height / 3) - 50;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: EdgeInsets.only(top:_margin_offset),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(_radius), topRight: Radius.circular(_radius))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InfoCommunityTab(text: widget.data.desc,),
          ContactCommunityTab(data: widget.data.contacts,),
        ],
      ),
    );
  }

  _onFavoriteButtonPressed(){
    var fav = FavoriteModel(id: widget.data.id);
    if(_isFavorite){
      setState(() => _isFavorite = false);
      deleteFavorite(fav.id);
    } else{
      setState(() => _isFavorite = true);
      insertFavorite(fav);
    }
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Stack(
              children: <Widget>[
                _header(),
                _body()
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFavoriteButtonPressed,
        backgroundColor: AppColor.PRIMARY,
        child: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      )
    );
  }
}
