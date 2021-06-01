import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_response.dart';

import '../../../app.dart';
import 'choose_sylo_view_all_page_view_model.dart';

class ChooseSyloViewAllPage extends StatefulWidget {
  String post_type = "";
  List<GetUserSylos> userSylosList;
  ChooseSyloViewAllPage({this.post_type, this.userSylosList});
  @override
  ChooseSyloViewAllPageState createState() => ChooseSyloViewAllPageState();
}

class ChooseSyloViewAllPageState extends State<ChooseSyloViewAllPage> {
  ChooseSyloViewAllPageViewModel model;
  int selectedItem = 0;

  get syloListView => Container(
    padding: EdgeInsets.only(bottom: selectedItem>0?60:16),
    child: ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: model.userSylosList?.length??0,
      shrinkWrap: true,
      itemBuilder: (c, i) {

        return Container(
          padding: EdgeInsets.only(left: 16, bottom: 16, right: 5),
          child:  InkWell(
            onTap: () {
              model.changeSelectItem(i);
              model.updateSelectCount();
              setState(() {});
            },
            child: Row(
              children: <Widget>[
                ClipOval(
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
                SizedBox(width: 12,),
                Expanded(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 3,),
                      Container(
                        child: Text(
                          model.userSylosList[i].displayName ?? model.userSylosList[i].syloName,
                          style: getTextStyle(color: Colors.black, size: 15, fontWeight: FontWeight.w500),
                        ),
                        padding: EdgeInsets.only(top: 3),
                      ),
                      SizedBox(height: 3,),
                      AutoSizeText("${model.userSylosList[i].syloAge} - ${model.userSylosList[i].albumCount} posts", style: getTextStyle(size: 13, color: colorSubTextPera,)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  get selectedItemContText => Container(
    padding: EdgeInsets.only(left: 16, bottom: 16, right: 5),
    alignment: Alignment.centerLeft,
    child: Text(
        "$selectedItem Assigned Sylos",
      style: getTextStyle(color: colorDark, size: 16, fontWeight: FontWeight.w800),
    ),
  );

  get saveButton => Container(
    child: commonButton(() {
//      goToChooseSyloPage(context, widget.post_type);
      Navigator.pop(context, model.userSylosList);
    }, "Continue"),
  );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = ChooseSyloViewAllPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Choose Sylo",
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
        )

        ,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: selectedItem>0?Container(
        color: Colors.transparent,
        height: 60,
        alignment: Alignment.center,
        child: saveButton,
        margin: EdgeInsets.only(left: 32),
      ):Container(height: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              selectedItemContText,
              syloListView,
            ],
          ),

        ),
      ),
    );
  }
}
