import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/password_add/password_add_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';
import 'package:testsylo/util/navigate_effect.dart';

import '../../app.dart';

class CreateAlbumPage extends StatefulWidget {
  String syloId = "";
  bool quickAlbum = false;

  CreateAlbumPage({this.syloId, this.quickAlbum});

  @override
  CreateAlbumPageState createState() => CreateAlbumPageState();
}

class CreateAlbumPageState extends State<CreateAlbumPage> {
  TextEditingController nameAlbumController = TextEditingController();
  var _logInformKey = GlobalKey<FormState>();
  InterceptorApi interceptorApi;

  get onPressedVerify => () async {
        var result = await Navigator.push(
            context, NavigatePageRoute(context, PasswordAddPage()));
      };

  @override
  void initState() {
    super.initState();
    interceptorApi = InterceptorApi(context: context);
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
                    "Create Album",
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
                                    child: Center(
                                        child: Text(
                                      "Enter a name for this album",
                                      style: getTextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          size: 14),
                                    )),
                                  ),
                                  Form(
                                    key: _logInformKey,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 16, left: 16, right: 16),
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
                                          height: 55,
                                          child: TextFormField(
                                            controller: nameAlbumController,
                                            keyboardType: TextInputType.text,
                                            style: getTextStyle(
                                                size: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            maxLength: 28,
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(5.0),
                                                ),
                                                borderSide: BorderSide(
                                                    width: 0.5,
                                                    color: colorOvalBorder),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.only(left: 8),
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
                                  Container(
                                    height: 1,
                                    color: colorOvalBorder,
                                    margin: EdgeInsets.only(top: 16),
                                  ),
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: getTextStyle(
                                                    color: Color(0x00ffC3C3C3),
                                                    size: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          color: colorOvalBorder,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              if (nameAlbumController
                                                      .text.length <=
                                                  28) {
                                                if (_logInformKey.currentState
                                                    .validate()) {
                                                  if (widget.syloId != "") {
                                                    bool isSuccess =
                                                        await interceptorApi
                                                            .callCreateAlbum(
                                                      nameAlbumController.text
                                                          .trim(),
                                                      widget.syloId,
                                                      quickAlbum:
                                                          widget.quickAlbum,
                                                    );

                                                    if (!isSuccess) {
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                }
                                              } else {
                                                commonToast(
                                                    "You can not add more then 28 chars");
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                style: getTextStyle(
                                                    color: colorDark,
                                                    size: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
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
