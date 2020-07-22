import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/screens/register_screen.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/exceptions.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/buttons.dart';
import 'package:momsclub/widgets/inputs.dart';

class LoginScreen extends StatefulWidget {
  final Function onLoggedIn;

  const LoginScreen({Key key, this.onLoggedIn}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextCtrl = TextEditingController();
  final _passwordTextCtrl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _onLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _setLoading(bool b) => setState(() => _onLoading = b);

  void _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void onLoginButtonPressed() async {
    FirebaseUser user;
    try {
      _setLoading(true);
      var result = await _auth.signInWithEmailAndPassword(
          email: _emailTextCtrl.text, password: _passwordTextCtrl.text);
      user = result.user;
      if (!user.isEmailVerified) throw UserVerifyException();
      _setLoading(true);
      await widget.onLoggedIn(user);
      Navigator.of(context).pop();
    } on UserVerifyException catch (e) {
      _showSnackBar(StrRes.USER_UNVERIFIED);
      _setLoading(false);
      user.sendEmailVerification();
      print("Something error ${e.message.toString()}");
    } catch (e) {
      _showSnackBar(StrRes.LOGIN_FAILED);
      _setLoading(false);
      print("Something error ${e.toString()}");
    }
  }

  void onRegisterPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterScreen()));
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
            Text(
              StrRes.SIGNIN,
              style: H1,
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: _formWidgetWidth,
              child: AppFormInput(
                controller: _emailTextCtrl,
                placeholder: StrRes.EMAIL,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: _formWidgetWidth,
              child: AppFormInput(
                obscure: true,
                controller: _passwordTextCtrl,
                placeholder: StrRes.PASSWORD,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: _formWidgetWidth,
              child: AppButton(
                  onPressed: _onLoading ? null : onLoginButtonPressed,
                  text: _onLoading ? StrRes.LOADING : StrRes.LOGIN),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: onRegisterPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(StrRes.DOES_NOT_HAVE_ACCOUNT,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: AppColor.GREY3,
                              fontWeight: FontWeight.w600))),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    StrRes.REGISTER,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: AppColor.PRIMARY,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
