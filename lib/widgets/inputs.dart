import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/utils/infos.dart';

class AppFormInput extends StatelessWidget {

  final TextEditingController controller;
  final String placeholder;
  final bool obscure;

  const AppFormInput({Key key, this.controller, this.placeholder = "", this.obscure = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)
    );
    return CupertinoTextField(
      padding: EdgeInsets.symmetric(vertical: 15),
      controller: controller,
      placeholder: placeholder,
      placeholderStyle: style,
      obscureText: obscure,
      textAlign: TextAlign.center,
      style: style.copyWith(color: Colors.black),
      decoration: BoxDecoration(
        color: AppColor.GREY2,
        borderRadius: BorderRadius.circular(25)
      ),
    );
  }
}
