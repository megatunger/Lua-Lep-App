import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lualepapp/model/sentence_model.dart';
import 'package:lualepapp/ui/sentences/sentence_widget.dart';
class SentencesCarousel extends StatefulWidget {
  SentencesCarousel({Key key, this.sentences}) : super(key: key);
  List<Sentence> sentences;
  @override
  _SentencesCarouselState createState() => _SentencesCarouselState();
}

class _SentencesCarouselState extends State<SentencesCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 260,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: this.widget.sentences == null ? 0 : this.widget.sentences.length,
        itemBuilder: (BuildContext context, int index) {
          Sentence place = this.widget.sentences[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              child: Container(
                height: 260,
                width: 150,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: "${place.img}",
                        child: CachedNetworkImage(
                          imageUrl:place.img,
                          height: 178,
                          width: 140,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${place.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${place.sentence}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[300],
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SentenceWidget(data: place);
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