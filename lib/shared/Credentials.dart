import '../model/Filter.dart';
import '../model/User.dart';

class Credentials {
  static final Credentials _singleton = Credentials._internal();

  String? userId;
  String? username;
  String? planType;
  Filter? filter;

  factory Credentials() {
    return _singleton;
  }

  Credentials._internal();
}