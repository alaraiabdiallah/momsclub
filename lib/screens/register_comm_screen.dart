import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/buttons.dart';

class RegisterCommunityScreen extends StatefulWidget {
  @override
  _RegisterCommunityScreenState createState() =>
      _RegisterCommunityScreenState();
}

class _RegisterCommunityScreenState extends State<RegisterCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(StrRes.APP_NAME, style: H4),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildHeader(context),
              Expanded(
                child: buildAboutForm(),
              ),
              buildActionButtons()
            ],
          ),
        ));
  }

  Widget buildActionButtons() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AppButton(onPressed: null, text: StrRes.CANCEL),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: AppButton(onPressed: null, text: StrRes.NEXT),
          )
        ],
      ),
    );
  }

  Widget buildAboutForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          StrRes.ABOUT,
          style: H3,
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            Text(
              StrRes.COMMUNITY_NAME,
              style: H5,
            ),
            CupertinoTextField(
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_NAME,
            ),
            SizedBox(height: 15),
            Text(
              StrRes.COMMUNITY_DESC,
              style: H5,
            ),
            CupertinoTextField(
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_DESC,
              maxLines: 10,
            )
          ],
        ))
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: screenTextMarginTop(context), bottom: screenTextMarginBotttom),
      child: Text(
        StrRes.COMMUNITY_FORM,
        style: H1,
      ),
    );
  }
}
