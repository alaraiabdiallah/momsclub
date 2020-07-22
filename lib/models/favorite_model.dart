class FavoriteModel{
  String id;
  FavoriteModel({this.id});
  Map<String, dynamic> toMap() => {
      'id': id,
  };

  FavoriteModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
  }
}