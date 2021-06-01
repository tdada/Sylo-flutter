import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_route.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/model.dart';
import 'package:testsylo/page/common/add_prompt_page.dart';
import '../../../../../../app.dart';
import 'create_prompts_page_view_model.dart';

class CreatePromptsPage extends StatefulWidget {
  @override
  CreatePromptsPageState createState() => CreatePromptsPageState();
}

  class CreatePromptsPageState extends State<CreatePromptsPage> {
    CreatePromptsPageViewModel model;
    var createPromptsFormKey = GlobalKey<FormState>();
    final FocusNode myFocusNodeTitlePrompts = FocusNode();
    TextEditingController promptsTitleController = new TextEditingController();

    get nameFieldLabel =>
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Add title",
            style: getTextStyle(color: Color(0x00ffC3C3C3), size: 14),
          ),
        );

    get nameFormField =>
        Container(
          child: Material(
            color: getMatColorBg(),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(1),
                    topLeft: Radius.circular(1),
                    bottomLeft: Radius.circular(1),
                    bottomRight: Radius.circular(1))),
            child: Container(
              child: TextFormField(
                focusNode: myFocusNodeTitlePrompts,
                controller: promptsTitleController,
                keyboardType: TextInputType.text,
                style: getTextStyle(size: 16, color: Colors.black),
                decoration: InputDecoration(
                  //border: InputBorder.none,
                  hintText: "Enter Prompt title",
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400), //          suffixIcon:
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return App.errorNameOnly;
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        );


    get addFormButton =>
        Center(
          child: Container(
//    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            height: 25,
            width: 144,
            child: RaisedButton(
              onPressed: () async {
                var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) => AddPromptPage(),
                );
                if (result != null) {
                  model.addPrompt(result);
                }
              },
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    color: colorDark,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: colorDark, width: 1.1)),
                child: Container(
                  constraints: BoxConstraints(minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        "Add your Question",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );


    get btnView =>
        Container(
          child: commonButton(
                () {
              if (createPromptsFormKey.currentState.validate()) {
                model.saveCustomPrompt();
              }
            },
            "Save",
          ),
        );

    get formView =>
        Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Column(
              children: <Widget>[
                Form(
                  key: createPromptsFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      nameFieldLabel,
                      nameFormField,
                    ],
                  ),
                ),
              ],
            ));

    get listPromptView =>
        Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: model.listPrompts.length,
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  String item = model.listPrompts[i];
                  return Container(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text("${i + 1}.", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),),
                      title: Text(item, style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),),
                      trailing: GestureDetector(
                          onTap: () {
                            model.removePrompt(i);
                          },
                          child: Icon(Icons.remove_circle, color: Colors.red,)),
                    ),
                  );
                }));

    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      model ?? (model = CreatePromptsPageViewModel(this));
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Create New Prompt",
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
        /*bottomNavigationBar: Container(
          height: 58,
          child: btnView,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(bottom: 16),
        ),*/
        floatingActionButton: Container(
          color: Colors.transparent,
          height: 60,
          alignment: Alignment.center,
          child: btnView,
          padding: EdgeInsets.only(left: 32),
        ),
        body: SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Column(

                children: [
                  formView,
                  listPromptView,
                  // questions resticted to 12. This should also be handled from backend
                  model.listPrompts.length == 12
                      ? Container()
                      : addFormButton,
                  SizedBox(height: 30,),
                ],
              ),
              ],
            )),
      );
    }
  }