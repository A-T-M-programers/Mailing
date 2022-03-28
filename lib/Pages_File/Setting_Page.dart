import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mailing/Class/Theme_Dark_and_Light.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/Login_Mailing.dart';
import 'package:mailing/Pages_File/About.dart';
import 'package:mailing/Validate.dart';
import 'package:mailing/l10n/applocal.dart';
import 'package:mailing/main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';


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
                      borderRadius: BorderRadius.circular(50)),
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
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Switch(
                          value: switch_value_Mute,
                          onChanged: (value) async {
                            bool? isGranted = await PermissionHandler.permissionsGranted;

                            if (!isGranted!) {
                              // Opens the Do Not Disturb Access settings to grant the access
                              await PermissionHandler.openDoNotDisturbSetting();
                            }
                            if(value){
                              try {
                                await SoundMode.setSoundMode(RingerModeStatus.silent);
                              } on PlatformException {
                                print('Please enable permissions required');
                              }
                            }else{
                              try {
                                await SoundMode.setSoundMode(RingerModeStatus.normal);
                              } on PlatformException {
                                print('Please enable permissions required');
                              }
                            }
                            setState(() {
                              switch_value_Mute = value;
                            });
                          })
                    ],
                  ),
                ),
                !switch_value_Mute
                    ? Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 95),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.arrow_drop_down,
                              size: 35,
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).shadowColor,
                            ),
                            elevation: MaterialStateProperty.all(20),
                          ),
                          onPressed: () {
                            AppSettings.openNotificationSettings();
                          },
                          label: Text(
                            "Ringtone",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, spreadRadius: 5)
                    ],
                    border: Border.all(color: Colors.black54, width: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: !switch_value_Mute ? 160 : 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.nights_stay_rounded,
                        size: 40,
                      ),
                      Text(
                        '${getLang(context, "Darck_Mode")}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      ChangeThemeButtonWidget()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 5, spreadRadius: 5)
                    ],
                    border: Border.all(color: Colors.black54, width: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: !switch_value_Mute ? 260 : 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        size: 40,
                      ),
                      Text(
                        '${getLang(context, "Log_Out")}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              member.deletefile();
                              page = [];
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
                      borderRadius: BorderRadius.circular(50)),
                  width: WidthDevice / 1.1,
                  height: 80,
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: !switch_value_Mute ? 360 : 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.translate,
                        size: 40,
                      ),
                      Text(
                        '${getLang(context, "AR_And_EN")}',
                        style: TextStyle(fontWeight: FontWeight.w600),
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
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: !switch_value_Mute ? 460 : 400),
                    child: Column(
                      children: [
                        Text(
                          getLang(context, "help"),
                          style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic,wordSpacing: 5),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>about(typepage: "")));
                          },
                          child: Text(
                            getLang(context, "pageabout"),style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline,fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white70, width: 3),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("images/logo.png"),
                                fit: BoxFit.contain,
                              )),
                          child: null,
                        ),
                      ],
                    ))
              ],
            )));
  }
}

class audio extends StatefulWidget {
  const audio({Key? key}) : super(key: key);

  @override
  _audioState createState() => _audioState();
}

String? path_ringtone;

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
        actions: [
          Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextButton(
                  onPressed: () {
                    if (Validation.isValidnull(path_ringtone!)) {
                      stopLocal();
                      Navigator.pop(context);

                    }
                  },
                  child: Text(
                    getLang(context, "Choose"),
                    style: TextStyle(color: Colors.white),
                  )))
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.INTERNAL,
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
                onTap: () {
                  setState(() {
                    check_radio_ringtone = index;
                    path_ringtone = item.data![index].data;
                    playLocal(path_ringtone!);
                  });
                },
                leading: Icon(Icons.music_note),
                title: Text(item.data![index].displayNameWOExt),
                subtitle: Text("${item.data![index].artist}"),
                trailing: Radio(
                  value: index,
                  onChanged: (value) {
                    setState(() {
                      check_radio_ringtone = int.parse(value!.toString());
                    });
                  },
                  groupValue: check_radio_ringtone,
                ),
              );
            },
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }

  AudioPlayer audioPlayer = AudioPlayer();

  playLocal(String localPath) async {
    int result = await audioPlayer.play(localPath, isLocal: true);
    if (result == 1) {
      Future.delayed(Duration(seconds: 5), () => stopLocal());
    }
  }

  stopLocal() async {
    int result = await audioPlayer.stop();
  }
}

bool? check_box_ringtome = false;
int check_radio_ringtone = -1;

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        });
  }
}
