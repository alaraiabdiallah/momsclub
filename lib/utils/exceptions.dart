class EmailAlreadyRegisteredException implements Exception{
  String message;
  EmailAlreadyRegisteredException(this.message);
}