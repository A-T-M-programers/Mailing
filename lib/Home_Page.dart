import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:mailing/Pages_File/Notif_Page.dart';
import 'package:mailing/Pages_File/Profile_Page.dart';
import 'package:mailing/Pages_File/Program_Page.dart';
import 'package:mailing/Pages_File/Setting_Page.dart';

import 'Class/Class_database.dart';
import 'Message_page.dart';
import 'l10n/applocal.dart';
import 'main.dart';

Messaging? messaging ;

Map<String,String> Message_type = {'0':'Buy', '1':'Buy Limit', '2':'Buy Stop', '3':'Sell','4':'Sell Limit','5':'Sell Stop'};


late bool checkadmin, endList,showsendmessage;
int lengthList = 5;
var page;
String pagecheck = "";
List<double> he_wi = [50,50,70,50,50];
List<double> sizeicon = [30,30,50,30,30];

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  home_page_state createState() => home_page_state();
}

class home_page_state extends State<home_page> {
  String? dropdownValue = "Date";
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkadmin = true;
    showsendmessage = true;
    messaging = Messaging();
    page = List.generate(5, (index) => List_messaging(index: index + 1));
    for(int i = 0; i<he_wi.length;i++){
      if(i == 2){
        he_wi[i] = 60;
        sizeicon[i] = 40;
      }else{
        he_wi[i] = 50;
        sizeicon[i] = 30;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.only(top: 0,right: WidthDevice/2.5),
              child: Text(
                "${getLang(context, "Mailing")}",
                style: TextStyle(fontSize: HieghDevice / 18),
                textAlign: TextAlign.center,
              ),
            ),
            if(showsendmessage) Container(
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
                margin:
                    EdgeInsets.only(left: WidthDevice - 120, top: 4, right: 10),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            height: HieghDevice,
            width: WidthDevice,
            child: ListView(
                scrollDirection: Axis.vertical,
                children: page
            )),
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
                    top: ((HieghDevice - (HieghDevice / 10)) -
                            ((HieghDevice / 5.5) / 2)) -
                        he_wi[0],
                    left: (WidthDevice / 5.2)-he_wi[0]),
                child: Column(
                  children: [
                    Container(
                      height: he_wi[0],width: he_wi[0],
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.white, blurRadius: 5),
                              BoxShadow(color: Colors.white, blurRadius: 5)
                            ]),
                        child: IconButton(
                          onPressed: ()  {setState(() {
                            pagecheck = "set";
                            showsendmessage = false;
                            page = List.generate(1, (index) => setting_page());
                            for(int i = 0; i<he_wi.length;i++){
                              if(i == 0){
                                he_wi[i] = 60;
                                sizeicon[i] = 40;
                              }else{
                                he_wi[i] = 50;
                                sizeicon[i] = 30;
                              }
                            }
                          });},
                          icon: Icon(
                            Icons.settings_outlined,
                            size: sizeicon[0],
                          ),
                          color: Colors.black,
                        )),
                    Text(
                      "Setting",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 12)) -
                            ((HieghDevice / 5.5) / 1.16)) -
                        he_wi[1],
                    left: (WidthDevice / 2.8)-he_wi[1]),
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
                          onPressed: ()  {
                            setState(() {
                              pagecheck = "info";
                              showsendmessage = false;
                              page = List.generate(1, (index) => Profile(member: member, type: pagecheck));
                              for(int i = 0; i<he_wi.length;i++){
                                if(i == 1){
                                  he_wi[i] = 60;
                                  sizeicon[i] = 40;
                                }else{
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
                      "Profile",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                height: 90,
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 12)) -
                            ((HieghDevice / 5.5))) -
                        he_wi[2],
                    left: (WidthDevice / 1.7)-he_wi[2]),
                child: Column(
                  children: [
                    Container(
                        width: he_wi[2] ,
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
                          onPressed: ()  {setState(() {
                            pagecheck = "S";
                            showsendmessage = true;
                            page = List.generate(5, (index) => List_messaging(index: index + 1));
                            for(int i = 0; i<he_wi.length;i++){
                              if(i == 2){
                                he_wi[i] = 60;
                                sizeicon[i] = 40;
                              }else{
                                he_wi[i] = 50;
                                sizeicon[i] = 30;
                              }
                            }
                          });},
                          icon: Icon(
                            Icons.home_outlined,
                            size: sizeicon[2],
                          ),
                          color: Colors.black,
                        )),
                    Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 12)) -
                            ((HieghDevice / 5.5) / 1.1)) -
                        he_wi[3],
                    left: (WidthDevice / 1.3)-he_wi[3]),
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
                          onPressed: () {setState(() {
                            pagecheck = "PR";
                            showsendmessage = true;
                            page = List.generate(5, (index) => List_program(index: index + 1));
                            for(int i = 0; i<he_wi.length;i++){
                              if(i == 3){
                                he_wi[i] = 60;
                                sizeicon[i] = 40;
                              }else{
                                he_wi[i] = 50;
                                sizeicon[i] = 30;
                              }
                            }
                          });},
                          icon: Icon(
                            Icons.filter_drama,
                            size: sizeicon[3],
                          ),
                          color: Colors.black,
                        )),
                    Text(
                      "Program",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    top: ((HieghDevice - (HieghDevice / 10)) -
                            ((HieghDevice / 5.5) / 1.8)) -
                        he_wi[4],
                    left: (WidthDevice /1.09)-he_wi[4]),
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
                          onPressed: ()  {
                            setState(() {
                              pagecheck = "N";
                              showsendmessage = true;
                              page = List.generate(5, (index) => List_Notif(index: index + 1));
                              for(int i = 0; i<he_wi.length;i++){
                                if(i == 4){
                                  he_wi[i] = 60;
                                  sizeicon[i] = 40;
                                }else{
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
                          "Notificate",
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
                  onPressed: ()  {setState(() {
                    if(he_wi[2]==60){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return message_page("SI");
                    }));
                    }else if(he_wi[3]==60){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return message_page("PI");
                      }));
                    }else if(he_wi[4]==60){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return message_page("NI");
                      }));
                    }
                  });
                    },
                  icon: Icon(
                    Icons.message_outlined,
                    color: Colors.black,
                    size: 35,
                  )))
      ]),
    ));
  }
}

class List_messaging extends StatefulWidget {
  @override
  _List_messaging createState() => _List_messaging();

  List_messaging({this.index, this.onPress});

  final int? index;
  final Function? onPress;
}

class _List_messaging extends State<List_messaging> {
  Messaging? messaging;
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messaging = new Messaging();
  }

  @override
  Widget build(BuildContext context) {
    messaging = new Messaging();
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    endList = (lengthList == widget.index) ? true : false;

    return MaterialButton(
        minWidth: WidthDevice,
        padding: EdgeInsets.all(0),
        onPressed: () async {
          if (checkadmin) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return message_page("S");
            }));
          }
        },
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
              width: WidthDevice - 10,
              height: 200,
              child: Center(
                  child: Stack(children: [
                Container(
                    margin: EdgeInsets.only(left: WidthDevice / 9, top: 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "01/01/2022 05:33:33",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: (HieghDevice / 180) * (WidthDevice / 180)),
                    )),
                Container(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin:
                            EdgeInsets.only(left: WidthDevice / 18, top: 25),
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 20)
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://cdn.pixabay.com/photo/2017/10/17/16/10/fantasy-2861107_960_720.jpg",
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
                      margin: EdgeInsets.only(left: WidthDevice / 2.6, top: 10),
                      child: Row(textDirection: TextDirection.ltr,
                          children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text(
                              Message_type.values.elementAt(int.parse(messaging!.MessageType)),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: (HieghDevice / 180) *
                                          (WidthDevice / 180) +
                                      5),
                            )),
                        Text(
                          "  " + messaging!.MessageSymbol + "  ",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize:
                                  (HieghDevice / 180) * (WidthDevice / 180) +
                                      5),
                        ),
                        Container(
                            child: Text(
                          messaging!.MessageEntryPoint.toString(),
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize:
                                  (HieghDevice / 180) * (WidthDevice / 180) +
                                      5),
                        ))
                      ]),
                    ),
                Container(
                  margin: EdgeInsets.only(left: WidthDevice - 85, top: 35),
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
                        "10",
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: WidthDevice - 80, top: 80),
                  child: checkadmin
                      ? Row(
                    textDirection: TextDirection.ltr,
                          children: [
                            Text(
                              r"$",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "10",
                              style: TextStyle(color: Colors.black54),
                            )
                          ],
                        )
                      : null,
                ),
                Container(
                  width: 85,
                  height: 60,
                  margin: EdgeInsets.only(top: 140, left: WidthDevice - 95),
                  child: ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                       '${getLang(context, "Pay")}'+r" : 100$",
                      style: TextStyle(color: Colors.black38),textDirection: TextDirection.ltr,
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                        elevation: MaterialStateProperty.all(20),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlueAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.zero,
                                        bottomRight: Radius.circular(40)),
                                    side: BorderSide(
                                        color: Colors.black38, width: 0.2)))),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  height: 70,
                  margin: EdgeInsets.only(top: 50,left: WidthDevice/2.4),
                  child: Container(
                    height: 70,
                    width: WidthDevice/3,
                    child: Text(
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                    style: TextStyle(color: Colors.black38),maxLines: 4,
                  )),
                ),
                Container(
                  width: WidthDevice,
                    margin: EdgeInsets.only(left: WidthDevice / 10, top: 170),
                    child: Text(
                      "SL : " + messaging!.OrderStopLoss.toString(),
                      style: TextStyle(
                          color: Color.fromARGB(500, 200, 10, 10),
                          fontSize:
                              (HieghDevice / 180) * (WidthDevice / 180) + 5),textDirection: TextDirection.ltr,
                    )),
                Container(
                  margin: EdgeInsets.only(left: WidthDevice / 2.3, top: 135),
                  child: Column(
                      textDirection: TextDirection.ltr,
                    children: [
                      Container(
                        width: WidthDevice,
                          child: Text(
                        "TD1 : " + messaging!.Target1.toString(),
                        style: TextStyle(
                            color: Colors.green,
                            fontSize:
                                (HieghDevice / 180) * (WidthDevice / 180) + 5),textDirection: TextDirection.ltr,
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: WidthDevice,
                          child: Text(
                        "TD2 : " + messaging!.Target2.toString(),
                        style: TextStyle(
                            color: Colors.green,
                            fontSize:
                                (HieghDevice / 180) * (WidthDevice / 180) + 5),textDirection: TextDirection.ltr,
                      ))
                    ],
                  ),
                )
              ]))),
          if (endList)
            Container(
              height: (HieghDevice / 5.5) + 60,
            )
        ]));
  }
}
