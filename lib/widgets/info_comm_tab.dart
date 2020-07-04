import 'package:flutter/material.dart';
import 'package:momsclub/styles/text_styles.dart';

class InfoCommunityTab extends StatelessWidget {

  final String text;

  const InfoCommunityTab({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Information", style: H2.copyWith(color: Colors.black),),
          Text(text)
        ],
      ),
    );
  }
}
