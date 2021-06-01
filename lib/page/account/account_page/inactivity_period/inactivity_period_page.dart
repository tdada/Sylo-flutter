import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/model/api_request.dart';
import 'package:testsylo/model/drop_down_item.dart';

import '../../../../app.dart';
import 'inactivity_period_page_view_model.dart';

class InActivityPeriodPage extends StatefulWidget {
  @override
  InActivityPeriodPageState createState() => InActivityPeriodPageState();
}

class InActivityPeriodPageState extends State<InActivityPeriodPage> {
  InActivityPeriodPageViewModel model;
  double sliderValue;
  DropDownItem notifyDropDownItem;

  get btnView => Container(
        child: commonButton(
          () {
//        if(_userProfileformKey.currentState.validate()){
//          _userProfileformKey.currentState.save();
            InActivityPeriodItem inActivityPeriodItem = InActivityPeriodItem(userId: appState.userItem.userId);
            if(notifyDropDownItem!=null && appState.inActivityPeriodItem.reminderDays != notifyDropDownItem.index) {
              inActivityPeriodItem.reminderDays = notifyDropDownItem.index;
            }
            if(appState.inActivityPeriodItem.inactivityPeriod != sliderValue.round()) {
              inActivityPeriodItem.inactivityPeriod = sliderValue.round();
            }
            if(inActivityPeriodItem.inactivityPeriod!=null || inActivityPeriodItem.reminderDays!=null) {
              model.getOrUpdateIP(inActivityPeriodItem);
            }
            Navigator.of(context).pop();
          },
          "Save",
        ),
      );

  get topTextView => Column(
        children: <Widget>[
          Text(
            "Select Inactivity Period",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: AutoSizeText(App.inactivityPeriodInstruction,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  size: 14,
                  color: colorSubTextPera,
                )),
          )
        ],
      );

  get instructionBanner => Container(
      decoration: BoxDecoration(
          color: colorOvalBorder,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20,top: 10),
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
        child: AutoSizeText(App.inactivityPeriodBannerInstruction,
            textAlign: TextAlign.center,
            style: getTextStyle(
              size: 13,
              color: colorSubTextPera,
            )),
      ));

  get sliderView => Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 22, bottom: 18),
        child: Row(
          children: <Widget>[
            Text(
              "1 \n Day",
              textAlign: TextAlign.center,
              style: getTextStyle(color: colorSubTextPera, size: 13),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xff9F00C5),
                  inactiveTrackColor: Colors.black12,
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 22.0,
                  thumbColor: Color(0xff9F00C5),
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 16.0, disabledThumbRadius: 16.0),
                ),
                child: Slider(
                  min: 1,
                  max: 365,
                  value: sliderValue,
                  label: '${sliderValue.round()}\n Days',
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),
              ),
            ),
            Text(
              "365 \n Days",
              textAlign: TextAlign.center,
              style: getTextStyle(color: colorSubTextPera, size: 13),
            ),
          ],
        ),
      );

  get addMoreNotificationButton => Container(
        height: 38,
        child: commonButtonWithCorner(
            () {},
            "Add More Notifications",
            Icon(
              Icons.add,
              color: colorDark,
            ),
            font_size: 15),
        margin: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
      );

  get dropDownWidget {
    var items = model.notifyMeList.map((item) {
      return new DropdownMenuItem<DropDownItem>(
        value: item,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            item.label,
            style: new TextStyle(color: Colors.black,fontSize: 13),
          ),
        ),
      );
    }).toList();

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 10, right: 16),
      child: DropdownButtonHideUnderline(
        child: Container(
          height: 33,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0,
                  style: BorderStyle.solid,
                color: colorSubTextPera,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
          child: DropdownButton<DropDownItem>(
              value: notifyDropDownItem,
              isDense: true,
              isExpanded: true,
              icon: Container(
                color: colorSubTextPera,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select",
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              onChanged: (DropDownItem i) {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  notifyDropDownItem = i;
                });
              },
              items: items),
        ),
      ),
    );
  }

  get dropDownWidgetList => Container(
    padding: EdgeInsets.only(left:20, right: 20,top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Notify me:",textAlign: TextAlign.center,style: getTextStyle(color: Colors.black, size: 14),),
        //SizedBox(width: 5,),
        Expanded(child: dropDownWidget),
      ],
    ),
  );

  get sliderValueDisplay => Container(
    margin: EdgeInsets.only(top: 4, bottom: 12),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            sliderValue.round().toString(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
          ),
          Text(" days")
        ],
      )
  );

  @override
  void initState() {
    super.initState();
    model = InActivityPeriodPageViewModel(this);
    model.initNotifyMeList();
    sliderValue = model.inActivityPeriodItem.inactivityPeriod?.toDouble()??10.0;
    notifyDropDownItem = model.inActivityPeriodItem.reminderDays==null?null:model.notifyMeList.where((element) => element.index==model.inActivityPeriodItem.reminderDays).first;
  }

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = InActivityPeriodPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Inactivity Period",
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
        height: 58,
        child: btnView,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      body: SafeArea(
          child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 12),
            child: topTextView,
          ),
          sliderView,
          sliderValueDisplay,
          instructionBanner,
          dropDownWidgetList,
          addMoreNotificationButton
//          dropDownWidgetList,
//          addMoreNotificationButton,
        ],
      )),
    );
  }
}
