import 'package:flutter/material.dart';
import 'package:testsylo/model/model.dart';

import '../../app.dart';

class AddTagPage extends StatefulWidget {
  final void Function(String) callback;

  AddTagPage(this.callback);

  @override
  AddTagPageState createState() => AddTagPageState();
}

class AddTagPageState extends State<AddTagPage> {
  TextEditingController tagNameController = TextEditingController();
  var _tagformKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }

  Widget appBar() {
    return Container(
      height: 45,

      child: Material(
        color: getMatColorBg(),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              width: 32,
              height: 32,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Add Tag",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 17),
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(right: 16),

                width: 32,
                height: 32,
              ),

            )
          ],
        ),
      ),
    );
  }

  animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
      padding: mediaQuery.viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                  EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      child: SafeArea(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0)),
                              ),

                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  appBar(),
                                  Container(

                                    child: Center(child: Text("Enter your Tag here", style: getTextStyle(color: Colors.black, fontWeight: FontWeight.w500, size: 14),)),
                                  ),
                                  Form(
                                    key: _tagformKey,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          left: 16,
                                          right: 16
                                      ),
                                      child: Material(
                                        color: getMatColorBg(),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.only(
                                                topRight: Radius.circular(1),
                                                topLeft: Radius.circular(1),
                                                bottomLeft: Radius.circular(1),
                                                bottomRight:
                                                Radius.circular(1))),
                                        child: Container(
                                          height: 35,
                                          child: TextFormField(

                                            controller: tagNameController,
                                            keyboardType: TextInputType.text,
                                            style: getTextStyle(size: 16, color: Colors.black, fontWeight: FontWeight.w400),
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(5.0),
                                                ),
                                                borderSide: BorderSide(width: 0.5, color: colorOvalBorder),
                                              ),
                                              contentPadding: EdgeInsets.only(left: 8),
                                              hintText: "",
                                              hintStyle:
                                              TextStyle(fontSize: 17.0),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return App.errorFieldRequired;
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(height: 1, color: colorOvalBorder, margin: EdgeInsets.only(top: 16),),

                                  Container(
                                    height: 50,
                                    child: Row(

                                      children: <Widget>[
                                        Expanded(

                                          child: InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Center(

                                              child: Text("Cancel", style: getTextStyle(color: Color(0x00ffC3C3C3), size: 18, fontWeight: FontWeight.w700),),

                                            ),
                                          ),

                                        ),
                                        Container(width: 1, color: colorOvalBorder,),
                                        Expanded(

                                          child: InkWell(
                                            onTap: (){
                                              if(_tagformKey.currentState.validate()){
                                                _tagformKey.currentState.save();
                                                widget.callback(tagNameController.text);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Center(

                                              child: Text("Save", style: getTextStyle(color: colorDark, size: 18, fontWeight: FontWeight.w700),),


                                            ),
                                          ),

                                        )


                                      ],

                                    ),
                                  )

                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
