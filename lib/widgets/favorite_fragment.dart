import 'package:flutter/material.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/utils/infos.dart';

class FavoriteFragment extends StatefulWidget {
  @override
  _FavoriteFragmentState createState() => _FavoriteFragmentState();
}

class _FavoriteFragmentState extends State<FavoriteFragment> {
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
      ],
    );
  }
}
