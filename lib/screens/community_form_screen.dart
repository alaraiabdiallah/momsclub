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

  final Community data;
  final Function onSave;

  const CommunityFormScreen({Key key, this.data, this.onSave}) : super(key: key);
  @override
  _CommunityFormScreenState createState() =>
      _CommunityFormScreenState();
}

class _CommunityFormScreenState extends State<CommunityFormScreen> {

  int _step = 0;
  File _image;
  String _imagePath;
  FirebaseUser _user;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _nameTxtCtrl = TextEditingController();
  TextEditingController _locTxtCtrl = TextEditingController();
  TextEditingController _descTxtCtrl = TextEditingController();
  TextEditingController _phoneTxtCtrl = TextEditingController();
  TextEditingController _waTxtCtrl = TextEditingController();
  TextEditingController _igTxtCtrl = TextEditingController();
  TextEditingController _fbTxtCtrl = TextEditingController();
  TextEditingController _webTxtCtrl = TextEditingController();

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
    _editDataAttach();
    super.initState();
  }

  void _checkAuth() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) Navigator.of(context).pop();
    setState(()=> _user = user);
  }

  String _contactValueBySource(String source){
     List<Contact> contacts = widget.data.contacts;
     Contact contact = contacts.firstWhere((e) => e.source == source, orElse: () => null);
     return contact != null ? contact.value : null;
  }

  void _editDataAttach(){
    if(widget.data != null){
      _nameTxtCtrl.text = widget.data.name;
      _locTxtCtrl.text = widget.data.location;
      _descTxtCtrl.text = widget.data.desc;
      _imagePath = widget.data.imageURL;
      _phoneTxtCtrl.text = _contactValueBySource("phone");
      _waTxtCtrl.text = _contactValueBySource("whatsapp");
      _igTxtCtrl.text = _contactValueBySource("instagram");
      _fbTxtCtrl.text = _contactValueBySource("facebook");
      _webTxtCtrl.text = _contactValueBySource("website");
    }
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

  List<Map<String,dynamic>> _contactInputs(){
    List<Map<String,dynamic>> contacts = List<Map<String,dynamic>>();
    if(_phoneTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"phone", "value":_phoneTxtCtrl.text});
    if(_waTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"whatsapp", "value":_waTxtCtrl.text});
    if(_igTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"instagram", "value": _igTxtCtrl.text});
    if(_fbTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"facebook", "value": _fbTxtCtrl.text});
    if(_webTxtCtrl.text.isNotEmpty)
      contacts.add({"source":"website", "value": _webTxtCtrl.text});
    return contacts;
  }
  _onSave() async {
    try {
      String image;
      if(widget.data != null && widget.data.imageURL != null && _image == null){
        image = widget.data.imageURL;
      }else if(_image != null){
        image = await _uploadImage();
      }
      bool active = widget.data != null? widget.data.active : false;
      Map<String, dynamic> data = {
        "location": _locTxtCtrl.text,
        "name": _nameTxtCtrl.text,
        "desc": _descTxtCtrl.text,
        "active": active,
        "userId": _user.uid,
        "contacts": _contactInputs(),
        "imageURL": image
      };
      CollectionReference community = Firestore.instance.collection('communities');
      String msg = widget.data != null? StrRes.SUCCESS_SAVE_COMMUNITY : StrRes.SUCCESS_REGISTER_COMMUNITY;
      if(widget.data != null){
        await community.document(widget.data.id).updateData(data);
        widget.onSave();
      } else {
        await community.add(data);
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg),));
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
        String msg = widget.data != null ? StrRes.ALERT_SAVE_COMMUNITY : StrRes.ALERT_REGISTER_COMMUNITY;
        return AlertDialog(
          title: Text(StrRes.ALERT),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text(StrRes.NO),
              onPressed: () => Navigator.of(context).pop()
            ),
            FlatButton(
              child: Text(StrRes.YES),
              onPressed: () async {
                await _onSave();
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
    return _nameTxtCtrl.text.isNotEmpty && _locTxtCtrl.text.isNotEmpty && _descTxtCtrl.text.isNotEmpty;
  }

  Widget buildActionButtons() {

    String _button1_str = _step == 0 ? StrRes.CANCEL: StrRes.BACK;
    String _button2_str = _step == 0 ? StrRes.NEXT: StrRes.REGISTER;

    if(widget.data != null && _step == 1) _button2_str = StrRes.SAVE;

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
            if(_image == null && widget.data != null && widget.data.imageURL != null)...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(widget.data.imageURL, width: 200,height: 150,),
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
            ),
            SizedBox(height: 15),
            Text(
              StrRes.FB,
              style: H5,
            ),
            CupertinoTextField(
              controller: _fbTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_FB,
            ),
            SizedBox(height: 15),
            Text(
              StrRes.WEB,
              style: H5,
            ),
            CupertinoTextField(
              controller: _webTxtCtrl,
              placeholder: StrRes.COMMUNITY_FIELD_INSTR_WEB,
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
