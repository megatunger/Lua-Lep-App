import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:lualepapp/ui/home_screen/home_screen.dart';
import 'package:lualepapp/utils/sharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  bool installed = true;
  final pages = [
    PageModel(
        color: Colors.black,
        imageAssetPath: 'assets/illustrations/flame-no-comments.png',
        title: 'Mọi lý lẽ đều trở nên thiếu thuyết phục khi bạn nói ngọng',
        body: '\"Sau lày chỉ có làm, chịu khó cần cù thì bù siêng năng\"',
        doAnimateImage: true),
    PageModel(
        color: Colors.black,
        imageAssetPath: 'assets/launcher/LUA_LEP_FOREGROUND.png',
        title: 'Lúa \'Lếp\'',
        body: 'Ứng Dụng Hỗ Trợ Chữa Nói Ngọng',
        doAnimateImage: true),
  ];

  @override
  void initState() {
    super.initState();
    sharedPref.isContain('installed').then((data) {
      print("IS INSTALLED BEFORE: $data");
      if (data==false) {
        setState(() {
          installed = false;
        });
      } else {
        _signInAnonymously();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (installed==false) {
      return Scaffold(
        key: _globalKey,
        body: OverBoard(
          pages: pages,
          showBullets: true,
          skipCallback: () {
            _signInAnonymously().then((_) {
              sharedPref.save('installed', true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            });
          },
          finishCallback: () {
            _signInAnonymously().then((_) {
              sharedPref.save('installed', true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            });
          },
        ),
      );
    } else {
      return HomeScreen();
    }
  }

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      final user = await FirebaseAuth.instance.currentUser();
      sharedPref.save('uuid', user.uid);
      print("Logged in this user: ${user.uid}");
    } catch (e) {
      print(e);
    }
  }

}