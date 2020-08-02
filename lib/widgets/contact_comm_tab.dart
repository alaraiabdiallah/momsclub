import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:momsclub/utils/infos.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCommunityTab extends StatelessWidget {
  final List<Contact> data;

  const ContactCommunityTab({Key key, this.data}) : super(key: key);


  Widget _buildListContact(Contact data){
    TextStyle _bodyTextStyle = GoogleFonts.openSans(textStyle: TextStyle(fontSize: 18));
    switch(data.source){
      case 'phone':
        return ListTile(
          leading: Icon(Icons.phone),
          title: Text("Phone", style: _bodyTextStyle,),
          subtitle: Text(data.value, style: _bodyTextStyle.copyWith(color: Colors.blue)),
          onTap: () async {
            var url = "tel:${data.value}";
            if (await canLaunch(url)) await launch(url);
          },
        );
        break;
      case 'instagram':
        return ListTile(
          leading: Icon(Icons.link),
          title: Text("Instagram", style: _bodyTextStyle),
          subtitle: Text("@${data.value}", style: _bodyTextStyle.copyWith(color: Colors.blue),),
          onTap: () async {
            var url = "https://instagram.com/${data.value}";
            if (await canLaunch(url)) await launch(url);
          },
        );
        break;
      case 'whatsapp':
        return ListTile(
          leading: Icon(Icons.chat),
          title: Text("WhatsApp", style: _bodyTextStyle),
          subtitle: Text("${data.value}", style: _bodyTextStyle.copyWith(color: Colors.blue),),
          onTap: () async {
            var url = "https://wa.me/${data.value}";
            if (await canLaunch(url)) await launch(url);
          },
        );
        break;
      case 'website':
        return ListTile(
          leading: Icon(Icons.link),
          title: Text("Website", style: _bodyTextStyle),
          subtitle: Text("Tap here to visit", style: _bodyTextStyle.copyWith(color: Colors.blue),),
          onTap: () async {
            var url = data.value;
            if (await canLaunch(url)) await launch(url);
          },
        );
        break;
      case 'facebook':
        return ListTile(
          leading: Icon(Icons.link),
          title: Text("Facebook", style: _bodyTextStyle),
          subtitle: Text("Tap here to visit", style: _bodyTextStyle.copyWith(color: Colors.blue),),
          onTap: () async {
            var url = data.value;
            if (await canLaunch(url)) await launch(url);
          },
        );
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Contact", style: H2.copyWith(color: AppColor.PRIMARY),),
          ...data.where((e) => e.value.isNotEmpty).map(_buildListContact).toList()
        ],
      ),
    );
  }
}
