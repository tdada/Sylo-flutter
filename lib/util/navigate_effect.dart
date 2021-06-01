import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class NavigatePageRoute1 extends CupertinoPageRoute {
  Widget _page;

  NavigatePageRoute1(BuildContext context, Widget page)
      : super(builder: (context) => page) {
    _page = page;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    var begin = Offset.fromDirection(20);
    var end = Offset.fromDirection(10);
    var curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return new SlideTransition(position: animation.drive(tween), child: _page);
  }
}

class NavigatePageRoute extends PageRouteBuilder {
  final Widget page;
  final BuildContext context;

  NavigatePageRoute(this.context,this.page)
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
  );
}

