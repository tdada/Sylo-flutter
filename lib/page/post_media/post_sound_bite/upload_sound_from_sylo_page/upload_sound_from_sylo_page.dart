import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/post_media/post_sound_bite/sound_bite_trim_page/sound_bite_trim_page.dart';
import 'package:testsylo/page/post_media/post_sound_bite/upload_sound_from_sylo_page/upload_sound_from_sylo_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';

class UploadSoundFromSyloPage extends StatefulWidget {
  @override
  UploadSoundFromSyloPageState createState() => UploadSoundFromSyloPageState();
}

class UploadSoundFromSyloPageState extends State<UploadSoundFromSyloPage> {
  UploadSoundFromSyloPageViewModel model;
  bool _selectionMode = false;


  @override
  void initState() {
    super.initState();
    model = UploadSoundFromSyloPageViewModel(this);
  }

  get qcastGridView => Container(
    padding: EdgeInsets.only(left:16, right: 16),
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: model.soundItemList.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.80),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: Column(
              children: <Widget>[
                ClipOval(
                  child:
                      Container(
                        child: ClipOval(
                          child: Container(
                            color: model.soundItemList[i].isCheck?colorSectionHead:Colors.white,
                            height: 80,
                            width: 80,
                            padding: EdgeInsets.all(24),
                            child: Image.asset(
                                  model.soundItemList[i].isCheck?App.ic_mic_white:App.ic_mic,
                            ),
                          )
                        ),
                        padding: EdgeInsets.all(3),
                        color: colorOvalBorder,
                      ),
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  child:
                  AutoSizeText(
                    getNameFromServerLink(model.soundItemList[i].name),
                    maxLines: 3,
                    style: getTextStyle(size: 14,
                      color: Colors.black,),
                    overflow: TextOverflow.ellipsis,
                  ),
                  padding: EdgeInsets.only(top: 3),
                )
              ],
            ),
          ),
          onTap: () {
            if (!_selectionMode) {
              _selectionMode = true;
            }
            for(int i = 0 ; i < model.soundItemList.length ; i++){

              model.soundItemList[i].isCheck = false;

            }
            model.changeSelectItem(i);

            setState(() {

            });
          },
        );
      },
    ),
  );

  get btnView => Container(
    child: commonButton(
        () async {
//          goToTrimAudio(context, null, 0.0);
          String selectedAudioLink = model.soundItemList.firstWhere((element) => element.isCheck==true).name;
          Navigator.pop(context, selectedAudioLink);
        }
    , "Continue",red: 22),
    margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = UploadSoundFromSyloPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Upload Soundbite From Sylos",
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
      bottomNavigationBar: _selectionMode?Container(
        height: 75,
        child:btnView,
        margin: EdgeInsets.only(bottom: 16),
      ):Container(height: 0,),
      body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
//              Container(
//                padding: EdgeInsets.only(left: 16, right: 16),
//                child: formView,
//              ),
              qcastGridView,
              Container(height: 75,)

            ],
          )),
    );
  }
}
