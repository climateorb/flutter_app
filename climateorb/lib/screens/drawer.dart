import 'package:flutter/material.dart';
import 'package:climateorb/screens/home.dart';
import 'package:climateorb/screens/local.dart';
import 'package:climateorb/screens/cloud.dart';
import 'package:climateorb/screens/settings.dart';
import 'package:climateorb/screens/about.dart';
import 'package:climateorb/screens/blogs.dart';
import 'package:climateorb/screens/bug_report.dart';
import 'package:climateorb/screens/help_feedback.dart';
import 'package:climateorb/utils/global_translations.dart';

Widget climateOrbDrawer(BuildContext context) {
  return ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      _createHeader(),
      _createDrawerItem(icon: Icons.home,text: allTranslations.text("drawer.item1"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));}),
      _createDrawerItem(icon: Icons.wifi, text: allTranslations.text("drawer.item2"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LocalScreen()));}),
      _createDrawerItem(icon: Icons.cloud, text: allTranslations.text("drawer.item3"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CloudScreen()));}),
      Divider(),
      _createDrawerItem(icon: Icons.lightbulb_outline, text: allTranslations.text("drawer.item4"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BlogPostsScreen()));}),
      _createDrawerItem(icon: Icons.info, text: allTranslations.text("drawer.item5"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AboutScreen()));}),
      _createDrawerItem(icon: Icons.settings, text: allTranslations.text("drawer.item6"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));}),
      Divider(),
      _createDrawerItem(icon: Icons.bug_report, text: allTranslations.text("drawer.item7"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BugReportScreen()));}),
      _createDrawerItem(icon: Icons.help, text: allTranslations.text("drawer.item8"), onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HelpFeedbackScreen()));}),
      ListTile(
        title: Text('1.0.1'),
        onTap: () {},
      ),
    ],
  );
}

Widget _createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image:  AssetImage('images/drawer-image.png'))),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}