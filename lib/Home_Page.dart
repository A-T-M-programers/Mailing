import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:mailing/Class/Admob.dart';
import 'package:mailing/Class/Get_Photo.dart';
import 'package:mailing/Class/Methods_Pay.dart';
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
import 'Pages_File/About.dart';
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

late bool checkadmin, showsendmessage;
int lengthList = 5,
    length_list_program_OP = 5,
    length_list_program_PP = 5,
    length_list_notification = 5,
    count_notification_view = 0;
late List<Widget> page;
String pagecheck = "S";
List<double> he_wi = [40, 40, 50, 40, 40, 40];
List<double> sizeicon = [25, 25, 30, 25, 25, 25];
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
    page = [];
    try {
      notification_message = await public_dataBase.Select(email: member.Email);
      notification_message.removeWhere((element) => element.type != "N");
      notification_message = notification_message.reversed.toList();
    } on SocketException catch (_) {
      showtoast("Check Internet");
    }
    if (pagecheck == "S" || pagecheck == "SI") {
      try {
        messaging = await messsage_dataBase.Select();
        messaging = messaging.reversed.toList();
      } catch (ex) {
        print(ex);
      }
      try {
        count_notification_view = 0;
        for (int i = 0; i < notification_message.length; i++) {
          if (notification_message[i].getNotifiState) {
            count_notification_view++;
          }
        }
      } catch (ex) {
        print(ex);
      }
      if (!checkadmin) {
        try {
          countviewint = await countview.Select();
        } on SocketException catch (_) {
          showtoast("Check Internet");
        }
      }

      setState(() {
        if (messaging.length > 0) {
          SortByDateM_N(0, 0);
        } else
          return;
      });

      for (int i = 0; i < he_wi.length; i++) {
        if (i == 2) {
          he_wi[i] = 50;
          sizeicon[i] = 30;
        } else {
          he_wi[i] = 40;
          sizeicon[i] = 25;
        }
      }
    } else if (pagecheck == "PR" || pagecheck == "PP") {
      try {
        if (pagecheck == "PR") {
          list_programOP = await program_dataBase.Select(type: "1");
        } else {
          list_programPP = await program_dataBase.Select(type: "0");
        }
      } catch (ex) {
        print(ex);
      }
      setState(() {
        if (list_programOP.length > 0 && pagecheck == "PR")
          page = List.generate(
              length_list_program_OP,
              (index) => List_program(
                  messaging_pr: index >= list_programOP.length
                      ? Messaging_PR()
                      : list_programOP[index]));
        else if (list_programPP.length > 0 && pagecheck == "PP")
          page = List.generate(
              length_list_program_PP,
              (index) => List_partner(
                  messaging_pp: index >= list_programPP.length
                      ? Messaging_PR()
                      : list_programPP[index]));
      });

      for (int i = 0; i < he_wi.length; i++) {
        if (i == 3) {
          he_wi[i] = 50;
          sizeicon[i] = 30;
        } else {
          he_wi[i] = 40;
          sizeicon[i] = 25;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    loadAdBannerAd();
    get_select_message().whenComplete(() => this.setState(() {
          print("Complate");
        }));
    showsendmessage = true;
    _controller.addListener(_scrollListener);
    setState(() {
      Future.delayed(Duration(seconds: 10), // Duration to wait
          () async {
        _dialogContent = Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Container(
                  margin: EdgeInsets.only(right: 35),
                  child: IconButton(
                      onPressed: _hundgetdate,
                      icon: Icon(Icons.settings_backup_restore, size: 70))),
              Icon(
                Icons.wifi,
                size: 80,
              ),
              Text('${getLang(context, "Check_Your_Internet")}'),
            ]));
        setState(() {
          print("Check Internet");
        });
      });
    });
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        messaging.length + notification_message.length > lengthList &&
        pagecheck == "S") {
      setStatecalbackmessage();
    } else if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        list_programOP.length > length_list_program_OP &&
        pagecheck == "PR") {
      setStatecalbackprogram();
    } else if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        list_programPP.length > length_list_program_PP &&
        pagecheck == "PP") {
      setStatecalbackpartner();
    }
  }

  void setStatecalbackmessage() {
    if (mounted)
      setState(() {
        page = [];
        lengthList = lengthList + 5;
        SortByDateM_N(0, 0);
      });
  }

  void setStatecalbackprogram() {
    if (mounted)
      setState(() {
        length_list_program_OP = length_list_program_OP + 5;
        page = List.generate(
            length_list_program_OP,
            (index) => List_program(
                messaging_pr: index >= list_programOP.length
                    ? Messaging_PR()
                    : list_programOP[index]));
      });
  }

  void setStatecalbackpartner() {
    if (mounted)
      setState(() {
        length_list_program_PP = length_list_program_PP + 5;
        page = List.generate(
            length_list_program_PP,
            (index) => List_partner(
                messaging_pp: index >= list_programPP.length
                    ? Messaging_PR()
                    : list_programPP[index]));
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
        title: Text(getLang(context, "Mailing")),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: HieghDevice / 30,
            color: Theme.of(context).textTheme.headline1!.color),
        actions: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                ),
                if (showsendmessage && pagecheck == "S")
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).shadowColor, width: 0),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 10,
                                spreadRadius: 2),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor),
                      height: HieghDevice / 18,
                      width: 100,
                      child: DropdownButton<String>(
                        hint: Text(
                          '${getLang(context, dropdownValue!)}',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        ),
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
                                  page = List.generate(
                                      lengthList,
                                      (index) => List_messaging(
                                          message: index >= messaging.length
                                              ? Messaging()
                                              : messaging[index]));
                                  break;
                                }
                              case "Name":
                                {
                                  SortByName();
                                  page = List.generate(
                                      lengthList,
                                      (index) => List_messaging(
                                          message: index >= messaging.length
                                              ? Messaging()
                                              : messaging[index]));
                                  break;
                                }
                              case "Price":
                                {
                                  SortByPrice();
                                  page = List.generate(
                                      lengthList,
                                      (index) => List_messaging(
                                          message: index >= messaging.length
                                              ? Messaging()
                                              : messaging[index]));
                                  break;
                                }
                              default:
                                {
                                  setState(() {
                                    page = [];
                                    SortByDateM_N(0, 0);
                                  });
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
                SizedBox(
                  width: 20,
                )
              ])
        ],
      ),
      body: Stack(children: [
        Container(
            margin: !checkadmin
                ? EdgeInsets.only(
                    top: bannerAd == null
                        ? 10
                        : bannerAd!.size.height.toDouble() + 10)
                : EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5)
                ]),
            height: HieghDevice,
            width: WidthDevice,
            child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: _hundgetdate,
                child: (page.isEmpty)
                    ? Container(
                        color: Theme.of(context).cardColor,
                        margin: EdgeInsets.only(bottom: HieghDevice / 3),
                        alignment: Alignment.center,
                        child: _dialogContent)
                    : ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        scrollDirection: Axis.vertical,
                        children: page,
                        padding: EdgeInsetsDirectional.only(
                            bottom: (HieghDevice / 5.5) + 60),
                      ))),
        !checkadmin && bannerAd != null
            ? Container(
                child: AdWidget(
                  ad: bannerAd!,
                ),
                width: WidthDevice,
                height: bannerAd!.size.height.toDouble(),
                alignment: Alignment.topCenter,
                color: Theme.of(context).primaryColor,
              )
            : SizedBox(),
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
                    top: HieghDevice > WidthDevice
                        ? (HieghDevice - HieghDevice / 5.5) - he_wi[0] - 5
                        : (HieghDevice - HieghDevice / 5.5) - he_wi[0] - 10,
                    left: HieghDevice > WidthDevice
                        ? (WidthDevice / 5.3) - he_wi[0] - 10
                        : (WidthDevice / 5.3) - he_wi[0] - 30),
                child: Column(
                  children: [
                    Container(
                        height: he_wi[5],
                        width: he_wi[5],
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            if (!checkadmin) {
                              loadAdInterstitialAd();
                              showAdInterstitialAd();
                            }
                            setState(() {
                              showsendmessage = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          about(typepage: pagecheck)));
                              pagecheck = "abo";
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 5) {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                } else {
                                  he_wi[i] = 40;
                                  sizeicon[i] = 25;
                                }
                              }
                            });
                          },
                          icon: ImageIcon(
                            AssetImage("images/about.png"),
                            size: sizeicon[5],
                          ),
                        )),
                    Text(
                      '${getLang(context, "about_title")}',
                    )
                  ],
                )),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                    top: HieghDevice > WidthDevice
                        ? (HieghDevice - HieghDevice / 5.5) - he_wi[0] - 40
                        : (HieghDevice - HieghDevice / 5.5) - he_wi[0] - 25,
                    left: (WidthDevice / 5.3) - he_wi[0] + 40),
                child: Column(
                  children: [
                    Container(
                        height: he_wi[0],
                        width: he_wi[0],
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            if (!checkadmin) {
                              loadAdInterstitialAd();
                              showAdInterstitialAd();
                            }
                            setState(() {
                              pagecheck = "set";
                              showsendmessage = false;
                              page =
                                  List.generate(1, (index) => setting_page());
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 0) {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                } else {
                                  he_wi[i] = 40;
                                  sizeicon[i] = 25;
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
                    top: HieghDevice > WidthDevice
                        ? ((HieghDevice - (HieghDevice / 12)) -
                                ((HieghDevice / 5.5) / 1.16)) -
                            he_wi[1] -
                            20
                        : ((HieghDevice - (HieghDevice / 12)) -
                                ((HieghDevice / 5.5) / 1.16)) -
                            he_wi[1] -
                            15,
                    left: en_ar == "en"
                        ? (WidthDevice / 2.8) - he_wi[1] + 30
                        : (WidthDevice / 2.8) - he_wi[1] + 15),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[1],
                        height: he_wi[1],
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            if (!checkadmin) {
                              loadAdInterstitialAd();
                              showAdInterstitialAd();
                            }
                            setState(() {
                              pagecheck = "info";
                              showsendmessage = false;
                              page = List.generate(
                                  1,
                                  (index) =>
                                      Profile(member: member, type: pagecheck));
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 1) {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                } else {
                                  he_wi[i] = 40;
                                  sizeicon[i] = 25;
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
                        he_wi[2] -
                        5,
                    left: (WidthDevice / 1.7) - he_wi[2]),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[2],
                        height: he_wi[2],
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 0.3),
                            borderRadius: BorderRadius.circular(70),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () {
                            if (!checkadmin) {
                              loadAdInterstitialAd();
                              showAdInterstitialAd();
                            }
                            page = [];
                            SortByDateM_N(0, 0);
                            setState(() {
                              pagecheck = "S";
                              showsendmessage = true;
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 2) {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                } else {
                                  he_wi[i] = 40;
                                  sizeicon[i] = 25;
                                }
                              }
                            });
                          },
                          icon: ImageIcon(
                            AssetImage("images/signals.png"),
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
                        he_wi[3],
                    left: en_ar == "en"
                        ? (WidthDevice / 1.3) - he_wi[3] - 25
                        : (WidthDevice / 1.3) - he_wi[3]),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[3],
                        height: he_wi[3],
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () async {
                            pagecheck = "PR";
                            if (list_programOP.isEmpty) {
                              await _hundgetdate();
                            }
                            if (!checkadmin) {
                              loadAdInterstitialAd();
                              showAdInterstitialAd();
                            }
                            setState(() {
                              showsendmessage = checkadmin;
                              page = List.generate(
                                  list_programOP.length > 5
                                      ? length_list_program_OP
                                      : list_programOP.length,
                                  (index) => List_program(
                                      messaging_pr:
                                          index >= list_programOP.length
                                              ? Messaging_PR()
                                              : list_programOP[index]));
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 3) {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                } else {
                                  he_wi[i] = 40;
                                  sizeicon[i] = 25;
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
                      '${getLang(context, "Our_Product")}',
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: HieghDevice > WidthDevice
                        ? ((HieghDevice - (HieghDevice / 10)) -
                                ((HieghDevice / 5.5) / 2)) -
                            he_wi[4]
                        : ((HieghDevice - (HieghDevice / 10)) -
                                ((HieghDevice / 5.5) / 2)) -
                            he_wi[4] -
                            10,
                    left: HieghDevice > WidthDevice
                        ? (WidthDevice / 1.10) - he_wi[4]
                        : (WidthDevice / 1.10) - he_wi[4] - 10),
                child: Stack(
                  children: [
                    Container(
                        height: he_wi[4],
                        width: he_wi[4],
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: () async {
                            pagecheck = "PP";
                            if (list_programPP.isEmpty) {
                              await _hundgetdate();
                            }
                            if (!checkadmin) {
                              loadAdInterstitialAd();
                              showAdInterstitialAd();
                            }
                            setState(() {
                              showsendmessage = checkadmin;
                              page = List.generate(
                                  list_programPP.length > 5
                                      ? length_list_program_PP
                                      : list_programPP.length,
                                  (index) => List_partner(
                                      messaging_pp:
                                          index >= list_programPP.length
                                              ? Messaging_PR()
                                              : list_programPP[index]));
                              for (int i = 0; i < he_wi.length; i++) {
                                if (i == 4) {
                                  he_wi[i] = 50;
                                  sizeicon[i] = 30;
                                } else {
                                  he_wi[i] = 40;
                                  sizeicon[i] = 25;
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.local_fire_department,
                            size: sizeicon[4],
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 3, top: he_wi[4]),
                        child: Text(
                          '${getLang(context, "Partner_Programs")}',
                        )),
                  ],
                )),
          ],
        ),
        if (checkadmin && showsendmessage)
          Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(
                  bottom: 20,
                  top: HieghDevice > WidthDevice
                      ? HieghDevice * 0.8
                      : HieghDevice * 0.7,
                  left: WidthDevice * 0.45),
              decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  border: Border.all(
                      color: Theme.of(context).shadowColor, width: 0.3),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 10,
                        spreadRadius: 10)
                  ]),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      checkubdate = false;
                      if (he_wi[2] == 50) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return message_page("SI", new Messaging());
                        }));
                      } else if (he_wi[3] == 50) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return message_page("PI", new Messaging_PR());
                        }));
                      }
                    });
                  },
                  icon: Icon(
                    Icons.message_outlined,
                    size: 25,
                  ))),
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
    } else if (pagecheck == "PR" || pagecheck == "PI" || pagecheck == "PP") {
      if (pagecheck == "PR") {
        length_list_program_OP = 5;
      } else if (pagecheck == "PP") {
        length_list_program_PP = 5;
      }
      try {
        await get_select_message();
      } catch (e) {
        print(e);
      }
    } else if (pagecheck == "N" || pagecheck == "NI") {
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
    } else {
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
                                    widget.message!.MessageID.toString())) {
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
                      if (Validation.isValidnull(widget.message!.MessageLink)) {
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
                                  return message_page("S", widget.message!);
                                }));
                              }
                            }));
                  }
                : () async {
                    if (pay_or_not) {
                      if (Validation.isValidnull(widget.message!.MessageLink)) {
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
                ? Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                    checkadmin
                        ? Container(
                            alignment: Alignment.topRight,
                            child: Container(
                                margin: EdgeInsets.all(10),
                                height: 30,
                                width: 30,
                                child: ElevatedButton.icon(
                                    label: Text(""),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(2)),
                                        elevation: MaterialStateProperty.all(5),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.lightBlueAccent),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.zero,
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                    bottomLeft: Radius.zero),
                                                side: BorderSide(
                                                    color: Colors.black38,
                                                    width: 0.2)))),
                                    onPressed: () async {
                                      if (Validation.isValidnull(
                                          widget.message!.MessageLink)) {
                                        await shareFile();
                                      } else {
                                        await share();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 15,
                                    ))))
                        : SizedBox(),
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
                                widget.message!.MessageDate,
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
                                        color: Theme.of(context).shadowColor,
                                        blurRadius: 20)
                                  ],
                                ),
                                child: Validation.isValidnull(
                                        widget.message!.MessageLink)
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        show_photo(
                                                            path: widget
                                                                .message!
                                                                .MessageLink,
                                                            type: "N")));
                                          });
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: widget.message!.MessageLink,
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
                                        ))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        show_photo(
                                                            path: "",
                                                            type: "")));
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "images/logo.png"),
                                                fit: BoxFit.fill),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: null,
                                        )))
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
                                            color:
                                                Theme.of(context).shadowColor,
                                            blurRadius: 20)
                                      ],
                                    ),
                                    child: Validation.isValidnull(
                                            widget.message!.MessageLink)
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                widget.message!.MessageLink,
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "images/logo.png"),
                                                  fit: BoxFit.fill),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: null,
                                          )),
                              )),
                    Container(
                      margin: EdgeInsets.only(left: WidthDevice / 2.6, top: 10),
                      child: Row(textDirection: TextDirection.ltr, children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 2),
                            child: pay_complate || checkadmin
                                ? Text(
                                    Message_type.values.elementAt(
                                        int.parse(widget.message!.MessageType)),
                                    style: TextStyle(
                                        color: (int.parse(widget
                                                    .message!.MessageType) <
                                                3)
                                            ? Colors.blue
                                            : Colors.redAccent,
                                        fontSize: (HieghDevice / 180) *
                                                (WidthDevice / 180) +
                                            5),
                                  )
                                : ImageFiltered(
                                    imageFilter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Text(
                                      Message_type.values.elementAt(int.parse(
                                          widget.message!.MessageType)),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .color,
                                          fontSize: (HieghDevice / 180) *
                                                  (WidthDevice / 180) +
                                              5),
                                    ),
                                  )),
                        Container(
                            child: Text(
                          " " + widget.message!.MessageSymbol + " ",
                          style: TextStyle(
                              color: pay_complate
                                  ? Theme.of(context).textTheme.headline2!.color
                                  : Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color,
                              fontSize:
                                  (HieghDevice / 180) * (WidthDevice / 180) + 5,
                              fontWeight: pay_complate
                                  ? FontWeight.normal
                                  : FontWeight.bold),
                        )),
                        Container(
                            child: pay_complate || checkadmin
                                ? Text(
                                    "AT:" +
                                        widget.message!.MessageEntryPoint
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: (HieghDevice / 180) *
                                                (WidthDevice / 180) +
                                            5),
                                  )
                                : ImageFiltered(
                                    imageFilter:
                                        ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                    child: Text(
                                      "AT: " +
                                          widget.message!.MessageEntryPoint
                                              .toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .color,
                                          fontSize: (HieghDevice / 180) *
                                                  (WidthDevice / 180) +
                                              5),
                                    ),
                                  ))
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: WidthDevice - 85, top: 65),
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
                                  widget.message!.MessageCountView,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .color,
                                      fontSize: (HieghDevice / 180) *
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
                                    widget.message!.MessageCountView,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .color,
                                        fontSize: (HieghDevice / 180) *
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
                      margin: EdgeInsets.only(top: 50, left: WidthDevice / 2.4),
                      child: pay_complate || checkadmin
                          ? Container(
                              height: 70,
                              width: WidthDevice / 3,
                              child: Text(
                                widget.message!.MessageContent,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .color,
                                    fontSize: (HieghDevice / 180) *
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
                                    widget.message!.MessageContent,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .color,
                                        fontSize: (HieghDevice / 180) *
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
                                "SL : " + widget.message!.OrderStopLoss,
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
                                  "SL : " + widget.message!.OrderStopLoss,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .color,
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
                                      "TP1 : " + widget.message!.Target1,
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
                                      "TP2 : " + widget.message!.Target2,
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
                                        "TP1 : " + widget.message!.Target1,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline2!
                                                .color,
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
                                        "TP2 : " + widget.message!.Target2,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline2!
                                                .color,
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
                      margin: EdgeInsets.only(top: 140, left: WidthDevice - 95),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (pay_or_not && !pay_complate) {
                            List<String> list = [];
                            list.add(member.getEmail);
                            list.add(widget.message!.MessageID.toString());
                            list.add("F");
                            if (await countview.Insert(list)) {
                              pay_complate = true;
                              setState(() {
                                if (!countviewint
                                    .contains(widget.message!.MessageID)) {
                                  countviewint.add(widget.message!.MessageID);
                                }
                                widget.message!.MessageCountView =
                                    countview.countview!;
                              });
                            }
                          } else if (!pay_complate) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contxt) => methods_pay(
                                        messaging: widget.message!,
                                        member: member)));
                          }
                        },
                        child: pay_complate && !checkadmin
                            ? Icon(
                                Icons.check_circle_outlined,
                                color: Colors.green,
                                size: 40,
                              )
                            : Text(
                                (widget.message!.MessagePrice > 0.0)
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
        title: "Symbol",
        text: Message_type.values
            .elementAt(int.parse(widget.message!.MessageType)) +
            " Signal On : " +
            widget.message!.MessageSymbol +
            "\nEntry Point : " +
            widget.message!.MessageEntryPoint.toString() +
            "\n" +
            "Target 1 : " +
            widget.message!.Target1 +
            "\n" +
            "Target 2 : " +
            widget.message!.Target2 +
            "\n" +
            "Stop Loss : " +
            widget.message!.OrderStopLoss +
            "\nMessage content : " +
            widget.message!.MessageContent ,
        linkUrl:
            "Google Play\n"+"https://play.google.com/store/apps/details?id=com.ShepherdFX.Software\n"+
        "Apple Store\n"+"https://apps.apple.com/us/app/shepherd-signals/id1615307348",
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> shareFile() async {
    final response = await get(Uri.parse(widget.message!.MessageLink));
    final bytes = response.bodyBytes;
    final Directory? temp = await getExternalStorageDirectory();
    final File imageFile = File('${temp!.path}/tempImage.png');
    imageFile.writeAsBytesSync(bytes);

    await FlutterShare.shareFile(
      title: "Symbol",
      text: Message_type.values
          .elementAt(int.parse(widget.message!.MessageType)) +
          " Signal On : " +
          widget.message!.MessageSymbol +
          "\nEntry Point : " +
          widget.message!.MessageEntryPoint.toString() +
          "\n" +
          "Target 1 : " +
          widget.message!.Target1 +
          "\n" +
          "Target 2 : " +
          widget.message!.Target2 +
          "\n" +
          "Stop Loss : " +
          widget.message!.OrderStopLoss +
          "\nMessage content : " +
          widget.message!.MessageContent +
          "\n" +
          "Google Play\n"+"https://play.google.com/store/apps/details?id=com.ShepherdFX.Software\n"+
          "Apple Store\n"+"https://apps.apple.com/us/app/shepherd-signals/id1615307348",
      filePath: imageFile.path,
    );
  }
}

void SortByDateM_N(int i, int j) {
  if (i < messaging.length && j < notification_message.length) {
    if (i + j <= lengthList) {
      if (DateTime.parse(messaging[i].MessageDate)
          .isAfter(DateTime.parse(notification_message[j].date!))) {
        page.add(List_messaging(
          message: messaging[i],
        ));
        SortByDateM_N(i + 1, j);
      } else {
        page.add(List_Notif(
          index: j,
        ));
        SortByDateM_N(i, j + 1);
      }
    }
  } else if (i < messaging.length) {
    addmessage(i);
  } else if (j < notification_message.length) {
    addnotifi(j);
  }
}

void addmessage(int i) {
  if (i < messaging.length && i <= lengthList) {
    page.add(List_messaging(
      message: messaging[i],
    ));
    addmessage(i + 1);
  }
}

void addnotifi(int i) {
  if (i < notification_message.length && i <= lengthList) {
    page.add(List_Notif(
      index: i,
    ));
    addnotifi(i + 1);
  }
}

void SortByView() {
  for (int i = 0; i < messaging.length; i++) {
    for (int j = i + 1; j < messaging.length; j++) {
      if (int.parse(messaging[i].MessageCountView) <
          int.parse(messaging[j].MessageCountView)) {
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

Future<bool> PaymentComplate(
    String type, String email, String id_message) async {
  List<String> list = [];
  list.add(email);
  list.add(id_message);
  list.add(type);
  if (await countview.Insert(list)) {
    if (!countviewint.contains(int.parse(id_message))) {
      countviewint.add(int.parse(id_message));
    }
    messaging.forEach((element) {
      if (element.MessageID == int.parse(id_message)) {
        element.MessageCountView = countview.countview!;
      }
    });
    return true;
  }
  return false;
}
