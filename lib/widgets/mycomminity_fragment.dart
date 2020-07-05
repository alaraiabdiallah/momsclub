
import 'package:flutter/material.dart';
import 'package:momsclub/screens/login_screen.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:momsclub/utils/str_res.dart';
import 'package:momsclub/widgets/buttons.dart';

class MyCommunityFragment extends StatefulWidget {
  @override
  _MyCommunityFragmentState createState() => _MyCommunityFragmentState();
}

class _MyCommunityFragmentState extends State<MyCommunityFragment> {

  void onLoginButtonPressed(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: screenBodyPadding,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenTextMarginTop(context), bottom: screenTextMarginBotttom),
          child: Text(StrRes.MY_COM, style: H1,),
        ),
        Container(
          height: MediaQuery.of(context).size.height * (4/7),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(StrRes.NEED_LOGIN_FOR_COMM_MANAGEMENT, style: H3, textAlign: TextAlign.center,),
                SizedBox(height: 15,),
                Container(
                  width: double.infinity,
                  child: AppButton(onPressed: onLoginButtonPressed,text: StrRes.LOGIN),
                )
              ],
            ),
          ),
        )
        
      ],
    );
  }
}
