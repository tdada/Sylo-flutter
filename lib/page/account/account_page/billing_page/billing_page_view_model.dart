import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:testsylo/page/account/account_page/billing_page/billing_page.dart';
import 'package:testsylo/service/rest_api/interceptor_api.dart';

import '../../../../app.dart';

class BillingPageViewModel {
  BillingPageState state;
  bool isLoader = false;
  InterceptorApi interceptorApi;
  double usedStorage = 0.0;

  BillingPageViewModel(BillingPageState state){
    this.state = state;
    interceptorApi = InterceptorApi(context: state.context);
  }

  getUserStorage() async {
   // state.setState(() {
   //   isLoader = true;
   // });

    //bool isSuccess =
    Map<String, dynamic> resultData = await interceptorApi.callGetUserStorage(appState.userItem.userId);
    print(resultData['result']);
    if (resultData['result']) {
      state.setState(() {
        usedStorage = resultData['storage'];
      });

//      goToHome(state.context);
    //  state.setState(() {
      //  isLoader = false;
      //});

      //Navigator.push(
      //    state.context, NavigatePageRoute(state.context, AccountPage()));
      //state.widget.callBack(6, state.widget.userSylo);
      //goToHome((state.context));
    }
   // state.setState(() {
   //   isLoader = false;
   // });
  }

  getSubPackages() async {
    state.setState(() {
       isLoader = true;
     });

    bool isSuccess = await interceptorApi.callGetSubpackages();
    print(isSuccess);

    if (isSuccess) {

//      goToHome(state.context);
state.setState(() {
      isLoader = false;
     });

      //Navigator.push(
      //    state.context, NavigatePageRoute(state.context, AccountPage()));
      //state.widget.callBack(6, state.widget.userSylo);
      //goToHome((state.context));
    }
 state.setState(() {
     isLoader = false;
   });
  }

  getUserSubDetails() async {
    // state.setState(() {
    //   isLoader = true;
    // });

    //bool isSuccess =
    Map<String, dynamic> resultData = await interceptorApi.callGetUserSubDetails(appState.userItem.userId);
    print(resultData['result']);
    if (resultData['data'] != null) {

//      goToHome(state.context);
      //  state.setState(() {
      //  isLoader = false;
      //});

      //Navigator.push(
      //    state.context, NavigatePageRoute(state.context, AccountPage()));
      //state.widget.callBack(6, state.widget.userSylo);
      //goToHome((state.context));
    }
    // state.setState(() {
    //   isLoader = false;
    // });
  }

  getRevenueCartOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();

      print(offerings);
      if (offerings.current != null) {
        // Display current offering with offerings.current

        print(offerings);
      }
    } on PlatformException catch (e) {
      // optional error handling
      print(e);
    }
  }
}