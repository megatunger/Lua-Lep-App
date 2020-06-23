import 'package:flutter/material.dart';
import 'package:lualepapp/blocs/user_data_bloc.dart';

import '../theme.dart';

class RatingWidget extends StatefulWidget {
  RatingWidget({Key key}) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _color1 = Colors.deepOrange;
    final _color2 = Colors.deepPurple;
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width/2 - 20,
              height: 120.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _color1
                ),
                child: StreamBuilder<double>(
                  stream: userDataBloc.l_percentageSubject.stream,
                  builder: (context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("NGỌNG L",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: LLTheme.backgroundColor.withOpacity(0.7)
                                  ),
                                  textAlign: TextAlign.center
                              ),
                              SizedBox(height: 8,),
                              Text("${snapshot.data*100.toInt()}%",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: LLTheme.backgroundColor
                                  ),
                                  textAlign: TextAlign.center
                              ),
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
              ),
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width/2 - 20,
              height: 120.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _color2
                ),
                child:  StreamBuilder<double>(
                  stream: userDataBloc.n_percentageSubject.stream,
                  builder: (context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("NGỌNG N",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: LLTheme.backgroundColor.withOpacity(0.7)
                                  ),
                                  textAlign: TextAlign.center
                              ),
                              SizedBox(height: 8,),
                              Text("${snapshot.data*100.toInt()}%",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: LLTheme.backgroundColor
                                  ),
                                  textAlign: TextAlign.center
                              ),
                            ],
                          )
                      );
                    } else if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error);
                    } else {
                      return _buildLoadingWidget();
                    }
                  },
                ),
              ),
            ),
          )

        ],
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

  refreshData() async {
    await userDataBloc.init();
    userDataBloc.countPercentage(character: 'l');
    userDataBloc.countPercentage(character: 'n');
  }
}