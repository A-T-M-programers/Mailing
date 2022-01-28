import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailing/Class/Class_database.dart';
import '../Message_page.dart';


late bool checkadmin, endList;
int lengthList = 5;
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

    endList = (lengthList == widget.index) ? true : false;
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return MaterialButton(
        minWidth: WidthDevice,
        padding: EdgeInsets.all(0),
        onPressed: () async {
          if (checkadmin) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return message_page("P",program);
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
              height: 300,
              child: Center(
                  child: Stack(
                      children: [
                    Container(
                        alignment: Alignment.center,
                        child: Container(
                            height: 290,
                            width: WidthDevice-20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black38, blurRadius: 20)
                              ],
                            ),
                            child: CachedNetworkImage(
                              imageUrl:program!.getlistimage[0].Image_Link,
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
                          alignment: Alignment.bottomCenter,
                          height: 280,width: WidthDevice-50,
                          child: Container(
                              height: 50,
                              width: WidthDevice-70,
                              child: Text(
                                "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                                style: TextStyle(color: Colors.white),maxLines: 3,
                              )),
                        ),
                        Container(
                          alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                right: 10,
                                left: WidthDevice-70,top: 10,bottom: 245),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38, width: 0.3),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black38, blurRadius: 10, spreadRadius: 10)
                                ]),
                            child: IconButton(
                                onPressed: () => {},
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white70,
                                  size: 25,
                                )))
                  ]))),
          if (endList)
            Container(
              height: (HieghDevice / 5.5) + 60,
            )
        ]));
  }
}