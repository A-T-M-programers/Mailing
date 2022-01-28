import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailing/Class/Class_database.dart';
import '../Message_page.dart';


late bool checkadmin, endList;
int lengthList = 5;
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
    checkadmin = true;
  }

  @override
  Widget build(BuildContext context) {

    endList = (lengthList == widget.index) ? true : false;
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return MaterialButton(
        minWidth: WidthDevice,
        padding: EdgeInsets.all(0),
        onPressed: () async {
          if (checkadmin) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return message_page("N",messaging_pu);
            }));
          }
        },
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
              width: WidthDevice-20,
              height: 150,
              child: Center(
                  child: Stack(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: WidthDevice / 9, top: 70,bottom: 10,right: 10),
                            alignment: Alignment.bottomRight,
                            child: Text(
                              messaging_pu!.getdatepu,
                              style: TextStyle(
                                  color:messaging_pu!.gettype? Colors.black38:Colors.black,
                                  fontSize: (HieghDevice / 180) * (WidthDevice / 180)),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.topCenter,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black38, blurRadius: 20)
                                  ],
                                ),
                                child: Text(
                                  messaging_pu!.gettitle,
                                  style: TextStyle(
                                      color: messaging_pu!.gettype? Colors.black38:Colors.black,
                                      fontSize: (HieghDevice / 130) * (WidthDevice / 130)),
                                )
                            )),
                          Container(
                            alignment: Alignment.center,
                              width: WidthDevice-70,
                              child: Text(
                                messaging_pu!.getcontent,
                                style: TextStyle(color: messaging_pu!.gettype? Colors.black38:Colors.black),maxLines: 3,
                              )
                          ),
                      ]))),
          if (endList)
            Container(
              height: (HieghDevice / 5.5) + 60,
            )
        ]));
  }
}