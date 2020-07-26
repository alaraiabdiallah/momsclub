import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momsclub/screens/login_screen.dart';
import 'package:momsclub/screens/community_form_screen.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/buttons.dart';

class MyCommunityFragment extends StatefulWidget {
  @override
  _MyCommunityFragmentState createState() => _MyCommunityFragmentState();
}

class _MyCommunityFragmentState extends State<MyCommunityFragment> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLogin = false;

  onLoggedIn(FirebaseUser user) async {
    await _checkAuth();
  }

  void _onLoginButtonPressed() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(
              onLoggedIn: onLoggedIn,
            )));
  }

  void _onLogoutButtonPressed() async {
    await _auth.signOut();
    setState(() => _isLogin = false);
  }

  void _onRegisterCommButtonPressed() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CommunityFormScreen()));
  }

  void _checkAuth() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null)
      setState(() => _isLogin = true);
    else
      setState(() => _isLogin = false);
  }

  @override
  void initState() {
    _checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: screenBodyPadding,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: screenTextMarginTop(context),
              bottom: screenTextMarginBotttom),
          child: Text(
            StrRes.MY_COM,
            style: H1,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * (4 / 7),
          child: _isLogin ? buildAuthView() : buildUnauthView(),
        )
      ],
    );
  }

  Widget buildUnauthView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            StrRes.NEED_LOGIN_FOR_COMM_MANAGEMENT,
            style: H3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            child:
                AppButton(onPressed: _onLoginButtonPressed, text: StrRes.LOGIN),
          )
        ],
      ),
    );
  }

  Widget buildAuthView() {
    return Column(
      children: <Widget>[
        Text(StrRes.NOT_HAVE_COMM, style: H3),
        SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          child: AppButton(
              onPressed: _onRegisterCommButtonPressed,
              text: StrRes.REGISTER_MY_COMMUNITY),
        ),
        Expanded(
          child: Container(),
        ),
        Container(
          width: double.infinity,
          child:
              AppButton(onPressed: _onLogoutButtonPressed, text: StrRes.LOGOUT),
        )
      ],
    );
  }
}
