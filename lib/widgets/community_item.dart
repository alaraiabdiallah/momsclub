import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/styles/text_styles.dart';

class CommunityItem extends StatelessWidget {

  final String name;
  final String location;
  final String imageURL;
  final Function onTap;

  const CommunityItem({Key key, this.name, this.location, this.onTap, this.imageURL = "https://picsum.photos/200/300"}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle _name_text_style = GoogleFonts.roboto(textStyle: H4.copyWith(color: Colors.white)) ;
    TextStyle _loc_text_style = GoogleFonts.montserrat(textStyle: ThinText.copyWith(color: Colors.white));

    BorderRadius _br = BorderRadius.circular(10);

    
    BoxDecoration _decor = BoxDecoration(
      borderRadius: _br,
      image: DecorationImage(image: NetworkImage(imageURL), fit: BoxFit.fill)
    );
    double _box_height = double.infinity;

    BoxDecoration _overlay_decor = BoxDecoration(
        borderRadius: _br,
        color: Colors.black.withOpacity(0.2),
    );

    return Material(
      borderRadius: _br,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: _box_height,
          decoration: _decor,
          child: Container(
            decoration: _overlay_decor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(name, style: _name_text_style, textAlign: TextAlign.center,),
                Text(location, style: _loc_text_style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
