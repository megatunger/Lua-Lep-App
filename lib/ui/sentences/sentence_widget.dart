import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lualepapp/blocs/sentence_check_bloc.dart';
import 'package:lualepapp/model/sentence_check.dart';
import 'package:lualepapp/model/sentence_model.dart';
import 'package:lualepapp/ui/recorder/sentence_recorder_widget.dart';
import 'package:lualepapp/blocs/user_data_bloc.dart';
import '../theme.dart';

class SentenceWidget extends StatefulWidget {
  Sentence data;
  SentenceWidget({Key key, this.data}) : super(key: key);

  @override
  _SentenceWidgetState createState() => _SentenceWidgetState();
}

class _SentenceWidgetState extends State<SentenceWidget> with TickerProviderStateMixin {
  ConfettiController _controllerTopCenter;
  double _height = 370.0;
  @override
  void initState() {
    print(this.widget.data.sentence);
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
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        this.widget.data.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.grey[200]
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Bấm nút ghi âm và đọc câu bên dưới',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.grey[400]
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: _height,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: this.widget.data.img,
                        child: CachedNetworkImage(
                          imageUrl: this.widget.data.img,
                          width: MediaQuery.of(context).size.width-40,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      )
                  ),
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<SentenceCheck>(
                stream: sentenceCheckBloc.sentenceCheckSubject.stream,
                builder: (context, AsyncSnapshot<SentenceCheck> snapshot) {
                  if (snapshot.hasData) {
                    for(Words word in snapshot.data.words) {
                      userDataBloc.writeData(character: word.word.toLowerCase()[0], word: word.word, correct: word.passed);
                    }
                    var text = new RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          for(Words word in snapshot.data.words)
                            TextSpan(
                                text: word.word + ' ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                    color: (word.passed==true) ? Colors.green : Colors.redAccent
                                ))
                        ],
                      ),
                    );
                    if (snapshot.data.passed==true) {
                      _controllerTopCenter.play();
                    }
                    return Center(
                        child: Column(
                          children: [
                            Text(
                              snapshot.data.message,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: LLTheme.backgroundColor.withOpacity(0.8)
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8,),
                            Text(
                              "${snapshot.data.accuracy}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                  color: LLTheme.backgroundColor
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16,),
                            text
                          ],
                        )
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
        child: new SentenceRecorderWidget(sentence: this.widget.data.sentence)
      ),
    );
  }



  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            CupertinoActivityIndicator(animating: true, radius: 24,),
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