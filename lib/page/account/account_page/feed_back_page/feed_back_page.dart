import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testsylo/app.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'feed_back_page_view_model.dart';


class FeedBackPage extends StatefulWidget {
  @override
  FeedBackPageState createState() => FeedBackPageState();
}

  class FeedBackPageState extends State<FeedBackPage> {
    double rating = 0.0;
    List<String> operations = ['new feature', 'feature review', 'issue report'];
    String operation; // = 'move';
    FeedBackPageViewModel model;
    TextEditingController feedbackTxtController = new TextEditingController();

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
            hint: Text("Select feedback category",
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

    @override
    Widget build(BuildContext context) {
      print("runtimeType -> " + runtimeType.toString());
      model ?? (model = FeedBackPageViewModel(this));
      return Scaffold(
        backgroundColor: getColorBg(),
        appBar: AppBar(
          title: Text(
            "Feedbacks",
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
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Rate this app: '),
                        SizedBox(width: 10,),
                        SmoothStarRating(
                            allowHalfRating: true,
                            onRated: (v) {
                              rating = v;
                              setState(() {});
                            },
                            starCount: 5,
                            rating: rating,
                            size: 30.0,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_border,
                            defaultIconData: Icons.star_border,
                            color: Color(0x00ff4E2A84),
                            borderColor: Color(0x00ff4E2A84),
                            spacing: 0.0
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                            controller: feedbackTxtController,
                            //focusNode: myFocusNodePasswordLogin,
                            //controller: loginPasswordController,
                            //obscureText: _obscureTextLogin,
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                            maxLines: 7,
                            decoration: InputDecoration(
                                hintText: 'How do you feel about this app?'
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return App.errorPassword;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  selectOperation(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: commonButton(
                            () async {
                          FeedbackRequest fbr = new FeedbackRequest(
                            category: operation,
                            stars: rating.toString(),
                            feedbackTxt: feedbackTxtController.text,
                          );
                          if (feedbackTxtController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Feedback text cannot be empty",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xff9F00C5),
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else if (operation == null || operation.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Feedback category cannot be empty",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xff9F00C5),
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else if (rating == 0.0) {
                            Fluttertoast.showToast(
                                msg: "Rating cannot be zero",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xff9F00C5),
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                          else {
                            model.createFeedback(fbr);
                          }
                        },
                        "Send",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }