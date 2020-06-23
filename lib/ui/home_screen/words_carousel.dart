import 'package:flutter/material.dart';
import 'package:lualepapp/blocs/user_data_bloc.dart';
import 'package:lualepapp/model/word_model.dart';
import 'package:lualepapp/ui/words/word_widget.dart';
import 'package:random_color/random_color.dart';

import '../theme.dart';

class WordsCarousel extends StatefulWidget {
  WordsCarousel({Key key, this.words}) : super(key: key);
  List<Word> words;
  @override
  _WordsCarouselState createState() => _WordsCarouselState();
}

class _WordsCarouselState extends State<WordsCarousel> {
  RandomColor _randomColor = RandomColor();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: this.widget.words == null ? 0 : this.widget.words.length,
        itemBuilder: (BuildContext context, int index) {
          Word place = this.widget.words[index];
          Color _color = _randomColor.randomColor(
              colorBrightness: ColorBrightness.dark
          );
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              child: Container(
                height: 200,
                width: 150,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: "${place.word}",
                        child: SizedBox(
                          width: 150.0,
                          height: 220.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: _color,
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                       _color, _color.withAlpha(50)
                                    ]),
                            ),
                            child: Center(
                                child: Text(place.word,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: LLTheme.backgroundColor
                                    ),
                                    textAlign: TextAlign.center
                                )
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return WordWidget(data: place, mainColor: _color);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}