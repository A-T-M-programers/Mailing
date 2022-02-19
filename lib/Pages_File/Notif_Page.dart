import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailing/Class/Class_database.dart';
import 'package:mailing/Class/Constant.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/Pages_File/Program_Page.dart';
import 'package:mailing/main.dart';
import '../Login_Mailing.dart';
import '../Message_page.dart';
import 'package:http/http.dart' as http;
import 'package:mailing/Home_Page.dart' as home;

Messaging_PU? messaging_pu= Messaging_PU();

class List_Notif extends StatefulWidget {
  @override
  _List_Notif_state createState() => _List_Notif_state();

  List_Notif({this.index, this.onPress});

  final int? index;
  final Function? onPress;
}

class _List_Notif_state extends State<List_Notif> {
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
    if (notification_message.length > widget.index!) {

      return MaterialButton(
          minWidth: WidthDevice,
          padding: EdgeInsets.all(0),
          onPressed: () async {
            if (home.checkadmin && notification_message[widget.index!].type == "N") {
              var secret = Crypt.sha256("ubdate_notifi_state");
              Uri url = Uri(
                  host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
              var response = await http.post(url, body: {
                'type': notification_message[widget.index!].type,
                'id': notification_message[widget.index!].messaging_id.toString(),
                'email': member.getEmail,
                'secret': '$secret'
              });
              switch (response.statusCode) {
                case 200:
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return message_page("N", messaging_pu);
                    }));
                    break;
                  }
                case 400:
                  {
                    showtoast('Notification not available');
                    break;
                  }
              }
            }else if(notification_message[widget.index!].type == "S"){
              if(!notification_message[widget.index!].getNotifiState) {
                pagecheck = "S";
                var secret = Crypt.sha256("ubdate_notifi_state");
                Uri url = Uri(
                    host: host,
                    path: 'Mailing_API/Ubdate/Ubdate.php',
                    scheme: scheme);
                var response = await http.post(url, body: {
                  'type': notification_message[widget.index!].type,
                  'id': notification_message[widget.index!].messaging_id
                      .toString(),
                  'email': member.getEmail,
                  'secret': '$secret'
                });
                switch (response.statusCode) {
                  case 200:
                    {
                      Messaging message = Messaging();
                      var secret = Crypt.sha256("select_search_message");
                      Uri url = Uri(
                          host: host,
                          path: 'Mailing_API/Select/get_Message.php',
                          scheme: scheme);
                      var response = await http.post(url, body: {
                        'id': notification_message[widget.index!].messaging_id
                            .toString(),
                        'secret': '$secret'
                      });
                      if (response.statusCode == 200) {
                        List<dynamic> data = json.decode(response.body);
                        for (int i = 0; i < data.length; i++) {
                          message.MessageID =
                              int.parse(data.elementAt(i)['MessageID']);
                          message.MessageType =
                          data.elementAt(i)['MessageType'];
                          message.MessageState =
                          data.elementAt(i)['MessageState'];
                          message.MessageCountView =
                          data.elementAt(i)['MessageCountView'];
                          message.MessagePrice =
                              double.parse(data.elementAt(i)['MessagePrice']);
                          message.MessageDate =
                          data.elementAt(i)['MessageDate'];
                          message.MessageSymbol =
                          data.elementAt(i)['MessageSymbol'];
                          message.MessageLink =
                          data.elementAt(i)['MessageLink'];
                          message.Target1 = data.elementAt(i)['Target1'];
                          message.Target2 = data.elementAt(i)['Target2'];
                          message.OrderStopLoss =
                          data.elementAt(i)['OrderStopLoss'];
                          message.MessageContent =
                          data.elementAt(i)['MessageContent'];
                          message.MessageEntryPoint =
                              double.parse(data.elementAt(i)['EntryPoint']);
                        }
                      }
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return Container(
                            margin: EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50)),
                              color: Colors.white,
                            ),
                            height: HieghDevice - 50,
                            width: WidthDevice - 50,
                            child: List_messaging(message: message,));
                      }));
                      break;
                    }
                  case 400:
                    {
                      showtoast('Notification not available');
                      break;
                    }
                }
              }else{
                Messaging message = Messaging();
                var secret = Crypt.sha256("select_search_message");
                Uri url = Uri(
                    host: host,
                    path: 'Mailing_API/Select/get_Message.php',
                    scheme: scheme);
                var response = await http.post(url, body: {
                  'id': notification_message[widget.index!].messaging_id
                      .toString(),
                  'secret': '$secret'
                });
                if (response.statusCode == 200) {
                  List<dynamic> data = json.decode(response.body);
                  for (int i = 0; i < data.length; i++) {
                    message.MessageID =
                        int.parse(data.elementAt(i)['MessageID']);
                    message.MessageType =
                    data.elementAt(i)['MessageType'];
                    message.MessageState =
                    data.elementAt(i)['MessageState'];
                    message.MessageCountView =
                    data.elementAt(i)['MessageCountView'];
                    message.MessagePrice =
                        double.parse(data.elementAt(i)['MessagePrice']);
                    message.MessageDate =
                    data.elementAt(i)['MessageDate'];
                    message.MessageSymbol =
                    data.elementAt(i)['MessageSymbol'];
                    message.MessageLink =
                    data.elementAt(i)['MessageLink'];
                    message.Target1 = data.elementAt(i)['Target1'];
                    message.Target2 = data.elementAt(i)['Target2'];
                    message.OrderStopLoss =
                    data.elementAt(i)['OrderStopLoss'];
                    message.MessageContent =
                    data.elementAt(i)['MessageContent'];
                    message.MessageEntryPoint =
                        double.parse(data.elementAt(i)['EntryPoint']);
                  }
                }
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) {
                  return Container(
                      margin: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50)),
                        color: Colors.white,
                      ),
                      height: HieghDevice - 50,
                      width: WidthDevice - 50,
                      child: List_messaging(message: message,));
                }));
              }
            }else if(notification_message[widget.index!].type == "P"){
              pagecheck = "PR";
              var secret = Crypt.sha256("ubdate_notifi_state");
              Uri url = Uri(
                  host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
              var response = await http.post(url, body: {
                'type': notification_message[widget.index!].type,
                'id': notification_message[widget.index!].messaging_id.toString(),
                'email': member.getEmail,
                'secret': '$secret'
              });
              switch (response.statusCode) {
                case 200:
                  {

                    Messaging_PR message_pr = Messaging_PR();
                    var secret = Crypt.sha256("select_search_program");
                    Uri url = Uri(
                        host: host,
                        path: 'Mailing_API/Select/get_Message.php',
                        scheme: scheme);
                    var response = await http.post(url, body: {
                      'id': notification_message[widget.index!].messaging_id
                          .toString(),
                      'secret': '$secret'
                    });
                    if (response.statusCode == 200) {
                      List<dynamic> data = json.decode(response.body);
                      for (int i = 0; i < data.length; i++) {
                        message_pr.setID =
                            int.parse(data.elementAt(i)['ProgramID']);
                        message_pr.setprogramtype =
                        data.elementAt(i)['ProgramType'];
                        message_pr.setlink =
                        data.elementAt(i)['ProgramLink'];
                        message_pr.setcontent =
                        data.elementAt(i)['ProgramText'];
                        if (data.elementAt(i)['ProgramImages'] != null) {
                          message_pr.setlistimage = data
                              .elementAt(i)['ProgramImages']
                              .replaceAll('[', "")
                              .replaceAll(']', "")
                              .split(",");
                        }
                      }
                    }
                    if(message_pr.gettype == "1") {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return Container(
                            margin: EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50)),
                              color: Colors.white,
                            ),
                            height: HieghDevice - 50,
                            width: WidthDevice - 50,
                            child: List_program(messaging_pr: message_pr,));
                      }));
                    }else if(message_pr.gettype == "0") {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return Container(
                            margin: EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50)),
                              color: Colors.white,
                            ),
                            height: HieghDevice - 50,
                            width: WidthDevice - 50,
                            child: List_partner(messaging_pp: message_pr,));
                      }));
                    }
                    break;
                  }
                case 400:
                  {
                    showtoast('Notification not available');
                    break;
                  }
              }
            }
          },
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
                height: 150,
                child: Center(
                    child: Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: WidthDevice / 9,
                                  top: 70,
                                  bottom: 10,
                                  right: 10),
                              alignment: Alignment.bottomRight,
                              child: Text(
                                notification_message[widget.index!].date!,
                                style: TextStyle(
                                    color: notification_message[widget.index!]
                                        .getNotifiState
                                        ? Colors.black38
                                        : Colors.black,
                                    fontSize: (HieghDevice / 180) *
                                        (WidthDevice / 180)),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.topCenter,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black38, blurRadius: 20)
                                    ],
                                  ),
                                  child: Text(
                                    notification_message[widget.index!]
                                        .gettitle!.isNotEmpty
                                        ? notification_message[widget.index!]
                                        .title!
                                        : "Null",
                                    style: TextStyle(
                                        color: notification_message[widget
                                            .index!].getNotifiState ? Colors
                                            .black38 : Colors.black,
                                        fontSize: (HieghDevice / 130) *
                                            (WidthDevice / 130)),
                                  )
                              )),
                          Container(
                              alignment: Alignment.center,
                              width: WidthDevice - 70,
                              child: Text(
                                notification_message[widget.index!].content!,
                                style: TextStyle(
                                    color: notification_message[widget.index!]
                                        .getNotifiState
                                        ? Colors.black38
                                        : Colors.black), maxLines: 3,
                              )
                          ),
                        ]))),
          ]));
    }else {
        return SizedBox();
    }
  }
}