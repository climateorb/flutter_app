import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;

import 'package:climateorb/screens/drawer.dart';
import 'package:climateorb/utils/climateorb.dart';

class BlogPost {
  String blogId;
  String imageURL;
  String title;
  String tags;
  String desc;
  String link;

  BlogPost(
      this.blogId, this.imageURL, this.title, this.tags, this.desc, this.link);

  factory BlogPost.fromJSON(String blogId, Map<String, dynamic> json) {
    return new BlogPost(blogId, json[0], json[1], json[2], json[3], json[4]);
  }

  factory BlogPost.fromBlogPost(BlogPost blogPost) {
    return new BlogPost(blogPost.blogId, blogPost.imageURL, blogPost.title,
        blogPost.tags, blogPost.desc, blogPost.link);
  }

  @override
  String toString() {
    return '${this.blogId}, ${this.imageURL}, ${this.title}, ${this.tags}, ${this.desc}, ${this.link}';
  }
}

class BlogPostsScreen extends StatefulWidget {
  BlogPostsScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BlogPostsScreenState createState() => new _BlogPostsScreenState();
}

class _BlogPostsScreenState extends State<BlogPostsScreen> {
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

  BuildContext _scaffoldContext;

  //Map is basically a type of key/value pair in dart
  Map<String, dynamic> blogJSONData = Map<String, dynamic>();
  List<BlogPost> blogPostList = <BlogPost>[];

  void _getBlogPosts() async {
    var blogPostsURL = 'http://climateorb.com/blog-feeds/blogposts.json';
    var response = await http.get(blogPostsURL, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
    });

    if (response.statusCode == 200) {
      //setState(() => _blogPosts = convert.JsonDecoder(response.body);
      //debugPrint(convert.utf8.decode(response.bodyBytes));
      setState(() => blogJSONData =
          convert.jsonDecode(convert.utf8.decode(response.bodyBytes)));
      //blogJSONData.forEach((key, value) => debugPrint(value.toString()));
      //blogJSONData.forEach((key, value) => blogPostList.add(BlogPost.fromJSON(key, value)));
      blogPostList.clear();
      blogJSONData.forEach((key, value) => blogPostList.add(
          BlogPost(key, value[0], value[1], value[2], value[3], value[4])));
      //debugPrint("Length: " +blogPostList.length.toString() + " Contents: " + blogPostList.toString());
    } else {
      print('Error: ' + response.statusCode.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getBlogPosts();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: blogPostList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 8.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                    decoration: BoxDecoration(color: Colors.white12),
                    child: getBlogPostsCard(blogPostList[index])),
              );
            }));

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            title: Text(ClimateOrb.blogPost),
          ),
          drawer: Drawer(child: climateOrbDrawer(context)),
          body: new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return body;
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => reloadBlogPosts(_scaffoldContext),
            child: Icon(Icons.refresh),
            tooltip: 'Reload',
          ),
        ));
  }

//  Widget getListTile(BlogPost blogPost) {
//    return ListTile(
//        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//        leading: Container(
//          padding: EdgeInsets.only(right: 12.0),
//          decoration: new BoxDecoration(
//              border: new Border(
//                  right: new BorderSide(width: 1.0, color: Colors.white24))),
//          child: Icon(Icons.description, color: Colors.white),
//        ),
//        title: Text(
//          blogPost.title,
//          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//        ),
//        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
//
//        subtitle: Row(
//          children: <Widget>[
//            Icon(Icons.linear_scale, color: Colors.yellowAccent),
//            Text(blogPost.tags, style: TextStyle(color: Colors.white))
//          ],
//        ),
//        trailing:
//            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
//        onTap: () async {
//          debugPrint(blogPost.link);
//          if (await canLaunch(blogPost.link)) {
//            await launch(blogPost.link, forceSafariVC: false);
//          } else {
//            throw 'Could not launch $blogPost.link';
//          }
//        });
//  }

//  Widget getCardLists(BlogPost blogPost) {
//    return Padding(
//      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
//      child: InkWell(
//        child: Row(
//          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.only(left: 0.0, right: 10.0),
//              child: Container(
//                height: MediaQuery.of(context).size.width / 3.5,
//                width: MediaQuery.of(context).size.width / 3,
//                child: ClipRRect(
//                  borderRadius: BorderRadius.circular(8.0),
//                  child: Image.network(
//                    blogPost.imageURL,
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),
//            ),
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Text(
//                  blogPost.title,
//                  style: TextStyle(
//                    fontSize: 18,
//                    fontWeight: FontWeight.w900,
//                  ),
//                ),
//                SizedBox(height: 10.0),
//                Row(
//                  children: <Widget>[
//                    SizedBox(width: 6.0),
//                    Text(
//                      blogPost.tags,
//                      style: TextStyle(
//                        fontSize: 12,
//                        fontWeight: FontWeight.w300,
//                      ),
//                    ),
//                  ],
//                ),
//                SizedBox(height: 10.0),
//                Row(
//                  children: <Widget>[
//                    Text(
//                      blogPost.desc,
//                      softWrap: true,
//                      style: TextStyle(
//                        fontSize: 12,
//                        fontWeight: FontWeight.w300,
//                        color: Theme.of(context).primaryColor,
//                      ),
//                    ),
//                    SizedBox(width: 10.0),
//                  ],
//                ),
//                SizedBox(height: 10.0),
//              ],
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  Widget getBlogPostsCard(BlogPost blogPost) {
    // wrap everything in a purple container
    return InkWell(
        child: Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              //color: Colors.purple[900],
              color: Color.fromRGBO(45, 45, 45, 1),
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            // one column of image and another column of four rows
            child: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      blogPost.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                // this makes the column height hug its content
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // first row
                  Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: RichText(
                            text: TextSpan(
                              text: blogPost.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                          )
                      ),
                    ],
                  ),

                  // second row (single item)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 3.0,
                      horizontal: 0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: blogPost.tags,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.yellowAccent.withOpacity(0.5),
                        ),
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),

                  // third row
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 0,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: RichText(
                        text: TextSpan(
                          text: blogPost.desc,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),

                  // fourth row
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "READ MORE",
                          style: TextStyle(
//                          fontSize: 14,
//                          fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: true,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //        onTap: () async {
//          debugPrint(blogPost.link);
//          if (await canLaunch(blogPost.link)) {
//            await launch(blogPost.link, forceSafariVC: false);
//          } else {
//            throw 'Could not launch $blogPost.link';
//          }
//        });
            ])),
        onTap: () async {
          if (await canLaunch(blogPost.link)) {
            await launch(blogPost.link, forceSafariVC: false);
          } else {
            throw 'Could not launch $blogPost.link';
          }
        },
    );
  }

  void reloadBlogPosts(BuildContext context) {
    debugPrint("Reload Blog Posts");
    showRetrySnackBar(context);
    _getBlogPosts();
  }

  void showRetrySnackBar(BuildContext context) {
    final retrySnackBar = SnackBar(
        content: Text("Checking for latest Blogs and Links"),
        duration: new Duration(seconds: 5),
        action: SnackBarAction(
          label: "OKAY",
          onPressed: () => debugPrint("Reloading..."),
        ));

    Scaffold.of(context).showSnackBar(retrySnackBar);
  }
}
