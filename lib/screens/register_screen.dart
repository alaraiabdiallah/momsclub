import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/styles/text_styles.dart';
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

  void onLoginButtonPressed(){
    Navigator.of(context).pop();
  }
  void onRegisterPressed(){
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  
  @override
  Widget build(BuildContext context) {
    double _formWidgetWidth = 250;
    return Scaffold(
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
              child: AppButton(onPressed: onRegisterPressed,text: StrRes.LOGIN),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: onLoginButtonPressed,
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
