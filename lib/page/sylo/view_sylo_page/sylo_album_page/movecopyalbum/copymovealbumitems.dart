import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/api_response.dart';
import 'package:testsylo/page/sylo/choose_sylo_view_all_page/choose_sylo_view_all_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/movecopyalbum/copymovealbumdetails_view_model.dart';
import 'package:testsylo/page/sylo/view_sylo_page/sylo_album_page/sylo_album_detail_page/sylo_album_detail_page.dart';
import 'package:testsylo/page/sylo/view_sylo_page/view_sylo_page.dart';
import 'package:testsylo/util/navigate_effect.dart';

class MoveCopyAlbumDetails extends StatefulWidget {
  GetAlbum getAlbum;
  List<AlbumMediaData> albumMediaDataList;
  GetUserSylos userSylo;
  Function(int index, GetUserSylos sylo, {String from, GetAlbum getAlbum, bool isAlbumGrid}) callBack;

  MoveCopyAlbumDetails(
      {this.getAlbum, this.albumMediaDataList, this.callBack, this.userSylo});

  @override
  MoveCopyAlbumDetailsState createState() => MoveCopyAlbumDetailsState();
}

  class MoveCopyAlbumDetailsState extends State<MoveCopyAlbumDetails> {
    GetAlbum selectedAlbum;
    List<GetAlbum> selectedAlbums = List<GetAlbum>();
    List<String> operations = ['MOVE', 'COPY'];
    String operation; // = 'move';
    CopyMoveViewModel model;

    Widget selectOperation() {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: operation,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.red, fontSize: 18),
            hint: Text("Select operation",
                style: TextStyle(fontSize: 14)
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String data) {
              setState(() {
                operation = data;
              });
            },
            items: operations.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
    }

    Widget selectAlbums() {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<GetAlbum>(
            isExpanded: true,
            value: selectedAlbum,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.red, fontSize: 18),
            hint: Text("Select destinaion album",
                style: TextStyle(fontSize: 14)
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (GetAlbum data) {
              setState(() {
                selectedAlbum = data;
              });
            },
            items: appState.albumList.map<DropdownMenuItem<GetAlbum>>((
                GetAlbum value) {
              return DropdownMenuItem<GetAlbum>(
                value: value,
                child: Text(value.albumName),
              );
            }).toList(),
          ),
        ),
      );
    }

    Widget listAlbumContent() {
      return ListView(
        shrinkWrap: true,
        children: List.generate(appState.albumList.length, (index) =>
        widget.getAlbum == appState.albumList[index] ? Container() : ListTile(
          onTap: () {
            setState(() {
              if (selectedAlbums.contains(appState.albumList[index])) {
                bool done = selectedAlbums.remove(appState.albumList[index]);
                if (done) {
                  appState.albumList[index].selected = false;
                }
              } else {
                selectedAlbums.add(appState.albumList[index]);
                appState.albumList[index].selected = true;
              }
            });
          },
          title: Text(appState.albumList[index].albumName),
          trailing: Icon(Icons.stop,
            color: appState.albumList[index].selected
                ? Color(0xff522887)
                : Colors
                .grey,),
        ),
        ),
      );
    }


    get syloView => model.userSylosList != null ? Container(
      height: 195,
      padding: EdgeInsets.only(
        top: 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.only(top: 4, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Choose Sylo",
                          style: getTextStyle(
                              size: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              var result = await Navigator.push(
                                  context,
                                  NavigatePageRoute(
                                      context, ChooseSyloViewAllPage(post_type: "Annograph", userSylosList: model.userSylosList,)));
                              if(result != null){
                                model.userSylosList = result;
                              }
                              setState(() {
                              });
                            },
                            child: Container(
                              child: Text(
                                "View all",
                                style: getTextStyle(
                                    color: colorSectionHead,
                                    size: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              padding: EdgeInsets.only(),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 24,
                            color: colorSectionHead,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: model.userSylosList.length,
                  /*  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 0.5),
               */
                  shrinkWrap: true,
                  itemBuilder: (c, i) {

                    return Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
//                                if (!_selectionMode) {
//                                  _selectionMode = true;
//                                }
//                                for(int i = 0 ; i < model.albumsItemList.length ; i++){
//
//                                  model.albumsItemList[i].isCheck = false;
//
//                                }
                                  model.changeSelectSyloItem(i);

                                  setState(() {

                                  });
//                                        var result = await Navigator.push(
//                                            context,
//                                            NavigatePageRoute(
//                                                context, SyloAlbumDetailPage()));
                                },
                                child: ClipOval(
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            width: 74,
                                            height: 74,
                                            child: ImageFromNetworkView(
                                              path: model.userSylosList[i]
                                                  .syloPic !=
                                                  null
                                                  ? model.userSylosList[i]
                                                  .syloPic
                                                  : "",
                                              boxFit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        model.userSylosList[i].isCheck
                                            ? ClipOval(
                                          child: Container(
                                            width: 74,
                                            height: 74,
                                            color: Color.fromRGBO(
                                                106, 13, 173, 0.3),
                                            child: Icon(
                                              Icons.check,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                            : Container(width: 0)
                                      ],
                                    ),
                                    padding: EdgeInsets.all(3),
                                    color: colorOvalBorder,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                child: Text(
                                  model.userSylosList[i].displayName ?? model.userSylosList[i].syloName,
                                  style: getTextStyle(
                                      color: Colors.black,
                                      size: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                padding: EdgeInsets.only(top: 3),
                              ),

                              Container(
                                child: Text(
                                  model.userSylosList[i].syloAge,
                                  style: getTextStyle(
                                      color: Color(0x00ff707070),
                                      size: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                                padding: EdgeInsets.only(top: 3),
                              )
                            ],
                          ),

                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ):SizedBox();

    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      model ?? (model = CopyMoveViewModel(this));
      return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                "Move/Copy Album Contents",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 17),
              ),
              Text(
                "Select items to move/copy",
                style: TextStyle(
                    color: Colors.black, fontSize: 14),
              ),
            ],
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
              //widget.callBack(6, widget.userSylo);
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            //viewAllHeaderButton,
          ],
        ),
        body: SafeArea(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //listAlbumContent(),
                    syloView,
                    selectOperation(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: commonButton(
                              () async {
                                if (operation == null || operation.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "No operation type was selected",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Color(0xff9F00C5),
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                                else {
                                  List<GetUserSylos> list = getListOfSelectedSylo(
                                          model.userSylosList);
                                      if (list == null || list.length == 0) {
                                    commonAlert(
                                        context, "Please Select Sylos.");
                                    return;
                                  }
                                  List<GetUserSylos> selectedSyloList = List();
                                  model.userSylosList.forEach((element) {
                                    if (element.isCheck) {
                                      selectedSyloList.add(element);
                                    }
                                  });
                                  List<int> result = await goToChooseSyloPage(
                                      context, "Move/Copy Album Contents",
                                      selectedSyloList: selectedSyloList);
                                  if (result != null) {}
                                  List<int> albumIds = new List<int>();
                                  for (var i = 0; i < result.length; i++) {
                                    albumIds.add(result[i]);
                                    print("REsult1" + result[i].toString());
                                  }
                                  CopyMoveRequest fbr = new CopyMoveRequest(
                                      sourceAlbumId: widget.getAlbum.albumId,
                                      destinationAlbumIdList: albumIds,
                                      actionType: operation
                                  );
                                  if (albumIds.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Album list cannot be empty",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Color(0xff9F00C5),
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                  else {
                                    print("-------avc");
                                    Navigator.pop(context,this);
                                    await model.copyMoveAlbum(fbr);
                                  }
                                }
                              },
                          "Send",
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

