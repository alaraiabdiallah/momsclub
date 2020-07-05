import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/models/user_model.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/exceptions.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/buttons.dart';
import 'package:momsclub/widgets/inputs.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameTextCtrl = TextEditingController();
  final _emailTextCtrl = TextEditingController();
  final _passwordTextCtrl = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _coll = Firestore.instance.collection('users');

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _onLoading = false;
  void _onLoginButtonPressed(){
    Navigator.of(context).pop();
  }

  Future<FirebaseUser> _doRegister() async{
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
    email: _emailTextCtrl.text,
    password: _passwordTextCtrl.text,
    )).user;
    await user.sendEmailVerification();
    return user;
  }

  Future<void> _saveUser(FirebaseUser user) async{
    UserModel userData = UserModel(
        email:_emailTextCtrl.text,
        name: _nameTextCtrl.text,
        is_verify: user.isEmailVerified,
        user_id: user.uid
    );
    await _coll.document().setData(userData.toMap());
  }

  void _onRegisterPressed() async {
    try{
      setState(() => _onLoading = true);
      FirebaseUser user = await _doRegister();
      await _saveUser(user);
      final snackBar = SnackBar(content: Text(StrRes.REGISTER_SUCCEED));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();
      setState(() => _onLoading = false);
    } on PlatformException catch(e) {
      if(e.code == "ERROR_EMAIL_ALREADY_IN_USE"){
        final snackBar = SnackBar(content: Text(StrRes.EMAIL_ALREADY_REGISTERED), backgroundColor: Colors.red);
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
      setState(() => _onLoading = false);
    } catch(e) {
      final snackBar = SnackBar(content: Text(StrRes.REGISTER_FAILED), backgroundColor: Colors.red);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() => _onLoading = false);
      print("Something error ${e.toString()}");
    }
//    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  
  @override
  Widget build(BuildContext context) {
    double _formWidgetWidth = 250;
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(StrRes.REGISTER, style: H1,),
            SizedBox(height: 100,),
            Container(
              width: _formWidgetWidth,
              child: AppFormInput(
                controller: _nameTextCtrl,
                placeholder: "Name",
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: _formWidgetWidth,
              child: AppFormInput(
                controller: _emailTextCtrl,
                placeholder: "Email",
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: _formWidgetWidth,
              child: AppFormInput(
                obscure: true,
                controller: _passwordTextCtrl,
                placeholder: "Password",
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: _formWidgetWidth,
              child: AppButton(onPressed: _onLoading? null : _onRegisterPressed,text: _onLoading? StrRes.LOADING : StrRes.LOGIN),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: _onLoginButtonPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(StrRes.ALREADY_HAVE_ACCOUNT, style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: AppColor.GREY3, fontWeight: FontWeight.w600)
                  )),
                  SizedBox(width: 3,),
                  Text(StrRes.SIGNIN, style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: AppColor.PRIMARY, fontWeight: FontWeight.w600)
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
