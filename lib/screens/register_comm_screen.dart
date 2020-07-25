import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/screens/location_picker_screen.dart';
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

  int _step = 0;

  TextEditingController _nameTxtCtrl = TextEditingController();
  TextEditingController _locTxtCtrl = TextEditingController();
  TextEditingController _descTxtCtrl = TextEditingController();
  TextEditingController _phoneTxtCtrl = TextEditingController();
  TextEditingController _waTxtCtrl = TextEditingController();
  TextEditingController _igTxtCtrl = TextEditingController();

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
                child: IndexedStack(
                  index: _step,
                  children: <Widget>[
                    buildAboutForm(),
                    buildContactForm()
                  ],
                ),
              ),
              buildActionButtons()
            ],
          ),
        ));
  }

  _onButton1Pressed() {
    switch (_step) {
      case 0:
        _onCancel();
        break;
      case 1:
        _onBack();
        break;
    } 
  }

  _onButton2Pressed() {
    switch (_step) {
      case 0:
        _onNext();
        break;
      case 1:
        _onRegister();
        break;
    }
  }

  _onNext(){
    setState(() => _step = 1);
  }

  _onBack(){
    setState(() => _step = 0);
  }

  _onCancel() {
    Navigator.of(context).pop();
  }

  _onRegister() {

  }

  _onLocationChanged(String province_name, String city_name){
    _locTxtCtrl.text = city_name;
  }

  Widget buildActionButtons() {

    String _button1_str = _step == 0 ? StrRes.CANCEL: StrRes.BACK;
    String _button2_str = _step == 0 ? StrRes.NEXT: StrRes.REGISTER;

    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AppButton(onPressed: _onButton1Pressed, text: _button1_str),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: AppButton(onPressed: _onButton2Pressed, text: _button2_str),
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
              controller: _nameTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_NAME,
            ),
            Text(
              StrRes.COMMUNITY_LOCATION,
              style: H5,
            ),
            CupertinoTextField(
              controller: _locTxtCtrl,
              readOnly: true,
              onTap: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> LocationPickerScreen(onChange: _onLocationChanged)));
              },
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_LOC,
            ),
            SizedBox(height: 15),
            Text(
              StrRes.COMMUNITY_DESC,
              style: H5,
            ),
            CupertinoTextField(
              controller: _descTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_DESC,
              maxLines: 10,
            )
          ],
        ))
      ],
    );
  }
  Widget buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          StrRes.CONTACT,
          style: H3,
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            Text(
              StrRes.PHONE,
              style: H5,
            ),
            CupertinoTextField(
              controller: _phoneTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_PHONE,
            ),
            SizedBox(height: 15),
            Text(
              StrRes.WA,
              style: H5,
            ),
            CupertinoTextField(
              controller: _waTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_PHONE,
            ),
            SizedBox(height: 15),
            Text(
              StrRes.IG,
              style: H5,
            ),
            CupertinoTextField(
              controller: _igTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_IG,
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
