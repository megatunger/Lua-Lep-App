import 'package:firebase_database/firebase_database.dart';

class Constant {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  final baseAPI = "https://lua-lep-api.herokuapp.com/api";
//  final baseAPI = "http://127.0.0.1/api";

}

final constant = Constant();

