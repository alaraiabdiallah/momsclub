import 'package:flutter/material.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';

class AppButton extends StatelessWidget {

  final String text;
  final Function onPressed;

  const AppButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Text(text, style: H5.copyWith(color: Colors.white),),
      color: AppColor.PRIMARY,
      onPressed: onPressed,
    );
  }
}
