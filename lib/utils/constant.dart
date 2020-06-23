import 'package:firebase_database/firebase_database.dart';

class Constant {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  final baseAPI = "http://172.16.8.96:5000/api";

}

final constant = Constant();

