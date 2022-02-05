import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/Login_Mailing.dart';
import 'package:mailing/l10n/applocal.dart';
import 'package:mailing/main.dart';


late bool switch_value_Mute,switch_value_dark,switch_value_translate = false;

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
        margin: EdgeInsets.only(top: 20,bottom: HieghDevice/3),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:  Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color:Colors.black12,blurRadius: 5,spreadRadius: 5)],
                    border: Border.all(color: Colors.black54,width: 0.1),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white70
                  ),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.notifications_off_outlined ,size: 40,),
                      Text(
                        '${getLang(context, "Mute_Notification")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                          value: switch_value_Mute,
                          onChanged: (value){setState(() {
                            switch_value_Mute = value;
                          });})
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color:Colors.black12,blurRadius: 5,spreadRadius: 5)],
                      border: Border.all(color: Colors.black54,width: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70
                  ),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20,top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.nights_stay_rounded ,size: 40,),
                      Text(
                        '${getLang(context, "Darck_Mode")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                          value: switch_value_dark,
                          onChanged: (value){setState(() {
                            switch_value_dark = value;
                          });})
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color:Colors.black12,blurRadius: 5,spreadRadius: 5)],
                      border: Border.all(color: Colors.black54,width: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70
                  ),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20,top: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.logout_outlined ,size: 40,),
                      Text(
                        '${getLang(context, "Log_Out")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      IconButton(onPressed: (){
                        setState(() {
                          member.deletefile();
                          page = null;
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => LoginPage()), (route) => false);
                        });
                      }, icon:Icon(Icons.meeting_room_rounded,size: 40,) )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color:Colors.black12,blurRadius: 5,spreadRadius: 5)],
                      border: Border.all(color: Colors.black54,width: 0.1),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70
                  ),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20,top: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.translate ,size: 40,),
                      Text(
                        '${getLang(context, "AR_And_EN")}',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                          value: switch_value_translate,
                          onChanged: (value){
                            setState(() {
                              if(value){
                                en_ar = 'ar';
                                runApp(MyApp());
                              }else{
                                en_ar = 'en';
                                runApp(MyApp());
                              }
                            switch_value_translate = value;
                          });})
                    ],
                  ),
                )
              ],
            )));
  }
}
