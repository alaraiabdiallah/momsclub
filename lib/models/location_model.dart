class Province {
  int id;
  String nama;

  Province({this.id, this.nama});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    return data;
  }
}

class City {
  int id;
  String idProv;
  String nama;

  City({this.id, this.idProv, this.nama});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProv = json['id_prov'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_prov'] = this.idProv;
    data['nama'] = this.nama;
    return data;
  }
}