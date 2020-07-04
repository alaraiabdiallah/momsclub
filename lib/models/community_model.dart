class Community {
  String name;
  String location;
  String imageURL;
  String desc;
  List<Contact> contacts;

  Community(
      {this.name, this.location, this.imageURL, this.desc, this.contacts});

  Community.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'];
    imageURL = json['imageURL'];
    desc = json['desc'];
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
    data['name'] = this.name;
    data['location'] = this.location;
    data['imageURL'] = this.imageURL;
    data['desc'] = this.desc;
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