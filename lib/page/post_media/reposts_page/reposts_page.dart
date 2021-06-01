import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/post_media/reposts_page/reposts_page_view_model.dart';
import 'package:testsylo/util/util.dart';

import '../../../app.dart';

class RepostsPage extends StatefulWidget {
  @override
  RepostsPageState createState() => RepostsPageState();
}

class RepostsPageState extends State<RepostsPage> with WidgetsBindingObserver {
  RepostsPageViewModel model;

  @override
  void initState() {
    super.initState();
    model =  RepostsPageViewModel(this);
    model.initRepostModel();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  get topTextView => Container(
    padding: EdgeInsets.only(left: 16, right: 16, top: 26, bottom: 26),
    child: Column(
      children: <Widget>[
        Text(
          "Repost social media posts to your Sylos",
          style: TextStyle(
              color: colorDark, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        SizedBox(
          height: 18,
        ),
        AutoSizeText(App.postInstruction,
            textAlign: TextAlign.center,
            style: getTextStyle(
              size: 14,
              color: Colors.black,
            ))
      ],
    ),
  );

  get repostIconsView => Container(
    padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
    alignment: Alignment.center,
    child: GridView.builder(
      physics: ScrollPhysics(),
      itemCount: model.repostModel.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.95),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        return Container(
          margin: EdgeInsets.only(left:35, right:35, top: 30, bottom: 30),
          child: Column(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => model.onClickItem(i),
                  child: ClipOval(
                    child:
                    Container(
                        child: Image.asset(
                          model.repostModel[i].icon,
                          fit: BoxFit.contain,
//                          width: double.infinity,
                        ),
                      padding: EdgeInsets.all(18),
                      color: model.repostModel[i].isCheck?colorDark:colorOvalBorder,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                model.repostModel[i].title,
                style: getTextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    size: 14),
              ),
            ],
          ),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = RepostsPageViewModel(this));
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Repost" + getSyloPostTitlesufix(appState.userSylo),
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
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  topTextView,
                  repostIconsView,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        if(runtimeType.toString()=="RepostsPageState") {
          print(runtimeType.toString());
          model.onResume();
        }
        break;
      case AppLifecycleState.inactive:
      // Handle this case
        break;
      case AppLifecycleState.paused:
      // Handle this case
        break;
    }
  }
}
