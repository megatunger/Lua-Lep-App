import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lualepapp/blocs/app_data_bloc.dart';
import 'package:lualepapp/model/sentence_model.dart';
import 'package:lualepapp/model/word_model.dart';
import 'package:lualepapp/ui/home_screen/sentences_carousel.dart';
import 'package:lualepapp/ui/home_screen/words_carousel.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    appDataBloc.refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _homeWidget();

  }

  Widget _homeWidget() {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset('assets/launcher/LUA_LEP_FOREGROUND.png', height: 80),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "ĐÁNH GIÁ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: CupertinoButton.filled(child: Text("Kiểm tra tổng thể"), onPressed: () {

                }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "LUYỆN TẬP THEO TỪ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: StreamBuilder<List<Word>>(
                    stream: appDataBloc.wordsSubject.stream,
                    builder: (context, AsyncSnapshot<List<Word>> snapshot) {
                      if (snapshot.hasData) {
                        return WordsCarousel(words: snapshot.data);
                      } else if (snapshot.hasError) {
                        return _buildErrorWidget(snapshot.error);
                      } else {
                        return _buildLoadingWidget();
                      }
                    },
                  )
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "LUYỆN TẬP THEO CÂU",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: StreamBuilder<List<Sentence>>(
                    stream: appDataBloc.sentencesSubject.stream,
                    builder: (context, AsyncSnapshot<List<Sentence>> snapshot) {
                      if (snapshot.hasData) {
                        return SentencesCarousel(sentences: snapshot.data);

                      } else if (snapshot.hasError) {
                        return _buildErrorWidget(snapshot.error);
                      } else {
                        return _buildLoadingWidget();
                      }
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            CircularProgressIndicator(),
            SizedBox(height: 8),
          ],
        ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));
  }
}