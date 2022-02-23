import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart';
import 'package:mailing/Class/Admob.dart';
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

late bool checkadmin,showsendmessage;
int lengthList = 5,length_list_program_OP = 5,length_list_program_PP = 5,length_list_notification = 5,count_notification_view = 0;
var page;
String pagecheck = "S";
List<double> he_wi = [50, 50, 70, 50, 50];
List<double> sizeicon = [30, 30, 50, 30, 30];
List<Messaging> messaging = [];
List<Notification_Message> notification_message = [];
List<int> countviewint = [];
Messsage_DataBase messsage_dataBase = Messsage_DataBase();
Program_DataBase program_dataBase = Program_DataBase();
Public_DataBase public_dataBase = Public_DataBase();
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

    notification_message = await public_dataBase.Select(email: member.Email);

    if(pagecheck == "S"||pagecheck == "SI") {
      try {
        messaging = await messsage_dataBase.Select();
      } catch (ex) {
        print(ex);
      }
      try{
        count_notification_view = 0;
        for(int i = 0 ; i <  notification_message.length;i++){
          if(notification_message[i].getNotifiState){
            count_notification_view++;
          }
        }
      }catch(ex){
        print(ex);
      }
      if (!checkadmin){
        countviewint = await countview.Select();
      }

      setState(() {
        if (messaging.length > 0)
          page =
              List.generate(
                  lengthList, (index) => List_messaging(message: index >= messaging.length ? Messaging() : messaging[index]));
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
    }else if(pagecheck == "PR"||pagecheck == "PP"){
      try {
        if(pagecheck == "PR") {
          list_programOP = await program_dataBase.Select(type:"1");
        }else{
          list_programPP = await program_dataBase.Select(type: "0");
        }
      } catch (ex) {
        print(ex);
      }
      setState(() {
        if (list_programOP.length > 0 && pagecheck == "PR")
          page =
              List.generate(
                  length_list_program_OP, (index) => List_program(messaging_pr: index >= list_programOP.length ? Messaging_PR() : list_programOP[index]));
        else if(list_programPP.length > 0 && pagecheck == "PP") page =
            List.generate(
                length_list_program_PP, (index) => List_partner(messaging_pp: index >= list_programPP.length ? Messaging_PR() : list_programPP[index]));
      });

      for (int i = 0; i < he_wi.length; i++) {
        if (i == 3) {
          he_wi[i] = 60;
          sizeicon[i] = 40;
        } else {
          he_wi[i] = 50;
          sizeicon[i] = 30;
        }
      }
    }
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    loadAd();

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
                      size: 70))),
                  Icon(Icons.wifi,size: 80,),
              Text('${getLang(context, "Check_Your_Internet")}'),

            ]));
        setState(() {
          print("Check Internet");
        });
      });
    });
    showAd();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        messaging.length > lengthList && pagecheck == "S") {
      setStatecalbackmessage();
    }else if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        list_programOP.length > length_list_program_OP && pagecheck == "PR") {
      setStatecalbackprogram();
    }else if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        list_programPP.length > length_list_program_PP && pagecheck == "PP") {
      setStatecalbackpartner();
    }else if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        notification_message.length > length_list_notification && pagecheck == "N") {
      setStatecalbacknotification();
    }
  }

  void setStatecalbackmessage() {
    if (mounted)
      setState(() {
        lengthList = lengthList + 5;
        page =
            List.generate(lengthList, (index) => List_messaging(message: index >= messaging.length ? Messaging() : messaging[index]));
      });
  }

  void setStatecalbackprogram() {
    if (mounted)
      setState(() {
        length_list_program_OP = length_list_program_OP + 5;
        page =
            List.generate(length_list_program_OP, (index) => List_program(messaging_pr: index >= list_programOP.length ? Messaging_PR() : list_programOP[index]));
      });
  }
  void setStatecalbackpartner() {
    if (mounted)
      setState(() {
        length_list_program_PP = length_list_program_PP + 5;
        page =
            List.generate(length_list_program_PP, (index) => List_partner(messaging_pp: index >= list_programPP.length ? Messaging_PR() : list_programPP[index]));
      });
  }
  void setStatecalbacknotification() {
    if (mounted)
      setState(() {
        length_list_notification = length_list_notification + 5;
        page =
            List.generate(length_list_notification, (index) => List_Notif(index: index));
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
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: HieghDevice / 12,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "${getLang(context, "Mailing")}",
                style: TextStyle(fontSize: HieghDevice / 30,color: Theme.of(context).textTheme.headline1!.color),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 40,),
            if (showsendmessage && pagecheck == "S")
              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).shadowColor,width: 0),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).shadowColor,
                            blurRadius: 10,
                            spreadRadius: 2),
                      ],
                      borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor),
                  height: HieghDevice / 18,
                  width: 100,
                  child: DropdownButton<String>(
                    hint: Text('${getLang(context, dropdownValue!)}',style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),),
                    icon: const Icon(Icons.filter_list_rounded),
                    elevation: 16,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        switch (newValue) {
                          case "View":
                            {
                              SortByView();
                              page = List.generate(lengthList,
                                      (index) => List_messaging(message: index >= messaging.length ? Messaging() : messaging[index]));
                              break;
                            }
                          case "Name":
                            {
                              SortByName();
                              page = List.generate(lengthList,
                                  (index) => List_messaging(message: index >= messaging.length ? Messaging() : messaging[index]));
                              break;
                            }
                          case "Price":
                            {
                              SortByPrice();
                              page = List.generate(lengthList,
                                  (index) => List_messaging(message: index >= messaging.length ? Messaging() : messaging[index]));
                              break;
                            }
                          default:
                            {
                              SortByDate();
                              page = List.generate(lengthList,
                                  (index) => List_messaging(message: index >= messaging.length ? Messaging() : messaging[index]));
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
                        ),
                      );
                    }).toList(),
                  )),
            SizedBox(width: 20,)
          ])
        ],
      ),
      body: Stack(children: [
        Container(
          color:Theme.of(context).primaryColor,
        ),
        Container(
          margin: pagecheck == "PR"||pagecheck == "PP" ? EdgeInsets.only(top: (HieghDevice / 17)+10):EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
     color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [BoxShadow(color:Theme.of(context).shadowColor ,blurRadius: 5)]
            ),
            height: HieghDevice,
            width: WidthDevice,
            child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: _hundgetdate,
                child: (page != null)
                    ? ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        scrollDirection: Axis.vertical,
                        children: page,
                  padding: EdgeInsetsDirectional.only(bottom: (HieghDevice / 5.5) + 60),
                      )
                    : Container(
                    color: Theme.of(context).cardColor,
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
                        clipShadows: [ClipShadow(color: Colors.white)],
                        child: new Container(
                          height: HieghDevice / 5.5,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).primaryColor,
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
                          color: Theme.of(context).cardColor,
                            border:
                                Border.all(color: Theme.of(context).shadowColor,width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5),
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5)
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
                        )),
                    Text(
                      '${getLang(context, "Setting")}',
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
                            color: Theme.of(context).cardColor,
                            border:
                                Border.all(color: Theme.of(context).shadowColor,width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5),
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5)
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
                        )),
                    Text(
                      '${getLang(context, "Profile")}',
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
                            color: Theme.of(context).cardColor,
                            border:
                                Border.all(color: Theme.of(context).shadowColor,width: 0.3),
                            borderRadius: BorderRadius.circular(70),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5),
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              pagecheck = "S";
                              showsendmessage = true;
                              page = List.generate(lengthList,
                                  (index) => List_messaging(message: index >= messaging.length ? Messaging() : messaging[index]));
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
                        )),
                    Text(
                      '${getLang(context, "Home")}',
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 12)) -
                            ((HieghDevice / 5.5) / 1.1)) -
                        he_wi[3]-5,
                    left: en_ar == "en" ? (WidthDevice / 1.3) - he_wi[3]-10 : (WidthDevice / 1.3) - he_wi[3]),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[3],
                        height: he_wi[3],
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border:
                                Border.all(color: Theme.of(context).shadowColor,width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5),
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: ()async {
                            pagecheck = "PR";
                            if(list_programOP.isEmpty) {
                              await _hundgetdate();
                            }

                            setState(() {
                              showsendmessage = checkadmin;
                              page = List.generate(
                                  list_programOP.length > 5 ? length_list_program_OP : list_programOP.length, (index) =>  List_program(messaging_pr: index >= list_programOP.length ? Messaging_PR() : list_programOP[index]));
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
                        )),
                    Text(
                      '${getLang(context, "Program")}',
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
                            color: Theme.of(context).cardColor,
                            border:
                                Border.all(color: Theme.of(context).shadowColor,width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5),
                              BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: ()async {
                            pagecheck = "N";
                            await _hundgetdate();
                            setState(() {
                              showsendmessage = checkadmin;
                              page = List.generate(
                                  notification_message.length > 5 ? length_list_notification : notification_message.length, (index) =>  List_Notif(index: index));
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
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 3, top: he_wi[4]),
                        child: Text(
                          '${getLang(context, "Notificat")}',
                        )),
                    notification_message.length > 0 && notification_message.length != count_notification_view ? Container(
                      margin: EdgeInsets.only(left: 38),
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(notification_message.length > 99 ? "99+": (notification_message.length - count_notification_view).toString(),style: TextStyle(fontSize: 11),),
                    ):SizedBox(),
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
                  color: Colors.lightGreen,
                  border: Border.all(color: Theme.of(context).shadowColor,width: 0.3),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 10, spreadRadius: 10)
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
                          return message_page("NI", new Notification_Message());
                        }));
                      }
                    });
                  },
                  icon: Icon(
                    Icons.message_outlined,
                    size: 35,
                  ))),
        if (pagecheck == "PR"||pagecheck == "PP") Container(
            color: Theme.of(context).cardColor,
            margin: EdgeInsets.only(),
            child: Row(
              children: [
                Container(
                  height: HieghDevice / 17,
                  width: WidthDevice / 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      pagecheck = "PR";
                      if(list_programOP.isEmpty) {
                        await _hundgetdate();
                      }
                      setState(() {
                        boxShadowOP = boxShadowOnClick;
                        boxShadowPP = boxShadowUpClick;
                        showsendmessage = true;
                        page = List.generate(
                            list_programOP.length > 5 ? length_list_program_OP : list_programOP.length, (index) =>  List_program(messaging_pr: index >= list_programOP.length ? Messaging_PR() : list_programOP[index]));
                      });
                    },
                    child: Container(
                        decoration:
                        BoxDecoration(boxShadow: [boxShadowOP!]),
                        child:
                        Text('${getLang(context, "Our_Product")}',style: TextStyle(color:Theme.of(context).textTheme.headline1!.color,),)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor,),
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
                    onPressed: () async {
                        pagecheck = "PP";
                        if(list_programPP.isEmpty) {
                          await _hundgetdate();
                        }
                      setState(() {
                        boxShadowPP = boxShadowOnClick;
                        boxShadowOP = boxShadowUpClick;
                        showsendmessage = true;
                        page = List.generate(
                           list_programPP.length > 5 ? length_list_program_PP : list_programPP.length, (index) =>  List_partner(messaging_pp: index >= list_programPP.length ? Messaging_PR() : list_programPP[index]));
                      });
                    },
                    child: Container(
                        decoration:
                        BoxDecoration(boxShadow: [boxShadowPP!]),
                        child: Text(
                            '${getLang(context, "Partner_Programs")}',style: TextStyle(color:Theme.of(context).textTheme.headline1!.color,),)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor,),
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
    }else if (pagecheck == "PR" || pagecheck == "PI" || pagecheck == "PP") {
      if(pagecheck == "PR"){
        length_list_program_OP = 5;
      }else if(pagecheck == "PP"){
        length_list_program_PP = 5;
      }
      try {
        await get_select_message();
      } catch (e) {
        print(e);
      }
    }
    else if (pagecheck == "N" || pagecheck == "NI") {
      length_list_notification = 5;
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

  List_messaging({Key? key, this.message, this.onPress}) : super(key: key);

  final Messaging? message;
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

      pay_or_not = ((widget.message!.MessagePrice) > 0) ? false : true;

      if (countviewint.contains(widget.message!.MessageID)) {
        pay_complate = true;
      }else{
        pay_complate = false;
      }

      return widget.message!.MessageID != 0
          ? SwipeTo(
        offsetDx: 1,
              animationDuration: Duration(milliseconds: 800),
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
                                      widget.message!
                                          .MessageID
                                          .toString())) {
                                    messaging.remove(widget.message!);
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
                            widget.message!.MessageLink)) {
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
                                        widget.message!);
                                  }));
                                }
                              }));
                    }
                  : () async {
                      if (pay_or_not) {
                        if (Validation.isValidnull(
                            widget.message!.MessageLink)) {
                          await shareFile();
                        } else {
                          await share();
                        }
                      }
                    },
              rightSwipeWidget: checkadmin
                  ? Container(
                  alignment: Alignment.center,
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 50,
                      ),
                    ))
                  : pay_or_not
                      ? Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          alignment: Alignment.center,
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
                  ?  Container(
                      margin: EdgeInsets.only(right: 20, left: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.delete,
                        size: 50,
                      ))
                  : pay_or_not
                      ? Container(
                          margin: EdgeInsets.only(right: 20, left: 20),
                          alignment: Alignment.center,
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
                        color: Theme.of(context).cardColor,
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
                          widget.message!.MessageDate,
                                style: TextStyle(
                                    fontSize: (HieghDevice / 180) *
                                        (WidthDevice / 180)),
                              )
                            : ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 3,
                                  sigmaY: 3,
                                ),
                                child: Text(
                                  widget.message!
                                      .MessageDate,
                                  style: TextStyle(
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
                                          color: Theme.of(context).shadowColor, blurRadius: 20)
                                    ],
                                  ),
                                  child: Validation.isValidnull(widget.message!
                                          .MessageLink)
                                      ? CachedNetworkImage(
                                          imageUrl: widget.message!
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
                                              color: Theme.of(context).shadowColor,
                                              blurRadius: 20)
                                        ],
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.message!
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
                                          widget.message!
                                              .MessageType)),
                                      style: TextStyle(
                                          color: (int.parse(widget.message!
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
                                            widget.message!
                                                .MessageType)),
                                        style: TextStyle(
                                            color: (int.parse(widget.message!
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
                            " " +
                                widget.message!
                                    .MessageSymbol +
                                " ",
                            style: TextStyle(
                                color: pay_complate
                                    ? Theme.of(context).textTheme.headline2!.color
                                    : Theme.of(context).textTheme.headline1!.color,
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
                                      "AT:" +
                                          widget.message!
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
                                            widget.message!
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
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    widget.message!
                                        .MessageCountView,
                                    style: TextStyle(color: Theme.of(context).textTheme.headline2!.color,fontSize: (HieghDevice / 180) *
                                        (WidthDevice / 180) +
                                        5),
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
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      widget.message!
                                          .MessageCountView,
                                      style: TextStyle(color: Theme.of(context).textTheme.headline2!.color,fontSize: (HieghDevice / 180) *
                                          (WidthDevice / 180) +
                                          5),
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
                                  widget.message!
                                      .MessageContent,
                                  style: TextStyle(color: Theme.of(context).textTheme.headline2!.color,fontSize: (HieghDevice / 180) *
                                      (WidthDevice / 180) +
                                      5),
                                  maxLines: 4,
                                ))
                            : ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                child: Container(
                                    height: 70,
                                    width: WidthDevice / 3,
                                    child: Text(
                                      widget.message!
                                          .MessageContent,
                                      style: TextStyle(color: Theme.of(context).textTheme.headline2!.color,fontSize: (HieghDevice / 180) *
                                          (WidthDevice / 180) +
                                          5),
                                      maxLines: 4,
                                    )),
                              ),
                      ),
                      Container(
                          width: WidthDevice,
                          margin:
                              EdgeInsets.only(left: WidthDevice / 10, top: 170),
                          child: pay_complate || checkadmin
                              ? Text(
                                  "SL : " +
                                      widget.message!
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
                                        widget.message!
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
                                            widget.message!
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
                                            widget.message!
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
                                              widget.message!
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
                                              widget.message!
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
                              list.add(widget.message!
                                  .MessageID
                                  .toString());
                              list.add("F");
                              if (await countview.Insert(list)) {
                                pay_complate = true;
                                setState(() {
                                  if(!countviewint.contains(widget.message!.MessageID)){
                                    countviewint.add(widget.message!.MessageID);
                                  }
                                  widget.message!.MessageCountView =
                                      countview.countview!;
                                });
                              }
                            }
                          },
                          child: pay_complate && !checkadmin
                              ? Icon(
                                  Icons.check_circle_outlined,
                                  color: Colors.green,
                                  size: 40,
                                )
                              : Text(
                                  (widget.message!
                                              .MessagePrice >
                                          0.0)
                                      ? '${getLang(context, "Pay")}' +
                                          " : ${widget.message!.MessagePrice}" +
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
                    ])))
              ]))
          : SizedBox();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: widget.message!.MessageSymbol,
        text: Message_type.values.elementAt(
                int.parse(widget.message!.MessageType)) +
            "   " +
            widget.message!.MessageSymbol +
            "   AT: " +
            widget.message!.MessageEntryPoint.toString() +
            "\n" +
            widget.message!.MessageContent +
            "\n" +
            "TD1 :" +
            widget.message!.Target1 +
            "   " +
            "TD2 :" +
            widget.message!.Target2 +
            "\n" +
            "SL :" +
            widget.message!.OrderStopLoss +
            "\n" +
            widget.message!.MessageDate +
            "\n",
        linkUrl: "https://www.youtube.com/",
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> shareFile() async {
    final response = await get(Uri.parse(widget.message!.MessageLink));
    final bytes = response.bodyBytes;
    final Directory? temp = await getExternalStorageDirectory();
    final File imageFile = File('${temp!.path}/tempImage.png');
    imageFile.writeAsBytesSync(bytes);

    await FlutterShare.shareFile(
      title: Message_type.values.elementAt(
              int.parse(widget.message!.MessageType)) +
          " " +
          widget.message!.MessageSymbol +
          " AT: " +
          widget.message!.MessageEntryPoint.toString(),
      text: widget.message!.MessageContent +
          "\n" +
          "TD1 :" +
          widget.message!.Target1 +
          " " +
          "TD2 :" +
          widget.message!.Target2 +
          "\n" +
          "SL :" +
          widget.message!.OrderStopLoss +
          "\n" +
          widget.message!.MessageDate +
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
      if (int.parse(messaging[i].MessageCountView) < int.parse(messaging[j].MessageCountView)) {
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
