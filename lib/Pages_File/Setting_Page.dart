import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/Login_Mailing.dart';
import 'package:mailing/l10n/applocal.dart';
import 'package:mailing/main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

late bool switch_value_Mute, switch_value_dark, switch_value_translate = false;

class setting_page extends StatefulWidget {
  @override
  setting_page_state createState() => setting_page_state();
}

class setting_page_state extends State<setting_page> {
  late double WidthDevice, HieghDevice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch_value_dark = false;
    switch_value_Mute = false;
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return Container(
        margin: EdgeInsets.only(top: 20, bottom: HieghDevice / 3),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 5)
                      ],
                      border: Border.all(color: Colors.black54, width: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 40,
                      ),
                      Text(
                        '${getLang(context, "Mute_Notification")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                          value: switch_value_Mute,
                          onChanged: (value) {
                            setState(() {
                              switch_value_Mute = value;
                              set_notification_rigtone();
                            });
                          })
                    ],
                  ),
                ),
                switch_value_Mute
                    ? Container(
                  margin: EdgeInsets.only(left: 20, right: 20,top: 95),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.arrow_drop_down,color: Colors.black45,size: 35,),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white70),
                            elevation: MaterialStateProperty.all(20),

                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return audio();
                              }));
                            });
                          },
                          label: Text("Ringtone",style: TextStyle(color: Colors.black54),),
                        ),
                      )
                    : SizedBox(),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 5)
                      ],
                      border: Border.all(color: Colors.black54, width: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20, top:switch_value_Mute ? 160 : 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.nights_stay_rounded,
                        size: 40,
                      ),
                      Text(
                        '${getLang(context, "Darck_Mode")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                          value: switch_value_dark,
                          onChanged: (value) {
                            setState(() {
                              switch_value_dark = value;
                            });
                          })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 5)
                      ],
                      border: Border.all(color: Colors.black54, width: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20, top:switch_value_Mute ? 260 : 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        size: 40,
                      ),
                      Text(
                        '${getLang(context, "Log_Out")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              member.deletefile();
                              page = null;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (route) => false);
                            });
                          },
                          icon: Icon(
                            Icons.meeting_room_rounded,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 5)
                      ],
                      border: Border.all(color: Colors.black54, width: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20, top: switch_value_Mute ? 360 : 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.translate,
                        size: 40,
                      ),
                      Text(
                        '${getLang(context, "AR_And_EN")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                          value: switch_value_translate,
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                en_ar = 'ar';
                                runApp(MyApp());
                              } else {
                                en_ar = 'en';
                                runApp(MyApp());
                              }
                              switch_value_translate = value;
                            });
                          })
                    ],
                  ),
                )
              ],
            )));
  }

  void set_notification_rigtone() {
    if (Platform.isAndroid) {
    } else {}
  }
}

class audio extends StatefulWidget {
  const audio({Key? key}) : super(key: key);

  @override
  _audioState createState() => _audioState();
}

class _audioState extends State<audio> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  final _audioQuery = new OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ringtone App"),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return Center(child: Text("No Songs found"));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: (){
                  setState(() {
                    check_radio_ringtone = index;
                  });
                },
              leading: Icon(Icons.music_note),
              title: Text(item.data![index].displayNameWOExt),
              subtitle: Text("${item.data![index].artist}"),
              trailing: Radio(value: index, onChanged: (value){
                setState(() {
                  check_radio_ringtone = int.parse(value!.toString());
                });
              }, groupValue: check_radio_ringtone,),
            );},
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }
}
bool? check_box_ringtome = false;
int check_radio_ringtone = -1;