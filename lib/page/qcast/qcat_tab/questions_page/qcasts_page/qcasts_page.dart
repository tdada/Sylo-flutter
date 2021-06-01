import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/qcast_dashboard_item.dart';
import 'package:testsylo/model/qcasts_selectable_item.dart';
import 'package:testsylo/model/question_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/qcasts_page/qcasts_page_view_model.dart';
import 'package:testsylo/page/qcast/qcat_tab/questions_page/que_ans_record/que_ans_record_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../../app.dart';
import 'qcasts_video_record_page/qcasts_video_record_page.dart';

class QcastsPage extends StatefulWidget {
  String from = "";

  QcastsPage(this.from);

  @override
  QcastsPageState createState() => QcastsPageState();
}

class QcastsPageState extends State<QcastsPage> {
  QcastsPageViewModel model;
  List<String> qcastsQuestionsList  = List<String>();
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    model = QcastsPageViewModel(this);
  }

  get qcastsQueBanner => qcastsQuestionsList.length >0 ? Padding(
    padding: const EdgeInsets.only(bottom:5),
    child: Column(
      children: List<Widget>.generate(qcastsQuestionsList.length, (i) =>
          AutoSizeText(
            qcastsQuestionsList[i],
            style: getTextStyle(
              size: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ))
    ),
  ):Container(padding: const EdgeInsets.only(bottom:5),);

  get recipientQcastsView => Container(
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: model.recipientQcastsList?.length??0,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.8 / 1.25),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        DiscoverQcastItem recipientQcast = model.recipientQcastsList[i];
        return InkWell(
          child: Container(
              padding: EdgeInsets.only(left: 5, top: 5),
              child: Column(
                children: <Widget>[
                  ClipOval(
                    child:
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              child: ClipOval(
                                child: Container(
                                  child: ImageFromNetworkView(
                                    path: recipientQcast.coverPhoto,
                                    boxFit: BoxFit.cover,
                                  ),
                                  width: 75,
                                  height: 75,
                                ),
                              ),
                              padding: EdgeInsets.all(3),
                              color: colorOvalBorder,
                            ),
                            model.recipientQcastSelectIndex == i
                                ? ClipOval(
                              child: Container(
                                width: 75,
                                height: 75,
                                color: Color.fromRGBO(106, 13, 173, 0.2),
                                child: Icon(Icons.check,size:30,color: Colors.white,),
                              ),
                            )
                                : Container(width:0)
                          ],
                        ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  AutoSizeText(
                    recipientQcast.description.toString(),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      size: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    child: Text(
                      recipientQcast.name.toString()??"",
                      style: getTextStyle(
                          color: colorDark,
                          size: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    padding: EdgeInsets.only(top: 3),
                  )
                ],
              ),
          ),
          onTap: () {
            model.recipientQcastSelectIndex = i;
            model.downloadedQcastSelectIndex = -1;
            setState(() {
            });
          },
        );
      },
    ),
  );

  get qcastGridView => Container(
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.downloadedQcastsList?.length??0,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.8 / 1.25),
          shrinkWrap: true,
          itemBuilder: (c, i) {
            DiscoverQcastItem downloadedQcast = model.downloadedQcastsList[i];
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 5, top: 5),
                child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            child: ClipOval(
                              child: Container(
                                child: ImageFromNetworkView(
                                  path: downloadedQcast.coverPhoto,
                                  boxFit: BoxFit.cover,
                                ),
                                width: 75,
                                height: 75,
                              ),
                            ),
                            padding: EdgeInsets.all(3),
                            color: colorOvalBorder,
                          ),
                          model.downloadedQcastSelectIndex == i
                              ? ClipOval(
                                child: Container(
                                  width: 75,
                                    height: 75,
                                    color: Color.fromRGBO(106, 13, 173, 0.2),
                                    child: Icon(Icons.check,size:30,color: Colors.white,),
                                  ),
                              )
                              : Container(width:0)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    AutoSizeText(
                      downloadedQcast.description??"",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        size: 14,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      child: Text(
                        downloadedQcast.name??"",
                        style: getTextStyle(
                            color: colorDark,
                            size: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      padding: EdgeInsets.only(top: 3),
                    )
                  ],
                ),
              ),
              onTap: () {
                model.downloadedQcastSelectIndex = i;
                model.recipientQcastSelectIndex = -1;
                setState(() {
                });
              },
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());

    return Scaffold(
        backgroundColor: getColorBg(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                qcastsQueBanner,
                SizedBox(
                  height: 8,
                ),
                model.recipientQcastsList.length!=0?
                Column(
                  children: [
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("Recipient's Qcasts",style: getTextStyle(size: 18))),
                    Divider(height: 14,),
                    recipientQcastsView,
                  ],
                )
                    :SizedBox(),
                Align(
                  alignment: Alignment.bottomLeft,
                    child: Text("Downloaded Qcasts",style: getTextStyle(size: 18))),
                Divider(height: 14,),
                qcastGridView,
                model.downloadedQcastSelectIndex >=0 || model.recipientQcastSelectIndex >=0 ?commonButtonWithFilledSingleColorCorner(
                    () async {
                      if(model.downloadedQcastSelectIndex >=0) {
                        await model.getQcast(model.downloadedQcastsList[model
                            .downloadedQcastSelectIndex].qcasId);
                      } else {
                        await model.getQcast(model.recipientQcastsList[model
                            .recipientQcastSelectIndex].qcasId);
                      }
                      //goToQueAnsPage(context, runtimeType.toString(), "");
                      List<QuestionItem> listQuestions = List();

                      model.selectedQcastItem.listOfVideo.forEach((element) {
                        listQuestions.add(QuestionItem(
                            que_link: element,
                            que_thumb: model.selectedQcastItem.coverPhoto
                        ));
                      });
                      appState.selectedDownloadedQcast =
                          model.selectedQcastItem;
                      isQuickPost = true;

                      goToQueAnsPage(
                          context, runtimeType.toString(), listQuestions);

                      //Navigator.push(context, NavigatePageRoute(context, QueAnsRecordPage(runtimeType.toString())));

                    /*  Navigator.push(
                          context, NavigatePageRoute(context, QcastsVideoRecordPage()));*/
      /*                qcastsQuestionsList.clear();
                      setState(() {
                        qcastsQuestionsList = model.getQueList();
                        model.allUnSelect();
                        _selectionMode = false;
                      });*/
                    },
                    Text(
                      "Load Qcast",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                    colorDark):Container(),

                commonEndView(),

              ],
            ),
          ),
        ));
  }
}
