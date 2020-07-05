import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/screens/register_screen.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/buttons.dart';
import 'package:momsclub/widgets/inputs.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailTextCtrl = TextEditingController();
  final _passwordTextCtrl = TextEditingController();

  void onLoginButtonPressed(){
    Navigator.of(context).pop();
  }
  void onRegisterPressed(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen()));
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
            Text(StrRes.SIGNIN, style: H1,),
            SizedBox(height: 100,),
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
              child: AppButton(onPressed: onLoginButtonPressed,text: StrRes.LOGIN),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: onRegisterPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(StrRes.DOES_NOT_HAVE_ACCOUNT, style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: AppColor.GREY3, fontWeight: FontWeight.w600)
                  )),
                  SizedBox(width: 3,),
                  Text(StrRes.REGISTER, style: GoogleFonts.poppins(
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
