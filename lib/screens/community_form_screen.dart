import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/screens/location_picker_screen.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/buttons.dart';
import 'package:slugify/slugify.dart';


class CommunityFormScreen extends StatefulWidget {

  final Community community;

  const CommunityFormScreen({Key key, this.community}) : super(key: key);
  @override
  _CommunityFormScreenState createState() =>
      _CommunityFormScreenState();
}

class _CommunityFormScreenState extends State<CommunityFormScreen> {

  int _step = 0;
  File _image;
  FirebaseUser _user;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _nameTxtCtrl = TextEditingController();
  TextEditingController _locTxtCtrl = TextEditingController();
  TextEditingController _descTxtCtrl = TextEditingController();
  TextEditingController _phoneTxtCtrl = TextEditingController();
  TextEditingController _waTxtCtrl = TextEditingController();
  TextEditingController _igTxtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

  @override
  void initState() {
    _checkAuth();
    super.initState();
  }

  void _checkAuth() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) Navigator.of(context).pop();
    setState(()=> _user = user);
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
        _onRegisterButtonPressed();
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

  _uploadImage() async {
    
    var uniq = md5.convert(utf8.encode(DateTime.now().toIso8601String())).toString();
    uniq = uniq.substring(0,5);
    String filename = Slugify("${_nameTxtCtrl.text} $uniq");
    StorageReference ref = FirebaseStorage.instance.ref().child("image/$filename");
    StorageTaskSnapshot uploadImg = await ref.putFile(_image).onComplete;
    if(uploadImg.error != null){
      throw Exception(StrRes.FAILED_UPLOAD_IMAGE);
    }
    return await ref.getDownloadURL();
  }
  _onRegister() async {
    List<Map<String,dynamic>> contacts = List<Map<String,dynamic>>();
    if(_phoneTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"phone", "value":_phoneTxtCtrl.text});
    if(_waTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"whatsapp", "value":_waTxtCtrl.text});
    if(_igTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"instagram", "value": _igTxtCtrl.text}); 

    try {
      CollectionReference community = Firestore.instance.collection('communities');
      var imageUploaded = await _uploadImage();
      Map<String,dynamic> data = {
        "location": _locTxtCtrl.text,
        "name": _nameTxtCtrl.text,
        "desc": _descTxtCtrl.text,
        "active": false,
        "userId": _user.uid,
        "contacts": contacts,
        "imageURL": imageUploaded
      }; 
      await community.add(data);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(StrRes.SUCCESS_REGISTER_COMMUNITY),));
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pop();
    } on Exception catch (e) {
      print(e);
      var sb = SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,);
      _scaffoldKey.currentState.showSnackBar(sb);
    } catch(e){
      print(e);
      var sb = SnackBar(content: Text(StrRes.FAILED_REGISTER_COMMUNITY), backgroundColor: Colors.red,);
      _scaffoldKey.currentState.showSnackBar(sb);
    }
    

    
  }

  _onRegisterButtonPressed() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StrRes.ALERT),
          content: Text(StrRes.ALERT_REGISTER_COMMUNITY),
          actions: <Widget>[
            FlatButton(
              child: Text(StrRes.NO),
              onPressed: () => Navigator.of(context).pop()
            ),
            FlatButton(
              child: Text(StrRes.YES),
              onPressed: () async {
                await _onRegister();
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      },
    );
  }

  _onLocationChanged(String province_name, String city_name){
    _locTxtCtrl.text = city_name;
  }

  _onOpenGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if(image != null)
      setState(() => _image = File(image.path));
  }

  _onImageCancel(){
    setState(() => _image = null);
  }

  _button2Condition() {
    return _nameTxtCtrl.text.isNotEmpty && _locTxtCtrl.text.isNotEmpty && _descTxtCtrl.text.isNotEmpty && (_image != null);
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
            child: AppButton(onPressed: _button2Condition()? _onButton2Pressed: null, text: _button2_str),
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
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => LocationPickerScreen(onChange: _onLocationChanged)));
              },
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_LOC,
            ),
            SizedBox(height: 15),
            Text(
              StrRes.PICK_IMAGE,
              style: H5,
            ),
            RaisedButton(
              onPressed: _onOpenGallery, 
              child: Text(StrRes.OPEN_GALLERY, style: TextStyle(color: Colors.white),),
              color: AppColor.PRIMARY,
            ),
            if(_image != null)...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.file(_image, width: 200,height: 150,),
                  IconButton(icon: Icon(Icons.cancel), onPressed: _onImageCancel,)
                ],
              )
            ],
            SizedBox(height: 15),
            Text(
              StrRes.COMMUNITY_DESC,
              style: H5,
            ),
            CupertinoTextField(
              controller: _descTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_DESC,
              maxLines: 10,
            ),
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
              keyboardType: TextInputType.phone,
              controller: _phoneTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_PHONE,
            ),
            SizedBox(height: 15),
            Text(
              StrRes.WA,
              style: H5,
            ),
            CupertinoTextField(
              keyboardType: TextInputType.phone,
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
