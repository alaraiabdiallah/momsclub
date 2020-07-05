class UserModel {
  final String name;
  final String email;
  final String user_id;
  final bool is_verify;

  UserModel({this.name, this.email, this.user_id, this.is_verify});

  toMap() => {'name': this.name, 'email': this.email, 'user_id': this.user_id, 'is_verify': this.is_verify};

}