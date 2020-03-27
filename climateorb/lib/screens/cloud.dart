import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:climateorb/screens/drawer.dart';
import 'package:climateorb/utils/global_translations.dart';
import 'package:climateorb/screens/webview_container.dart';

class CloudScreen extends StatefulWidget {
  CloudScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CloudScreenState createState() => new _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        title: new Text(allTranslations.text("dialog.title")),
        content: new Text(allTranslations.text("dialog.content")),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              allTranslations.text("dialog.no"),
              style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () => SystemChannels.platform
                .invokeMethod<void>('SystemNavigator.pop'),
            child: Text(
              allTranslations.text("dialog.yes"),
              style: TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  BuildContext _scaffoldContext;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget getFormBody(BuildContext context) {
      return Container(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 50.0),
              Column(
                children: <Widget>[
                  Image.asset(
                    'images/dash-image.png',
                    height: 150.0,
                  ),
                  SizedBox(height: 12.0),
                  Text('View Cloud Devices',
                      style: Theme.of(context).textTheme.headline),
                ],
              ),
              SizedBox(height: 30.0),
//            Text('Device ID:', style: Theme.of(context).textTheme.body1),
//            SizedBox(height: 10.0),
              Container(
                color: Colors.white,
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        //TextInputType.number,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          filled: true,
                          hintText: "Enter 9 Digits",
                          labelText: "Enter your Device ID",
                          helperText: "Example: 123456789",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a correct Device ID';
                          }
                          return null;
                        },
                      ),
                      RaisedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                            String deviceURL = "https://api.climateorb.com/quick-login/?device-id="+"123456789";
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewContainer(deviceURL)));
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ])),
              ),
              //_buildEnterButton(context),
            ],
          ),
        ),
      );
    }

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            title: Text(allTranslations.text("cloud.title")),
          ),
          drawer: Drawer(child: climateOrbDrawer(context)),
          body: new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return getFormBody(_scaffoldContext);
          }),
        ));
  }
}
