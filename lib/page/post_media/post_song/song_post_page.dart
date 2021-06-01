import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/util/util.dart';

import '../../../app.dart';
import 'song_post_page_view_model.dart';

class SongPostPage extends StatefulWidget {
  @override
  SongPostPageState createState() => SongPostPageState();
}

class SongPostPageState extends State<SongPostPage> with WidgetsBindingObserver{
  SongPostPageViewModel model;

  get dividerView => Container(
    margin: EdgeInsets.only(left: 16, right: 16),
    child: Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Colors.black,
              height: 50,
            )),
      ),

      Text("OR"),

      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.black,
              height: 50,
            )),
      ),
    ]),
  );

  get chooseFromLibraryView => Container(
    margin: EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
    child: commonButtonWithFilledSingleColorCorner((){},
        Text(
            "Choose from Library",
          style: getTextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            size: 17
          ),
        ),
        colorOvalBorder,
        borderColor:colorOvalBorder,
    ),
  );

  @override
  void initState() {
    super.initState();
    model =  SongPostPageViewModel(this);
    model.initSongModel();
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
          "Choose from music platforms",
          style: TextStyle(
              color: colorDark, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        SizedBox(
          height: 18,
        ),
        AutoSizeText(
            App.songInstruction,
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
      itemCount: model.songModel.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.0),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        return Container(
          margin: EdgeInsets.only(left:30, right:30, top: 30, bottom: 30),
          child: Column(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => model.onClickItem(i),
                  child:
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        model.songModel[i].icon,
                        fit: BoxFit.fill,
//                          width: double.infinity,
                      ),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                model.songModel[i].title,
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
    model ?? (model = SongPostPageViewModel(this));
    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Song Post" + getSyloPostTitlesufix(appState.userSylo),
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
        if(runtimeType.toString()=="SongPostPageState") {
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
