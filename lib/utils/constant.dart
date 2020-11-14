import 'package:firebase_database/firebase_database.dart';

class Constant {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  final baseAPI = "https://lualepapi.megatunger.com/api";
//  final baseAPI = "http://127.0.0.1:5000/api";

}

final constant = Constant();
