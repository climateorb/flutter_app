import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:climateorb/screens/drawer.dart';
import 'package:climateorb/utils/climateorb.dart';

class HelpFeedbackScreen extends StatefulWidget {
  HelpFeedbackScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HelpFeedbackScreenState createState() => new _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App?'),
        actions: <Widget>[
          RaisedButton(
            color: Colors.blue,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
          RaisedButton(
            color: Colors.red,
            onPressed: () => SystemChannels.platform
                .invokeMethod<void>('SystemNavigator.pop'),
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  //BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new Center(
      child: new Text('Help and Feedback Screen Welcomes You'),
    );
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            title: Text(ClimateOrb.helpFeedback),
          ),
          drawer: Drawer(child: climateOrbDrawer(context)),
          body: new Builder(builder: (BuildContext context) {
            //_scaffoldContext = context;
            return body;
          }),
        ));
  }
}
