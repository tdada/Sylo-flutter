import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/model/api_response.dart';

import '../../../../app.dart';
import 'shared_view_letter_page_view_model.dart';

class SharedViewLetterPage extends StatefulWidget {
  String from;
  AlbumMediaData albumMediaData;
  SyloQuestionItem syloQuestionItem;
  SharedViewLetterPage({this.from, this.albumMediaData, this.syloQuestionItem});
  @override
  SharedViewLetterPageState createState() => SharedViewLetterPageState();
}

class SharedViewLetterPageState extends State<SharedViewLetterPage> {
  SharedViewLetterPageViewModel model;

  get topTextView => Container(
        padding: EdgeInsets.only(bottom: 8),
        child: Column(
          children: <Widget>[
            Text(
              model.subAlbumData.title ?? "",
              style: getTextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                size: 18,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              model.subAlbumData.postedDate ?? "",
//              App.getDateByFormat(DateTime.now(), App.formatMMMDDYY),
              style: getTextStyle(
                color: Colors.black,
                size: 13,
              ),
            ),
          ],
        ),
      );

  get detailTextView => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: AutoSizeText(
          model.subAlbumData.textMsg ?? "",
          style: getTextStyle(
              size: 14, color: Colors.black, fontWeight: FontWeight.w400),
          textAlign: TextAlign.left,
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
                child: Text(model.tagList[i]),
                color: colorOvalBorder,
                disabledColor: colorOvalBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
          );
        },
      ));

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = SharedViewLetterPageViewModel(this));

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
        actions: <Widget>[
          widget.from == "SyloAlbumDetailPageState"
              ? InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 12, top: 12),
                        child: Image.asset(
                          App.ic_delete_drafts,
                          height: 20,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    commonCupertinoDialogPage(
                        context,
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 12,
                            ),
                            new Image.asset(
                              App.ic_alert_new,
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Are you sure you want to delete \nthis Posted media?",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  size: 18,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 34,
                            ),
                          ],
                        ), positiveAction: () {
                      model.callDeleteSubAlbum();
                    });
                  },
                )
              : SizedBox()
        ],
      ),
      floatingActionButton:
//      widget.from!=null && widget.from != "ActiveSyloSharedOwnPageState" ?
          false
              ? Container(
                  color: Colors.transparent,
                  height: 60,
                  alignment: Alignment.center,
                  child: FlatButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.mode_edit,
                        size: 18,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text("Edit Letter",
                            style: getTextStyle(
                                size: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ),
                      color: colorOvalBorder,
                      disabledColor: colorOvalBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                  margin: EdgeInsets.only(left: 32),
                )
              : Container(height: 0),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  topTextView,
                  widget.from != null &&
                          widget.from != "ActiveSyloSharedOwnPageState"
                      ? tagDisplayView
                      : SizedBox(),
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
