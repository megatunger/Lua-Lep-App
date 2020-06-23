import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lualepapp/blocs/word_check_bloc.dart';
import 'package:lualepapp/model/word_check.dart';
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
  ConfettiController _controllerTopCenter;

  @override
  void initState() {
    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }
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
      body: Align(
        alignment: Alignment.center,
        child: ConfettiWidget(
            confettiController: _controllerTopCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                false, // start again as soon as the animation is finished
            numberOfParticles: 50,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            child: ListView(
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
                  SizedBox(height: 32,),
                  StreamBuilder<WordCheck>(
                    stream: wordCheckBloc.wordCheckSubject.stream,
                    builder: (context, AsyncSnapshot<WordCheck> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.passed==true) {
                            _controllerTopCenter.play();
                        }
                        return Center(
                            child: Text(
                              snapshot.data.message,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: LLTheme.backgroundColor
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          );
                      } else if (snapshot.hasError) {
                        return _buildErrorWidget(snapshot.error);
                      } else {
                        return _buildLoadingWidget();
                      }
                    },
                  )
                ],
              ),
          ),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 48, left: 20, right: 20),
          child: new RecorderWidget(wordData: this.widget.data)
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