import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart';
import 'package:mailing/Class/Class_database.dart';
import 'package:mailing/Class/Get_Photo.dart';
import 'package:mailing/Validate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:swipe_to/swipe_to.dart';
import '../Home_Page.dart';
import '../Login_Mailing.dart';
import '../Message_page.dart';

late bool checkadmin, endListOP, endListPP;
BoxShadow? boxShadowPP, boxShadowOP;
List<Messaging_PR> list_programPP = [];
List<Messaging_PR> list_programOP = [];

class List_program extends StatefulWidget {
  @override
  _List_progrmam_state createState() => _List_progrmam_state();

  List_program({this.index, this.onPress});

  final int? index;
  final Function? onPress;
}

class _List_progrmam_state extends State<List_program> {
  double WidthDevice = 0,
      HieghDevice = 0;

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

    endListOP =
    ((list_programOP.length > 5 ? length_list_program_OP : list_programOP
        .length) - 1 == widget.index) ? true : false;
    WidthDevice = MediaQuery
        .of(context)
        .size
        .width;
    HieghDevice = MediaQuery
        .of(context)
        .size
        .height;

    if (list_programOP.length > widget.index!) {
      return list_programOP.length > 0 ? SwipeTo(
          offsetDx: 1,
          animationDuration: Duration(milliseconds: 800),
          onLeftSwipe: checkadmin ? () {
            //end to start
            showDialog(
                context: context,
                builder: (context) =>
                    MyDialogeHome(
                        type: "D",
                        onPresed: () async {
                          if (checkadmin) {
                            if (await program_dataBase.Delete(
                                list_programOP[widget.index!]
                                    .getID
                                    .toString())) {
                              list_programOP.removeAt(widget.index!);
                              setState(() {
                                showtoast("Delete Seccessfully");
                              });
                            } else {
                              showtoast("Delete Problem");
                            }
                          }
                        }));
          } : () {},
          onRightSwipe: checkadmin ? () {
            //start to end
            showDialog(
                context: context,
                builder: (context) =>
                    MyDialogeHome(
                        type: "U",
                        onPresed: () {
                          if (checkadmin) {
                            checkubdate = true;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return message_page("P",
                                      list_programOP.elementAt(widget.index!));
                                }));
                          }
                        }));
          } : () {},
          rightSwipeWidget: checkadmin ? Container(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.edit_outlined,
                  size: 50,
                ),
              )) : SizedBox(),
          leftSwipeWidget: checkadmin ? Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.delete,
                size: 50,
              )) : SizedBox(),
          child: Column(children: [
            Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ]),
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
                          child: Validation.isValidnull(
                              list_programOP[widget.index!].getlistimage[0])
                              ? GestureDetector(
                              onTap: (){
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => show_photo(path: list_programOP[widget.index!].getlistimage[0].trim(), type: "N")));
                                });
                              },
                              child: CachedNetworkImage(
                            imageUrl: list_programOP[widget.index!]
                                .getlistimage[0].trim(),
                            imageBuilder: (context, imageProvider) =>
                                Container(
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
                          ))
                              : GestureDetector(
                              onTap: (){
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => show_photo(path: "", type: "")));
                                });
                              },
                              child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "images/Untitled.png"),
                                  fit: BoxFit.fill),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: null,
                          )))),
                  Container(
                      alignment: Alignment.topRight,
                      child: Container(
                          margin: EdgeInsets.only(right: 20, top: 15, left: 20),
                          height: HieghDevice / 8,
                          width: WidthDevice / 2,
                          child: Text(
                            list_programOP[widget.index!].getcontent,
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
                            children: list_programOP[widget.index!].getlistimage
                                .length > 1
                                ? List.generate(
                                list_programOP[widget.index!].getlistimage
                                    .length - 1,
                                    (index) =>
                                    show_photo_list(
                                        path: list_programOP[widget.index!]
                                            .getlistimage.elementAt(index + 1)
                                            .trim(),
                                        type: "N",
                                        index: index + 1))
                                : List.generate(
                                0,
                                    (index) =>
                                    show_photo_list(
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
                              onPressed: () async {
                                if (Validation.isValidnull(
                                    list_programOP[widget.index!].getlistimage[0])) {
                                  await shareFile();
                                } else {
                                  await share();
                                }
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 25,
                              )))),
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 50,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Text(
                                        "My Page Link : ${list_programOP[widget
                                            .index!].getlink}")),
                              ])))
                ]))
            ,
            if (endListOP)
              Container(
                height: (HieghDevice / 5.5) + 60,
              )
          ])) : Center(child: CircularProgressIndicator());
    } else {
      if (length_list_program_OP - 1 == widget.index!) {
        return Container(
          height: (HieghDevice / 5.5) + 60,
        );
      } else {
        return SizedBox();
      }
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: "Our Product",
        text: list_programOP[widget.index!].getcontent,
        linkUrl: list_programOP[widget.index!].getlink,
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> shareFile() async {
    final response = await get(Uri.parse(list_programOP[widget.index!].getlistimage[0]));
    final bytes = response.bodyBytes;
    final Directory? temp = await getExternalStorageDirectory();
    final File imageFile = File('${temp!.path}/Image.png');
    imageFile.writeAsBytesSync(bytes);

    await FlutterShare.shareFile(
      title: "Our Product",
      text: list_programOP[widget.index!].getcontent + "\n " + list_programOP[widget.index!].getlink,
      filePath: imageFile.path,
    );
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
  double WidthDevice = 0,
      HieghDevice = 0;

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery
        .of(context)
        .size
        .width;
    HieghDevice = MediaQuery
        .of(context)
        .size
        .height;

    return Row(children: [
      (widget.type == "N")
          ? GestureDetector(
          onTap: (){
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => show_photo(path: widget.path.trim(), type: "N")));
            });
          },
          child: Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.path.trim()),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 20)
              ])))
          : (widget.type == "D")
          ? GestureDetector(
          onTap: (){
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => show_photo(path: widget.path, type: "D")));
            });
          },
          child: Container(
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
                ])),))
          : GestureDetector(
        onTap: (){
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => show_photo(path: "", type: "")));
          });
        },
        child: Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/Untitled.png"),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 20)
              ]))),
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
  double WidthDevice = 0,
      HieghDevice = 0;

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

    endListPP =
    ((list_programPP.length > 5 ? length_list_program_PP : list_programPP
        .length) - 1 == widget.index) ? true : false;
    WidthDevice = MediaQuery
        .of(context)
        .size
        .width;
    HieghDevice = MediaQuery
        .of(context)
        .size
        .height;

    if (list_programPP.length > widget.index!) {
      return list_programPP.length > 0 ? SwipeTo(
          offsetDx: 1,
          animationDuration: Duration(milliseconds: 800),
          onLeftSwipe: checkadmin ? () {
            //end to start
            showDialog(
                context: context,
                builder: (context) =>
                    MyDialogeHome(
                        type: "D",
                        onPresed: () async {
                          if (checkadmin) {
                            if (await program_dataBase.Delete(
                                list_programPP[widget.index!]
                                    .getID
                                    .toString())) {
                              list_programPP.removeAt(widget.index!);
                              setState(() {
                                showtoast("Delete Seccessfully");
                              });
                            } else {
                              showtoast("Delete Problem");
                            }
                          }
                        }));
          } : () {},
          onRightSwipe: checkadmin ? () {
            //start to end
            showDialog(
                context: context,
                builder: (context) =>
                    MyDialogeHome(
                        type: "U",
                        onPresed: () {
                          if (checkadmin) {
                            checkubdate = true;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return message_page("P",
                                      list_programPP.elementAt(widget.index!));
                                }));
                          }
                        }));
          } : () {},
          rightSwipeWidget: checkadmin ? Container(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.edit_outlined,
                  size: 50,
                ),
              )) : SizedBox(),
          leftSwipeWidget: checkadmin ? Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.delete,
                size: 50,
              )) : SizedBox(),
          child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
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
                                  BoxShadow(color: Colors.black38,
                                      blurRadius: 20)
                                ],
                              ),
                              child: Validation.isValidnull(
                                  list_programPP[widget.index!].getlistimage[0])
                                  ? GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => show_photo(path: list_programPP[widget.index!]
                                                  .getlistimage[0], type: "N")));
                                    });
                                  },
                                  child: CachedNetworkImage(
                                imageUrl: list_programPP[widget.index!]
                                    .getlistimage[0],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                              )) : GestureDetector(
                              onTap: (){
                        setState(() {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => show_photo(path: "", type: "")));
                        });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "images/Untitled.png"),
                                fit: BoxFit.fill),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: null,
                        )))),
                      Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: 20, top: 210, left: 20),
                              height: 70,
                              width: WidthDevice,
                              child: Text(
                                list_programPP[widget.index!].getcontent,
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
                                      backgroundColor: MaterialStateProperty
                                          .all(
                                          Colors.lightBlueAccent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.zero,
                                                  bottomRight: Radius.circular(
                                                      20)),
                                              side: BorderSide(
                                                  color: Colors.black38,
                                                  width: 0.2)))),
                                  onPressed: () async {
                                    if (Validation.isValidnull(
                                        messaging[widget.index!].MessageLink)) {
                                      await shareFile();
                                    } else {
                                      await share();
                                    }
                                  },
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
                            child: Text(
                                "App Link : ${list_programPP[widget.index!]
                                    .getlink}")),
                      )
                    ])),
                if (endListPP)
                  Container(
                    height: (HieghDevice / 5.5) + 60,
                  )
              ])) : Center(child: CircularProgressIndicator());
    } else {
      if (length_list_program_PP - 1 == widget.index!) {
        return Container(
          height: (HieghDevice / 5.5) + 60,
        );
      } else {
        return SizedBox();
      }
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: "Partner Program",
        text: list_programPP[widget.index!].getcontent,
        linkUrl: list_programPP[widget.index!].getlink,
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> shareFile() async {
    final response = await get(Uri.parse(list_programPP[widget.index!].getlistimage[0]));
    final bytes = response.bodyBytes;
    final Directory? temp = await getExternalStorageDirectory();
    final File imageFile = File('${temp!.path}/Image.png');
    imageFile.writeAsBytesSync(bytes);

    await FlutterShare.shareFile(
      title: "Partner Program",
      text: list_programPP[widget.index!].getcontent + "\n " +list_programPP[widget.index!].getlink,
      filePath: imageFile.path,
    );
  }
}
