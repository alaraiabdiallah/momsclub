import 'package:momsclub/utils/str_res.dart';

class UserVerifyException implements Exception {
  String message = StrRes.USER_UNVERIFIED;
  UserVerifyException({this.message});
}
