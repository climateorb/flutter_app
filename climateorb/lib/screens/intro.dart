import 'package:flutter/material.dart';
import 'package:climateorb/utils/climateorb.dart';
import 'package:climateorb/utils/navigator.dart';
import 'package:climateorb/widgets/WalkThrough.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PageView(
              children: <Widget>[
                WalkThrough(
                  title: ClimateOrb.wt1,
                  content: ClimateOrb.wc1,
                  imageIcon: 'images/climateorb-logo.png',
                ),
                WalkThrough(
                  title: ClimateOrb.wt2,
                  content: ClimateOrb.wc2,
                  imageIcon: 'images/prida-logo.png',
                ),
                WalkThrough(
                  title: ClimateOrb.wt3,
                  content: ClimateOrb.wc3,
                  imageIcon: 'images/breeze-logo.png',
                ),
                WalkThrough(
                  title: ClimateOrb.wt4,
                  content: ClimateOrb.wc4,
                  imageIcon: 'images/platform-logo.png',
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : ClimateOrb.skip,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () =>
                  lastPage ? null : ClimateOrbNavigator.goToHome(context),
                ),
                FlatButton(
                  child: Text(lastPage ? ClimateOrb.gotIt : ClimateOrb.next,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () => lastPage
                      ? ClimateOrbNavigator.goToHome(context)
                      : controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
