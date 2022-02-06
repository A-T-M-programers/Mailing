import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailing/Class/Class_database.dart';
import '../Home_Page.dart';
import '../Message_page.dart';

late bool checkadmin, endList;
int lengthList = 5;
BoxShadow? boxShadowPP, boxShadowOP;

Messaging_PR? program = Messaging_PR();

class List_program extends StatefulWidget {
  @override
  _List_progrmam_state createState() => _List_progrmam_state();

  List_program({this.index, this.onPress});

  final int? index;
  final Function? onPress;
}

class _List_progrmam_state extends State<List_program> {
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkadmin = true;
  }

  @override
  Widget build(BuildContext context) {
    if (pagecheck == "OP") {
      boxShadowPP = boxShadowOnClick;
      boxShadowOP = boxShadowUpClick;
    } else if (pagecheck == "PR") {
      boxShadowOP = boxShadowOnClick;
      boxShadowPP = boxShadowUpClick;
    }

    endList = (lengthList == widget.index) ? true : false;
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return Column(children: [
          Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
              width: WidthDevice - 20,
              height: 350,
              child: Stack(children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Container(
                        height: (HieghDevice / 50) * (WidthDevice / 50),
                        width: (HieghDevice / 50) * (WidthDevice / 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 20)
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: program!.getlistimage[0].Image_Link,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ))),
                Container(
                    alignment: Alignment.topRight,
                    child: Container(
                        margin: EdgeInsets.only(right: 20, top: 15, left: 20),
                        height: HieghDevice / 8,
                        width: WidthDevice / 2,
                        child: Text(
                          "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                          style: TextStyle(color: Colors.black54),
                          maxLines: 5,
                        ))),
                Container(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(top: 40),
                        height: HieghDevice / 3,
                        width: WidthDevice,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              5,
                              (index) => show_photo_list(
                                  path: "", type: "", index: index)),
                        ))),
                Container(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        height: 50,
                        width: 50,
                        child: ElevatedButton.icon(
                            label: Text(""),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(5)),
                                elevation: MaterialStateProperty.all(5),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightBlueAccent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.zero,
                                            bottomRight: Radius.circular(20)),
                                        side: BorderSide(
                                            color: Colors.black38,
                                            width: 0.2)))),
                            onPressed: () => {},
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 25,
                            )))),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        margin: EdgeInsets.all(10),
                        height: 50,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text("App Store : www.example.com")),
                              Container(
                                  child: Text("Play Store : www.example.com")),
                            ])))
              ])),
          if (endList)
            Container(
              height: (HieghDevice / 5.5) + 60,
            )
        ]);
  }
}

class show_photo_list extends StatefulWidget {
  final String path, type;
  final int index;

  show_photo_list(
      {required this.path, required this.index, required this.type});

  @override
  show_photo_list_state createState() => show_photo_list_state();
}

class show_photo_list_state extends State<show_photo_list> {
  double WidthDevice = 0, HieghDevice = 0;

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return Row(children: [
      (widget.type == "N")
          ? Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.path),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 20)
              ]))
          : (widget.type == "D")
              ?Container(
          width: 100,
          height: 140,
          child:
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(widget.path)),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20)
                      ])),)
              : Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/Untitled.png"),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20)
                      ])),
      SizedBox(
        width: 20,
      )
    ]);
  }
}

class List_partner extends StatefulWidget {
  @override
  _List_Partner_state createState() => _List_Partner_state();

  List_partner({this.index, this.onPress});

  final int? index;
  final Function? onPress;
}

class _List_Partner_state extends State<List_partner> {
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkadmin = true;
  }

  @override
  Widget build(BuildContext context) {
    if (pagecheck == "OP") {
      boxShadowPP = boxShadowOnClick;
      boxShadowOP = boxShadowUpClick;
    } else if (pagecheck == "PR") {
      boxShadowOP = boxShadowOnClick;
      boxShadowPP = boxShadowUpClick;
    }

    endList = (lengthList == widget.index) ? true : false;
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
              width: WidthDevice - 20,
              height: 350,
              child: Stack(children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Container(
                        height: 200,
                        width: WidthDevice,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 20)
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: program!.getlistimage[0].Image_Link,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ))),
                Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: EdgeInsets.only(right: 20, top: 210, left: 20),
                        height: 70,
                        width: WidthDevice,
                        child: Text(
                          "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                          style: TextStyle(color: Colors.black54),
                          maxLines: 4,
                        ))),
                Container(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        height: 50,
                        width: 50,
                        child: ElevatedButton.icon(
                            label: Text(""),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(5)),
                                elevation: MaterialStateProperty.all(5),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightBlueAccent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.zero,
                                            bottomRight: Radius.circular(20)),
                                        side: BorderSide(
                                            color: Colors.black38,
                                            width: 0.2)))),
                            onPressed: () => {},
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 25,
                            )))),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        margin: EdgeInsets.all(10),
                        height: 50,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text("App Store : www.example.com")),
                              Container(
                                  child: Text("Play Store : www.example.com")),
                            ])))
              ])),
          if (endList)
            Container(
              height: (HieghDevice / 5.5) + 60,
            )
        ]);
  }
}
