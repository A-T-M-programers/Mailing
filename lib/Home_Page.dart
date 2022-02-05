import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart';
import 'package:mailing/Login_Mailing.dart';
import 'package:mailing/Pages_File/Notif_Page.dart';
import 'package:mailing/Pages_File/Profile_Page.dart';
import 'package:mailing/Pages_File/Program_Page.dart';
import 'package:mailing/Pages_File/Setting_Page.dart';
import 'package:mailing/Validate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipe_to/swipe_to.dart';

import 'Class/Class_database.dart';
import 'Message_page.dart';
import 'l10n/applocal.dart';
import 'main.dart';

Map<String, String> Message_type = {
  '0': 'Buy',
  '1': 'Buy Limit',
  '2': 'Buy Stop',
  '3': 'Sell',
  '4': 'Sell Limit',
  '5': 'Sell Stop'
};
ScrollController _controller = ScrollController();

late bool checkadmin, endList, showsendmessage;
int lengthList = 5;
var page;
String pagecheck = "S";
List<double> he_wi = [50, 50, 70, 50, 50];
List<double> sizeicon = [30, 30, 50, 30, 30];
List<Messaging> messaging = [];
List<int> countviewint = [];
Messsage_DataBase messsage_dataBase = Messsage_DataBase();
Contentviewinfo_DataBase countview = Contentviewinfo_DataBase();
Widget _dialogContent = CircularProgressIndicator();

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  home_page_state createState() => home_page_state();
}

class home_page_state extends State<home_page> {
  String? dropdownValue = "Date";
  double WidthDevice = 0, HieghDevice = 0;

  Future<void> get_select_message() async {
    try {
      messaging = await messsage_dataBase.Select();
    } catch (ex) {
      print(ex);
    }
    if (!checkadmin) countviewint = await countview.Select();

    setState(() {
      if (messaging.length > 0)
        page =
            List.generate(lengthList, (index) => List_messaging(index: index));
      else
        return;
    });

    for (int i = 0; i < he_wi.length; i++) {
      if (i == 2) {
        he_wi[i] = 60;
        sizeicon[i] = 40;
      } else {
        he_wi[i] = 50;
        sizeicon[i] = 30;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    get_select_message().whenComplete(() => this.setState(() {
          print("Complate");
        }));
    showsendmessage = true;
    _controller.addListener(_scrollListener);
    setState(() {
      Future.delayed(Duration(seconds: 10), // Duration to wait
          () {
        _dialogContent = Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 35),
                      child:
              IconButton(
                  onPressed: _hundgetdate,
                  icon: Icon(Icons.settings_backup_restore,
                      size: 70, color: Colors.black54))),
                  Icon(Icons.wifi,color: Colors.black45,size: 80,),
              Text('${getLang(context, "Check_Your_Internet")}'),

            ]));
        setState(() {
          print("Check Internet");
        });
      });
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        messaging.length > lengthList) {
      setStatecalback();
    }
  }

  void setStatecalback() {
    if (mounted)
      setState(() {
        lengthList = lengthList + 5;
        page =
            List.generate(lengthList, (index) => List_messaging(index: index));
      });
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

    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: HieghDevice / 12,
        backgroundColor: Color.fromARGB(500, 12, 0, 74),
        actions: [
          Stack(alignment: AlignmentDirectional.topCenter, children: [
            Container(
              margin: EdgeInsets.only(top: 0, right: WidthDevice / 4,left:WidthDevice / 4 ),
              child: Text(
                "${getLang(context, "Mailing")}",
                style: TextStyle(fontSize: HieghDevice / 18),
                textAlign: TextAlign.center,
              ),
            ),
            if (showsendmessage && pagecheck == "S")
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white24,
                            blurRadius: 20,
                            spreadRadius: 10),
                      ],
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10)),
                  height: HieghDevice / 18,
                  width: 100,
                  margin: EdgeInsets.only(
                      left: WidthDevice - 120, top: 4, right: 10),
                  child: DropdownButton<String>(
                    hint: Text('${getLang(context, dropdownValue!)}'),
                    icon: const Icon(Icons.filter_list_rounded),
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        switch (newValue) {
                          case "View":
                            {
                              break;
                            }
                          case "Name":
                            {
                              SortByName();
                              page = List.generate(lengthList,
                                  (index) => List_messaging(index: index));
                              break;
                            }
                          case "Price":
                            {
                              SortByPrice();
                              page = List.generate(lengthList,
                                  (index) => List_messaging(index: index));
                              break;
                            }
                          default:
                            {
                              SortByDate();
                              page = List.generate(lengthList,
                                  (index) => List_messaging(index: index));
                              break;
                            }
                        }
                      });
                    },
                    items: <String>["Date", "Name", "Price", "View"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          '${getLang(context, value)}',
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }).toList(),
                  )),
          ])
        ],
      ),
      body: Stack(children: [
        Container(
          margin: pagecheck == "PR"||pagecheck == "PP" ? EdgeInsets.only(top: HieghDevice / 17):EdgeInsets.only(top: 0),
            color: Color.fromARGB(500, 12, 0, 74),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white24,
                        blurRadius: 20,
                        spreadRadius: 10,
                        offset: Offset(40, 3)),
                    BoxShadow(color: Colors.white),
                    BoxShadow(color: Colors.white),
                    BoxShadow(color: Colors.white),
                    BoxShadow(color: Colors.white),
                    BoxShadow(color: Colors.white),
                    BoxShadow(color: Colors.white),
                    BoxShadow(color: Colors.white),
                  ],
                  border: Border.all(color: Colors.white, width: 10),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              width: WidthDevice,
              height: HieghDevice / 14,
              child: null,
            )),
        Container(
          margin: pagecheck == "PR"||pagecheck == "PP" ? EdgeInsets.only(top: HieghDevice / 17):EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            height: HieghDevice,
            width: WidthDevice,
            child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: _hundgetdate,
                child: (page != null)
                    ? ListView(
                        controller: _controller,
                        scrollDirection: Axis.vertical,
                        children: page,
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: HieghDevice / 3),
                        alignment: Alignment.center,
                        child: _dialogContent))),
        Stack(
          textDirection: TextDirection.ltr,
          children: [
            Container(
              child: Center(
                child: Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Arc(
                        arcType: ArcType.CONVEX,
                        edge: Edge.TOP,
                        height: HieghDevice / 6.5,
                        clipShadows: [ClipShadow(color: Colors.black)],
                        child: new Container(
                          height: HieghDevice / 5.5,
                          width: MediaQuery.of(context).size.width,
                          color: Color.fromARGB(200, 12, 0, 74),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                    top:HieghDevice > WidthDevice ? (HieghDevice - HieghDevice / 5.5) -
                        he_wi[0] : (HieghDevice - HieghDevice / 5.5) -
                        he_wi[0] - 15,
                    left: (WidthDevice / 5.3) - he_wi[0]),
                child: Column(
                  children: [
                    Container(
                        height: he_wi[0],
                        width: he_wi[0],
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.white, blurRadius: 5),
                              BoxShadow(color: Colors.white, blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              pagecheck = "set";
                              showsendmessage = false;
                              page =
                                  List.generate(1, (index) => setting_page());
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 0) {
                                  he_wi[i] = 60;
                                  sizeicon[i] = 40;
                                } else {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.settings_outlined,
                            size: sizeicon[0],
                          ),
                          color: Colors.black,
                        )),
                    Text(
                      '${getLang(context, "Setting")}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: HieghDevice > WidthDevice ? ((HieghDevice - (HieghDevice / 12)) -
                            ((HieghDevice / 5.5) / 1.16)) -
                        he_wi[1]-5 :((HieghDevice - (HieghDevice / 12)) -
                        ((HieghDevice / 5.5) / 1.16)) -
                        he_wi[1]-15,
                    left: en_ar == "er" ? (WidthDevice / 2.8) - he_wi[1]-10 : (WidthDevice / 2.8) - he_wi[1]-5),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[1],
                        height: he_wi[1],
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.white, blurRadius: 5),
                              BoxShadow(color: Colors.white, blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              pagecheck = "info";
                              showsendmessage = false;
                              page = List.generate(
                                  1,
                                  (index) =>
                                      Profile(member: member, type: pagecheck));
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 1) {
                                  he_wi[i] = 60;
                                  sizeicon[i] = 40;
                                } else {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.people_outline,
                            size: sizeicon[1],
                          ),
                          color: Colors.black,
                        )),
                    Text(
                      '${getLang(context, "Profile")}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                height: 90,
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 12)) -
                            ((HieghDevice / 5.5))) -
                        he_wi[2]-5,
                    left: (WidthDevice / 1.7) - he_wi[2]-18),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[2],
                        height: he_wi[2],
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 0.3),
                            borderRadius: BorderRadius.circular(70),
                            boxShadow: [
                              BoxShadow(color: Colors.white, blurRadius: 5),
                              BoxShadow(color: Colors.white, blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              pagecheck = "S";
                              showsendmessage = true;
                              page = List.generate(lengthList,
                                  (index) => List_messaging(index: index));
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 2) {
                                  he_wi[i] = 60;
                                  sizeicon[i] = 40;
                                } else {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.home_outlined,
                            size: sizeicon[2],
                          ),
                          color: Colors.black,
                        )),
                    Text(
                      '${getLang(context, "Home")}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 12)) -
                            ((HieghDevice / 5.5) / 1.1)) -
                        he_wi[3],
                    left: (WidthDevice / 1.3) - he_wi[3]),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[3],
                        height: he_wi[3],
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.white, blurRadius: 5),
                              BoxShadow(color: Colors.white, blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              pagecheck = "PR";
                              showsendmessage = true;
                              page = List.generate(
                                  5, (index) => List_program(index: index + 1));
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 3) {
                                  he_wi[i] = 60;
                                  sizeicon[i] = 40;
                                } else {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.filter_drama,
                            size: sizeicon[3],
                          ),
                          color: Colors.black,
                        )),
                    Text(
                      '${getLang(context, "Program")}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 10)) -
                            ((HieghDevice / 5.5) / 2)) -
                        he_wi[4],
                    left: (WidthDevice / 1.10) - he_wi[4]),
                child: Stack(
                  children: [
                    Container(
                        height: he_wi[4],
                        width: he_wi[4],
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.white, blurRadius: 5),
                              BoxShadow(color: Colors.white, blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              pagecheck = "N";
                              showsendmessage = true;
                              page = List.generate(
                                  5, (index) => List_Notif(index: index + 1));
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 4) {
                                  he_wi[i] = 60;
                                  sizeicon[i] = 40;
                                } else {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.notifications_active_outlined,
                            size: sizeicon[4],
                          ),
                          color: Colors.black,
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 3, top: he_wi[4]),
                        child: Text(
                          '${getLang(context, "Notificat")}',
                          style: TextStyle(color: Colors.white),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 38),
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text("3"),
                    ),
                  ],
                )),
          ],
        ),
        if (checkadmin && showsendmessage)
          Container(
              margin: EdgeInsets.only(
                  right: 10,
                  left: WidthDevice / 1.19,
                  top: (HieghDevice / 1.55) - (HieghDevice / 12)),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 0.3),
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, blurRadius: 10, spreadRadius: 10)
                  ]),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      checkubdate = false;
                      if (he_wi[2] == 60) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return message_page("SI", new Messaging());
                        }));
                      } else if (he_wi[3] == 60) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return message_page("PI", new Messaging_PR());
                        }));
                      } else if (he_wi[4] == 60) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return message_page("NI", new Messaging_PU());
                        }));
                      }
                    });
                  },
                  icon: Icon(
                    Icons.message_outlined,
                    color: Colors.black,
                    size: 35,
                  ))),
        if (pagecheck == "PR"||pagecheck == "PP") Container(
            margin: EdgeInsets.only(),
            child: Row(
              children: [
                Container(
                  height: HieghDevice / 17,
                  width: WidthDevice / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pagecheck = "PR";
                        boxShadowOP = boxShadowOnClick;
                        boxShadowPP = boxShadowUpClick;
                        showsendmessage = true;
                        page = List.generate(
                            5, (index) => List_program(index: index + 1));
                      });
                    },
                    child: Container(
                        decoration:
                        BoxDecoration(boxShadow: [boxShadowOP!]),
                        child:
                        Text('${getLang(context, "Our_Product")}')),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(500, 12, 0, 74),
                        ),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.zero)))),
                  ),
                ),
                Container(
                  height: HieghDevice / 17,
                  width: WidthDevice / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pagecheck = "PP";
                        boxShadowPP = boxShadowOnClick;
                        boxShadowOP = boxShadowUpClick;
                        showsendmessage = true;
                        page = List.generate(
                            5, (index) => List_partner(index: index + 1));
                      });
                    },
                    child: Container(
                        decoration:
                        BoxDecoration(boxShadow: [boxShadowPP!]),
                        child: Text(
                            '${getLang(context, "Partner_Programs")}')),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(500, 12, 0, 74),
                        ),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.zero)))),
                  ),
                )
              ],
            )) else SizedBox() ,
      ]),
    ));
  }

  Future<void> _hundgetdate() async {
    if (pagecheck == "S" || pagecheck == "SI") {
      lengthList = 5;
      try {
        await get_select_message();
      } catch (e) {
        print(e);
      }
    }
  }
}

class List_messaging extends StatefulWidget {
  @override
  _List_messaging createState() => _List_messaging();

  List_messaging({Key? key, this.index, this.onPress}) : super(key: key);

  final int? index;
  final Function? onPress;
}

class _List_messaging extends State<List_messaging> {
  double WidthDevice = 0, HieghDevice = 0;
  bool pay_or_not = false, pay_complate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    if (messaging.length > widget.index!) {
      endList = ((lengthList - 1) == widget.index) ? true : false;
      pay_or_not = ((messaging[widget.index!].MessagePrice) > 0) ? false : true;
      for (int i = 0; i < countviewint.length; i++) {
        if (messaging[widget.index!].MessageID == countviewint[i]) {
          pay_complate = true;
          break;
        }
      }

      return messaging.length > 0
          ? SwipeTo(
              animationDuration: Duration(milliseconds: 500),
              onLeftSwipe: checkadmin
                  ? () {
                      //end to start
                      showDialog(
                          context: context,
                          builder: (context) => MyDialogeHome(
                              type: "D",
                              onPresed: () async {
                                if (checkadmin) {
                                  if (await messsage_dataBase.Delete(
                                      messaging[widget.index!]
                                          .MessageID
                                          .toString())) {
                                    messaging.removeAt(widget.index!);
                                    setState(() {
                                      showtoast("Delete Seccessfully");
                                    });
                                  } else {
                                    showtoast("Delete Problem");
                                  }
                                }
                              }));
                    }
                  : () async {
                      if (pay_or_not) {
                        if (Validation.isValidnull(
                            messaging[widget.index!].MessageLink)) {
                          await shareFile();
                        } else {
                          await share();
                        }
                      }
                    },
              onRightSwipe: checkadmin
                  ? () {
                      //start to end
                      showDialog(
                          context: context,
                          builder: (context) => MyDialogeHome(
                              type: "U",
                              onPresed: () {
                                if (checkadmin) {
                                  checkubdate = true;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return message_page("S",
                                        messaging.elementAt(widget.index!));
                                  }));
                                }
                              }));
                    }
                  : () async {
                      if (pay_or_not) {
                        if (Validation.isValidnull(
                            messaging[widget.index!].MessageLink)) {
                          await shareFile();
                        } else {
                          await share();
                        }
                      }
                    },
              rightSwipeWidget: checkadmin
                  ? Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(200, 201, 133, 0),
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 50,
                      ),
                    )
                  : pay_or_not
                      ? Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.reply,
                            size: 50,
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      : SizedBox(),
              leftSwipeWidget: checkadmin
                  ? Container(
                      margin: EdgeInsets.only(right: 20, left: 20),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.delete,
                        size: 50,
                      ))
                  : pay_or_not
                      ? Container(
                          margin: EdgeInsets.only(right: 20, left: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.reply,
                            size: 50,
                          ))
                      : SizedBox(),
              child: Column(children: [
                Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    width: WidthDevice - 10,
                    height: 200,
                    child: Center(
                        //form message in list
                        child: Stack(children: [
                      //this feild the date
                      Container(
                        margin: EdgeInsets.only(left: WidthDevice / 9, top: 5),
                        alignment: Alignment.topLeft,
                        child: pay_complate || checkadmin
                            ? Text(
                                messaging.elementAt(widget.index!).MessageDate,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: (HieghDevice / 180) *
                                        (WidthDevice / 180)),
                              )
                            : ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 3,
                                  sigmaY: 3,
                                ),
                                child: Text(
                                  messaging
                                      .elementAt(widget.index!)
                                      .MessageDate,
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: (HieghDevice / 180) *
                                          (WidthDevice / 180)),
                                )),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: pay_complate || checkadmin
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: WidthDevice / 18, top: 25),
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black38, blurRadius: 20)
                                    ],
                                  ),
                                  child: Validation.isValidnull(messaging
                                          .elementAt(widget.index!)
                                          .MessageLink)
                                      ? CachedNetworkImage(
                                          imageUrl: messaging
                                              .elementAt(widget.index!)
                                              .MessageLink,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "images/Untitled.png"),
                                                fit: BoxFit.fill),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: null,
                                        ))
                              : ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaY: 5,
                                    sigmaX: 5,
                                  ),
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: WidthDevice / 18, top: 25),
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 20)
                                        ],
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: messaging
                                            .elementAt(widget.index!)
                                            .MessageLink,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      )),
                                )),
                      Container(
                        margin:
                            EdgeInsets.only(left: WidthDevice / 2.6, top: 10),
                        child: Row(textDirection: TextDirection.ltr, children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 2),
                              child: pay_complate || checkadmin
                                  ? Text(
                                      Message_type.values.elementAt(int.parse(
                                          messaging
                                              .elementAt(widget.index!)
                                              .MessageType)),
                                      style: TextStyle(
                                          color: (int.parse(messaging
                                                      .elementAt(widget.index!)
                                                      .MessageType) <
                                                  3)
                                              ? Colors.blue
                                              : Colors.redAccent,
                                          fontSize: (HieghDevice / 180) *
                                                  (WidthDevice / 180) +
                                              5),
                                    )
                                  : ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Text(
                                        Message_type.values.elementAt(int.parse(
                                            messaging
                                                .elementAt(widget.index!)
                                                .MessageType)),
                                        style: TextStyle(
                                            color: (int.parse(messaging
                                                        .elementAt(
                                                            widget.index!)
                                                        .MessageType) <
                                                    3)
                                                ? Colors.blue
                                                : Colors.redAccent,
                                            fontSize: (HieghDevice / 180) *
                                                    (WidthDevice / 180) +
                                                5),
                                      ),
                                    )),
                          Container(
                              child: Text(
                            "  " +
                                messaging
                                    .elementAt(widget.index!)
                                    .MessageSymbol +
                                "  ",
                            style: TextStyle(
                                color: pay_complate
                                    ? Colors.black54
                                    : Colors.black,
                                fontSize:
                                    (HieghDevice / 180) * (WidthDevice / 180) +
                                        5,
                                fontWeight: pay_complate
                                    ? FontWeight.normal
                                    : FontWeight.bold),
                          )),
                          Container(
                              child: pay_complate || checkadmin
                                  ? Text(
                                      "AT: " +
                                          messaging
                                              .elementAt(widget.index!)
                                              .MessageEntryPoint
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: (HieghDevice / 180) *
                                                  (WidthDevice / 180) +
                                              5),
                                    )
                                  : ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                          sigmaY: 3, sigmaX: 3),
                                      child: Text(
                                        "AT: " +
                                            messaging
                                                .elementAt(widget.index!)
                                                .MessageEntryPoint
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: (HieghDevice / 180) *
                                                    (WidthDevice / 180) +
                                                5),
                                      ),
                                    ))
                        ]),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: WidthDevice - 85, top: 65),
                        child: pay_complate || checkadmin
                            ? Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    messaging
                                        .elementAt(widget.index!)
                                        .MessageCountView,
                                    style: TextStyle(color: Colors.black54),
                                  )
                                ],
                              )
                            : ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Icon(
                                      Icons.visibility_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      messaging
                                          .elementAt(widget.index!)
                                          .MessageCountView,
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        height: 70,
                        margin:
                            EdgeInsets.only(top: 50, left: WidthDevice / 2.4),
                        child: pay_complate || checkadmin
                            ? Container(
                                height: 70,
                                width: WidthDevice / 3,
                                child: Text(
                                  messaging
                                      .elementAt(widget.index!)
                                      .MessageContent,
                                  style: TextStyle(color: Colors.black38),
                                  maxLines: 4,
                                ))
                            : ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                child: Container(
                                    height: 70,
                                    width: WidthDevice / 3,
                                    child: Text(
                                      messaging
                                          .elementAt(widget.index!)
                                          .MessageContent,
                                      style: TextStyle(color: Colors.black38),
                                      maxLines: 4,
                                    )),
                              ),
                      ),
                      Container(
                          width: WidthDevice,
                          margin:
                              EdgeInsets.only(left: WidthDevice / 10, top: 170),
                          child: pay_or_not || checkadmin
                              ? Text(
                                  "SL : " +
                                      messaging
                                          .elementAt(widget.index!)
                                          .OrderStopLoss,
                                  style: TextStyle(
                                      color: Color.fromARGB(500, 200, 10, 10),
                                      fontSize: (HieghDevice / 180) *
                                              (WidthDevice / 180) +
                                          5),
                                  textDirection: TextDirection.ltr,
                                )
                              : ImageFiltered(
                                  imageFilter:
                                      ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                  child: Text(
                                    "SL : " +
                                        messaging
                                            .elementAt(widget.index!)
                                            .OrderStopLoss,
                                    style: TextStyle(
                                        color: Color.fromARGB(500, 200, 10, 10),
                                        fontSize: (HieghDevice / 180) *
                                                (WidthDevice / 180) +
                                            5),
                                    textDirection: TextDirection.ltr,
                                  ),
                                )),
                      Container(
                        margin:
                            EdgeInsets.only(left: WidthDevice / 2.3, top: 135),
                        child: pay_complate || checkadmin
                            ? Column(
                                textDirection: TextDirection.ltr,
                                children: [
                                  Container(
                                      width: WidthDevice,
                                      child: Text(
                                        "TD1 : " +
                                            messaging
                                                .elementAt(widget.index!)
                                                .Target1,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: (HieghDevice / 180) *
                                                    (WidthDevice / 180) +
                                                5),
                                        textDirection: TextDirection.ltr,
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      width: WidthDevice,
                                      child: Text(
                                        "TD2 : " +
                                            messaging
                                                .elementAt(widget.index!)
                                                .Target2,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: (HieghDevice / 180) *
                                                    (WidthDevice / 180) +
                                                5),
                                        textDirection: TextDirection.ltr,
                                      ))
                                ],
                              )
                            : ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                                child: Column(
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Container(
                                        width: WidthDevice,
                                        child: Text(
                                          "TD1 : " +
                                              messaging
                                                  .elementAt(widget.index!)
                                                  .Target1,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: (HieghDevice / 180) *
                                                      (WidthDevice / 180) +
                                                  5),
                                          textDirection: TextDirection.ltr,
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        width: WidthDevice,
                                        child: Text(
                                          "TD2 : " +
                                              messaging
                                                  .elementAt(widget.index!)
                                                  .Target2,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: (HieghDevice / 180) *
                                                      (WidthDevice / 180) +
                                                  5),
                                          textDirection: TextDirection.ltr,
                                        ))
                                  ],
                                ),
                              ),
                      ),
                      Container(
                        width: 85,
                        height: 60,
                        margin:
                            EdgeInsets.only(top: 140, left: WidthDevice - 95),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(member.getEmail == "admin@gmail.com"){
                              showtoast(getLang(context, "Your_Admin" ));
                              return;
                            }
                            if (pay_or_not && !pay_complate) {
                              List<String> list = [];
                              list.add(member.getEmail);
                              list.add(messaging[widget.index!]
                                  .MessageID
                                  .toString());
                              list.add("F");
                              if (await countview.Insert(list)) {
                                setState(() {
                                  messaging[widget.index!].MessageCountView =
                                      countview.countview!;
                                  pay_complate = true;
                                });
                              }
                            }
                          },
                          child: pay_complate
                              ? Icon(
                                  Icons.check_circle_outlined,
                                  color: Colors.green,
                                  size: 40,
                                )
                              : Text(
                                  (messaging
                                              .elementAt(widget.index!)
                                              .MessagePrice >
                                          0.0)
                                      ? '${getLang(context, "Pay")}' +
                                          " : ${messaging.elementAt(widget.index!).MessagePrice}" +
                                          r"$"
                                      : "Free",
                                  style: TextStyle(color: Colors.black38),
                                  textDirection: TextDirection.ltr,
                                ),
                          style: ButtonStyle(
                              enableFeedback: !pay_complate,
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(5)),
                              elevation: MaterialStateProperty.all(20),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.lightBlueAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.zero,
                                          bottomRight: Radius.circular(40)),
                                      side: BorderSide(
                                          color: Colors.black38, width: 0.2)))),
                        ),
                      ),
                    ]))),
                if (endList)
                  Container(
                    height: (HieghDevice / 5.5) + 60,
                  )
              ]))
          : Center(child: CircularProgressIndicator());
    } else {
      if (lengthList - 1 == widget.index!) {
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
        title: messaging[widget.index!].MessageSymbol,
        text: Message_type.values.elementAt(
                int.parse(messaging.elementAt(widget.index!).MessageType)) +
            "   " +
            messaging[widget.index!].MessageSymbol +
            "   AT: " +
            messaging[widget.index!].MessageEntryPoint.toString() +
            "\n" +
            messaging[widget.index!].MessageContent +
            "\n" +
            "TD1 :" +
            messaging[widget.index!].Target1 +
            "   " +
            "TD2 :" +
            messaging[widget.index!].Target2 +
            "\n" +
            "SL :" +
            messaging[widget.index!].OrderStopLoss +
            "\n" +
            messaging[widget.index!].MessageDate +
            "\n",
        linkUrl: "https://www.youtube.com/",
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> shareFile() async {
    final response = await get(Uri.parse(messaging[widget.index!].MessageLink));
    final bytes = response.bodyBytes;
    final Directory? temp = await getExternalStorageDirectory();
    final File imageFile = File('${temp!.path}/tempImage.png');
    imageFile.writeAsBytesSync(bytes);

    await FlutterShare.shareFile(
      title: Message_type.values.elementAt(
              int.parse(messaging.elementAt(widget.index!).MessageType)) +
          " " +
          messaging[widget.index!].MessageSymbol +
          " AT: " +
          messaging[widget.index!].MessageEntryPoint.toString(),
      text: messaging[widget.index!].MessageContent +
          "\n" +
          "TD1 :" +
          messaging[widget.index!].Target1 +
          " " +
          "TD2 :" +
          messaging[widget.index!].Target2 +
          "\n" +
          "SL :" +
          messaging[widget.index!].OrderStopLoss +
          "\n" +
          messaging[widget.index!].MessageDate +
          "\n" +
          "https://www.youtube.com/",
      filePath: imageFile.path,
    );
  }
}

void SortByDate() {
  for (int i = 0; i < messaging.length; i++) {
    for (int j = i + 1; j < messaging.length; j++) {
      if (DateTime.parse(messaging[i].MessageDate)
          .isBefore(DateTime.parse(messaging[j].MessageDate))) {
        Messaging item = messaging[i];
        messaging[i] = messaging[j];
        messaging[j] = item;
      }
    }
  }
}

void SortByView() {
  for (int i = 0; i < messaging.length; i++) {
    for (int j = i + 1; j < messaging.length; j++) {
      if (DateTime.parse(messaging[i].MessageDate)
          .isBefore(DateTime.parse(messaging[j].MessageDate))) {
        Messaging item = messaging[i];
        messaging[i] = messaging[j];
        messaging[j] = item;
      }
    }
  }
}

void SortByName() {
  for (int i = 0; i < messaging.length; i++) {
    for (int j = i + 1; j < messaging.length; j++) {
      if (messaging[i].MessageSymbol.compareTo(messaging[j].MessageSymbol) >
          0) {
        Messaging item = messaging[i];
        messaging[i] = messaging[j];
        messaging[j] = item;
      }
    }
  }
}

void SortByPrice() {
  for (int i = 0; i < messaging.length; i++) {
    for (int j = i + 1; j < messaging.length; j++) {
      if (messaging[i].MessagePrice < messaging[j].MessagePrice) {
        Messaging item = messaging[i];
        messaging[i] = messaging[j];
        messaging[j] = item;
      }
    }
  }
}

class MyDialogeHome extends StatefulWidget {
  @override
  MyDialogeHomeState createState() => MyDialogeHomeState();

  MyDialogeHome({required this.type, required this.onPresed});

  late final String type;
  late final Function onPresed;
}

class MyDialogeHomeState extends State<MyDialogeHome> {
  String? ubd_or_del;

  @override
  Widget build(BuildContext context) {
    if (widget.type == "D") {
      ubd_or_del = "Delete";
    } else {
      ubd_or_del = "Ubdate";
    }
    return AlertDialog(
        scrollable: true,
        title: Text(ubd_or_del!),
        content: StatefulBuilder(builder: (context, setState) {
          return Column(
              // Then, the content of your dialog.
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      widget.onPresed();
                    },
                    child: const Text('OK'),
                  )
                ]),
              ]);
        }));
  }
}
