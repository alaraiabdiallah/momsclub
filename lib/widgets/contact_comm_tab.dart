import 'package:flutter/material.dart';
import 'package:momsclub/models/community_model.dart';
import 'package:momsclub/styles/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCommunityTab extends StatelessWidget {
  final List<Contact> data;

  const ContactCommunityTab({Key key, this.data}) : super(key: key);


  Widget _buildListContact(Contact data){
    switch(data.source){
      case 'phone':
        return ListTile(
          leading: Icon(Icons.phone),
          title: Text("Phone"),
          subtitle: Text(data.value, style: TextStyle(color: Colors.blue),),
          onTap: () async {
            var url = "tel:${data.value}";
            if (await canLaunch(url)) await launch(url);
          },
        );
        break;
      case 'instagram':
        return ListTile(
          leading: Icon(Icons.link),
          title: Text("Instagram"),
          subtitle: Text("@${data.value}", style: TextStyle(color: Colors.blue),),
          onTap: () async {
            var url = "https://instagram.com/${data.value}";
            if (await canLaunch(url)) await launch(url);
          },
        );
        break;
      case 'whatsapp':
        return ListTile(
          leading: Icon(Icons.chat),
          title: Text("WhatsApp"),
          subtitle: Text("${data.value}", style: TextStyle(color: Colors.blue),),
          onTap: () async {
            var url = "https://wa.me/${data.value}";
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
          Text("Contact", style: H2.copyWith(color: Colors.black),),
          ...data.map(_buildListContact).toList()
        ],
      ),
    );
  }
}
