import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/post_media/post_photo/photo_sylo_page/sylo_library_page_view_model.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../../../app.dart';
import '../../../../common/common_widget.dart';


class SyloLibraryPage extends StatefulWidget{
  String from;
  SyloLibraryPage(this.from);
  @override
  SyloLibraryPageState createState() => SyloLibraryPageState();

}

class SyloLibraryPageState extends State<SyloLibraryPage>  {
  List<int> _selectedIndexList = List();
  SyloLibraryPageViewModel model;
  @override
  void initState() {
    model = SyloLibraryPageViewModel(this);
  }

  get onPressed =>() async {
      if(widget.from == "PHOTO") {
        if(_selectedIndexList.length!=0) {
          List<PostPhotoModel> photoList = List();

          _selectedIndexList.forEach((element) {
            photoList.add(
                new PostPhotoModel(link: model.list[element], isCircle: false));
          });

          Navigator.pop(context, photoList);
        } else {
          commonToast("Please, select at least one item");
        }
      }
      if(widget.from == "VIDEO"){
        if( model.selectIndex!=-1 ){
        List<RecordFileItem> listRecordWithThumb = List();
//        _selectedIndexList.forEach((element) {
          listRecordWithThumb.add(
              RecordFileItem(null, null, link: model.listVideoItem[model.selectIndex].link, thumbPath:model.listVideoItem[model.selectIndex].thumbFile));
//        });
        Navigator.pop(context, listRecordWithThumb);
        } else {
        commonToast("Please, select at least one item");
      }
    }

  };

  getGridTile(index){

    return GridTile(
        child: GestureDetector(
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                ImageFromNetworkView(
                  path: model.list[index],
                  boxFit: BoxFit.cover,
                ),
                _selectedIndexList.contains(index) ? Container(
                  constraints: BoxConstraints.expand(),
                  color: Color.fromRGBO(
                      106, 13, 173, 0.3),
                  child: Icon(
                    Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
                ):Container(width: 0)
              ],
            ),
          ),
          onTap: () {
            setState(() {
              if (_selectedIndexList.contains(index)) {
                _selectedIndexList.remove(index);
              } else {
                if(_selectedIndexList.length==4)
                  Fluttertoast.showToast(msg: "You can not choose more than 4 images");
                else
                  _selectedIndexList.add(index);
              }
            });
          },
        ));
  }

  get sylogrid => Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
    child: GridView.builder(
      physics: ScrollPhysics(),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.0, mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0),
      shrinkWrap: true,
      itemCount: model.list.length,
      itemBuilder: (BuildContext context, int index) {
      return getGridTile(index);
      },
//      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    ),
  );

  get editVideoButtons => Container(
//      width: 65,
      child: Material(
        elevation: 0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: colorSectionHead, width: 2)),
          child: InkWell(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 3),
              child: Text(
                "Continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorSectionHead,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            onTap: onPressed,
          ),
        ),
      ));

  get videoGridView => Container(
    padding: EdgeInsets.only(left:16, right: 16),
    child: GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: model.listVideoItem.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.0,
          mainAxisSpacing: 4.0, crossAxisSpacing: 4.0),
      shrinkWrap: true,
      itemBuilder: (c, i) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: <Widget>[
                Image.file(
                  model.listVideoItem[i].thumbFile,
                      fit:BoxFit.cover,
                ),
                model.selectIndex == i ? Container(
                  constraints: BoxConstraints.expand(),
                  color: Color.fromRGBO(
                      106, 13, 173, 0.3),
                  child: Icon(
                    Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
                ):Container(width: 0)
              ],
            ),
          ),
          onTap: () {
            setState(() {
              model.selectIndex = i;
            });
          },
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    model ?? (model = SyloLibraryPageViewModel(this));

    return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text("Choose from Sylo",
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
        bottomNavigationBar: Container(
          height: 60,
          child: editVideoButtons,
          padding: EdgeInsets.only(left: 70, right: 70, top: 10,bottom: 10),
        ),
        body: SafeArea(

        child: Stack(
          children: <Widget>[
            ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    widget.from == "PHOTO" ? sylogrid : SizedBox(),
                    widget.from == "VIDEO" ? videoGridView:SizedBox(),
                  ],
                )
              ],
            ),
            appLoader(model.isLoad),
          ],
        ),
      )
    );
  }
}