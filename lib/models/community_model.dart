class Community {
  String id;
  String name;
  String location;
  String imageURL;
  String desc;
  bool active;
  List<Contact> contacts;

  Community({this.id, this.name, this.location, this.imageURL, this.desc, this.contacts, this.active});

  Community.fromJson(Map<String, dynamic> json) {
    var defaultImage = "https://firebasestorage.googleapis.com/v0/b/momsclub-8d5c2.appspot.com/o/Moms_Club.png?alt=media&token=3c42207c-adc0-4491-bc08-0bc130b798ea";
    id = json['id'];
    name = json['name'];
    location = json['location'];
    imageURL = defaultImage;
    if(json['imageURL'] != null && json['imageURL'] != ''){
      imageURL = json['imageURL'];
    }
    desc = json['desc'];
    active = json['active'];
    if (json['contacts'] != null) {
      contacts = new List<Contact>();
      json['contacts'].forEach((v) {
          var rest = new Map<String, dynamic>();
          rest["source"] = v["source"];
          rest["value"] = v["value"];
          contacts.add(new Contact.fromJson(rest));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['imageURL'] = this.imageURL;
    data['desc'] = this.desc;
    data['active'] = this.active;
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contact {
  String source;
  String value;

  Contact({this.source, this.value});

  Contact.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    data['value'] = this.value;
    return data;
  }
}