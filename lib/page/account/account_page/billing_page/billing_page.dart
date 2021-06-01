import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testsylo/common/common_widget.dart';
import 'package:testsylo/page/account/account_page/billing_page/billing_page_view_model.dart';

import '../../../../app.dart';

class BillingPage extends StatefulWidget {
  @override
  BillingPageState createState() => BillingPageState();
}

class BillingPageState extends State<BillingPage> {
  BillingPageViewModel model;

  @override
  initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initData());

  }

  initData() async {
    model.getUserStorage();
    model.getSubPackages();
    model.getUserSubDetails();
    model.getRevenueCartOfferings();
  }


  get billView => ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: 4,
      shrinkWrap: true,
      separatorBuilder: (c, i) =>SizedBox(height: 50,),
      padding: EdgeInsets.only(top: 40, bottom: 40),
      itemBuilder: (c, i) {
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Container(
                  width: 240,
                  padding: EdgeInsets.only(top: 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: billCardItem,
                ),
              ),
            ),
            Center(child: Image.asset(App.ic_billing_cloud, height: 62,)),
          ],
        );
      });

  get billCardItem => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(App.pound_currency + '15.99/month',
                style: getTextStyle(
                    color: colorSectionHead,
                    size: 18,
                    fontWeight: FontWeight.w800)),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 14),
            child: RichText(
              text: TextSpan(
                text: "Sylo Cloud Space: ",
                style: getTextStyle(
                  color: Colors.black,
                  size: 12,
                  fontWeight: FontWeight.w500,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '15 GB',
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      style: getTextStyle(
                          color: colorSectionHead,
                          size: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Divider(
              thickness: 1,
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(bottom: 4),
              width: 100,
              height: 50,
              child: commonButton(() {}, "Subscribe", red: 10, font_size: 12))
        ],
      );

  @override
  Widget build(BuildContext context) {
    print("runtimeType -> " + runtimeType.toString());
    model ?? (model = BillingPageViewModel(this));

    return Scaffold(
      backgroundColor: getColorBg(),
      appBar: AppBar(
        title: Text(
          "Billing",
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
          child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60),
            child: Text('Space used: ${model.usedStorage ?? 0.0}KB', style: TextStyle(fontWeight: FontWeight.w800),),
          ),
          billView,
        ],
      )),
    );
  }
}
