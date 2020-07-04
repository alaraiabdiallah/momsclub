import 'package:flutter/material.dart';
import 'package:momsclub/styles/text_styles.dart';

class FollowersCommunityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Followers", style: H2.copyWith(color: Colors.black),)
        ],
      ),
    );
  }
}
