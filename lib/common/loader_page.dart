import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import '../app.dart';

class LoaderPage extends StatefulWidget {
  String label = "";

  LoaderPage({this.label});

  @override
  AddPromptPageState createState() => AddPromptPageState();
}

class AddPromptPageState extends State<LoaderPage> {
  TextEditingController nameAlbumController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }

  Widget appBar() {
    return Container(
      height: 45,
      child: Material(
        color: getMatColorBg(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              width: 32,
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: CircularProgressIndicator(),
                      ),
                      widget.label == null
                          ? Container(
                              width: 0,
                            )
                          : Container(
                              child: Text(
                                widget.label,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              padding: EdgeInsets.only(top: 8),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
