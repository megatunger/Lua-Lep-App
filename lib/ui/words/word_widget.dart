import 'package:flutter/material.dart';
import 'package:lualepapp/model/word_model.dart';
import 'package:lualepapp/ui/recorder/recorder_widget.dart';
import '../theme.dart';

class WordWidget extends StatefulWidget {
  WordWidget({Key key, this.data, this.mainColor}) : super(key: key);
  Word data;
  Color mainColor;
  @override
  _WordWidgetState createState() => _WordWidgetState();
}

class _WordWidgetState extends State<WordWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LLTheme.darkGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body:  ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Bấm nút ghi âm và phát âm từ bên dưới',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: LLTheme.backgroundColor
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: "${this.widget.data.word}",
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width-40,
                    height: 300.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: this.widget.mainColor
                      ),
                      child: Center(
                          child: Text(this.widget.data.word,
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: LLTheme.backgroundColor
                              ),
                              textAlign: TextAlign.center
                          )
                      ),
                    ),
                  ),
                ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 48, left: 20, right: 20),
          child: new RecorderWidget()
      ),
    );
  }
}