import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';

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
          Text(
            StrRes.ABOUT,
            style: H2.copyWith(color: AppColor.PRIMARY),
          ),
          Text(
            text,
            style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 16)),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
