import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../app.dart';
import 'completed_sylo_letter_page_view_model.dart';

class CompletedSyloLetterPage extends StatefulWidget {
  @override
  CompletedSyloLetterPageState createState() => CompletedSyloLetterPageState();
}

class CompletedSyloLetterPageState extends State<CompletedSyloLetterPage> {
  CompletedSyloLetterPageViewModel model;

  get topTextView => Container(
    padding: EdgeInsets.only(bottom: 8),
    child: Column(
      children: <Widget>[
        Text(
          "Tim I'm so proud of you",
          style: getTextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            size: 18,
          ),
        ),
        SizedBox(height: 4,),
        Text(
          App.getDateByFormat(DateTime.now(), App.formatMMMDDYY),
          style: getTextStyle(
            color: Colors.black,
            size: 13,
          ),
        ),
        SizedBox(height: 4,),
        tagDisplayView,
      ],
    ),
  );

  get tagDisplayView => Container(
      alignment: Alignment.center,
//      padding: EdgeInsets.only(left: 40),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: model.tagList.length,
        shrinkWrap: true,
        itemBuilder: (c, i) {
          return Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            height: 30,
            child: FlatButton(
                onPressed: () {},
                child: Text(model.tagList[i].name),
                color: colorOvalBorder,
                disabledColor: colorOvalBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
          );
        },
      ));

  get detailTextView => Container(
    padding: EdgeInsets.only(left: 16, right: 16, top: 20),
    child: AutoSizeText(
      App.lorem2,
      style: getTextStyle(
          size: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400),
      textAlign: TextAlign.left,
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = CompletedSyloLetterPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "View Letter",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                  App.ic_back,
                  fit: BoxFit.contain,
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  topTextView,
                  detailTextView,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
