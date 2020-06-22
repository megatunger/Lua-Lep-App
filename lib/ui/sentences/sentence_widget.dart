import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lualepapp/model/sentence_model.dart';
import 'package:lualepapp/ui/recorder/recorder_widget.dart';

import '../theme.dart';

class SentenceWidget extends StatefulWidget {
  Sentence data;
  SentenceWidget({Key key, this.data}) : super(key: key);

  @override
  _SentenceWidgetState createState() => _SentenceWidgetState();
}

class _SentenceWidgetState extends State<SentenceWidget> {

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
          Padding(
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
          SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 48, left: 20, right: 20),
        child: new RecorderWidget()
      ),
    );
  }
}