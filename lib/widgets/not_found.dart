import 'package:flutter/material.dart';

class NotFoundDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (4/7),
      child: Center(
        child: Image.asset("assets/images/notfound.png"),
      ),
    );
  }
}
