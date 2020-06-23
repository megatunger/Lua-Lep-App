import 'package:firebase_database/firebase_database.dart';
import 'package:lualepapp/utils/sharedPref.dart';
import 'package:rxdart/rxdart.dart';

class UserDataBloc {
  var dbRef = FirebaseDatabase.instance.reference().child("users");
  final BehaviorSubject<double> _l_percentageSubject = BehaviorSubject<double>();
  final BehaviorSubject<double> _n_percentageSubject = BehaviorSubject<double>();

  init() async {
    print("Init recording user data: ${await sharedPref.read('uuid')}");
    dbRef = FirebaseDatabase.instance.reference().child("users").child(await sharedPref.read('uuid'));
  }

  clearData() async {
    _l_percentageSubject.add(null);
    _n_percentageSubject.add(null);
  }

  refreshData() async {
    countPercentage(character: 'l');
    countPercentage(character: 'n');
  }

  writeData({String character, String word, bool correct}) async {
    dbRef.child(character).push().set({
      "word": word,
      "correct": correct,
      "timestamp": ServerValue.timestamp
    });
  }

  countPercentage({String character}) async {
    dbRef.child(character).once().then((snapshot) {
      final dataJson = snapshot.value.toString();
      final falseNumbers = countOccurences(snapshot.value.toString(), "false");
      final trueNumbers = countOccurences(snapshot.value.toString(), "true");
      print("Counting percentage of character $character");
      print("FALSE: ${falseNumbers}");
      print("TRUE: ${trueNumbers}");
      double result = falseNumbers*1.0/(trueNumbers+falseNumbers);
      if (falseNumbers==0 && trueNumbers==0) {
        result = 0.0;
      }
      switch (character) {
        case 'l':
          _l_percentageSubject.sink.add(result);

          break;
        case 'n':
          _n_percentageSubject.sink.add(result);
          break;
      }
    });
  }

  int countOccurences(mainString, search) {
    int lInx = 0;
    int count =0;
    while(lInx != -1){
      lInx = mainString.indexOf(search,lInx);
      if( lInx != -1){
        count++;
        lInx+=search.length;
      }
    }
    return count;
  }

  dispose() {
    _l_percentageSubject.close();
    _n_percentageSubject.close();
  }


  BehaviorSubject<double> get l_percentageSubject => _l_percentageSubject;
  BehaviorSubject<double> get n_percentageSubject => _n_percentageSubject;

}

final userDataBloc = UserDataBloc();