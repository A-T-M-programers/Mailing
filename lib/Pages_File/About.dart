import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailing/l10n/applocal.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Validate.dart';
import '../main.dart';

class about extends StatefulWidget {
  @override
  about_state createState() => about_state();

  about({required this.typepage});

  final String typepage;
}

late TextEditingController Help_Title;

class about_state extends State<about> {
  double WidthDevice = 0, HieghDevice = 0;
  late String appName,packageName,version,buildNumber;
  Map<String, String> Message_type = {
    '0': 'Request_Metatrader_Coding',
    '1': 'Request_Android_IOS_Developing',
    '2': 'Request_Chart_Analyzing',
    '3': 'Request_Account_managing'
  };
  late String? dropdownValue = "Request_Metatrader_Coding";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Help_Title = TextEditingController();
    get_version();
  }

  void get_version()async{

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            getLang(context, "about_title"),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline1!.color,
        ),
        body: SingleChildScrollView(
            child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${getLang(context, "about_us_title")}',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${getLang(context, "about_us")}',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 4,
                        height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${getLang(context, "serve_title")}',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${getLang(context, "serve")}',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontWeight: FontWeight.w400,
                        wordSpacing: 3,
                        height: 1.4),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${getLang(context, "servec")}',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 3,
                        height: 1.4),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Theme.of(context).shadowColor,blurRadius: 10)]
                    ),
                    alignment: Alignment.center,
                      child: DropdownButton<String>(
                        value:  dropdownValue,
                        icon: const Icon(Icons.filter_list_rounded),
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['0', '1', '2', '3']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value:
                            Message_type.values.elementAt(int.parse(value)),
                            child: Text(
                             getLang(context,Message_type.values.elementAt(int.parse(value))),
                            ),
                          );
                        }).toList(),
                      )),
            SizedBox(height: 20,),
                  Container(
                      width: WidthDevice / 1.15,
                      height: 200,
                      child: TextFormField(
                        controller: Help_Title,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: '${getLang(context, "subject")}',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).shadowColor, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value) =>
                            Validation.isValidnull(value!.trim())
                                ? null
                                : '${getLang(context, "ValidContent")}',
                        maxLines: 8,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.greenAccent)),
                          onPressed: ()async {
                            final Email email = Email(
                              body: Help_Title.text + "\nDate : "+DateTime.now().toString()+" \nWith Email From : "+member.getEmail,
                              subject: getLang(context, dropdownValue),
                              recipients: ['Abd.shepherd@gmail.com'],
                              cc: ['tofikdaowd@gmail.com'],
                              bcc: ['Shepherdova@gmail.com'],
                              isHTML: false,
                            );

                            await FlutterEmailSender.send(email);
                          },
                          icon: Icon(Icons.sentiment_dissatisfied),
                          label: Text(getLang(context, "send")))),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: WidthDevice * 0.8,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(" MQL5: "),
                              Expanded(
                                  child: FlatButton(
                                child: Text(
                                  "https://www.mql5.com/en/users/abo-hob",
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://www.mql5.com/en/users/abo-hob")) {
                                    launch(
                                        "https://www.mql5.com/en/users/abo-hob");
                                  }
                                },
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Telegram: "),
                              Expanded(
                                  child: FlatButton(
                                child: Text(
                                  "https://t.me/shepherdfx",
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://t.me/shepherdfx")) {
                                    launch("https://t.me/shepherdfx");
                                  }
                                },
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Facebook: "),
                              Expanded(
                                  child: FlatButton(
                                child: Text(
                                  "https://www.facebook.com/Shepherdfx/",
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://www.facebook.com/Shepherdfx/")) {
                                    launch(
                                        "https://www.facebook.com/Shepherdfx/");
                                  }
                                },
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text("twitter: "),
                              Expanded(
                                  child: FlatButton(
                                child: Text(
                                  "https://twitter.com/AbdShepherd",
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://twitter.com/AbdShepherd")) {
                                    launch("https://twitter.com/AbdShepherd");
                                  }
                                },
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text("YouTUBE: "),
                              Expanded(
                                  child: FlatButton(
                                child: Text(
                                  "https://www.youtube.com/channel/UCvIwh6MoBNDsxHBgNbYjMDw",
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://www.youtube.com/channel/UCvIwh6MoBNDsxHBgNbYjMDw")) {
                                    launch(
                                        "https://www.youtube.com/channel/UCvIwh6MoBNDsxHBgNbYjMDw");
                                  }
                                },
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Linked in : "),
                              Expanded(
                                  child: FlatButton(
                                child: Text(
                                  "https://www.linkedin.com/in/shepherd-software-corp-b6899022a/",
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://www.linkedin.com/in/shepherd-software-corp-b6899022a/")) {
                                    launch(
                                        "https://www.linkedin.com/in/shepherd-software-corp-b6899022a/");
                                  }
                                },
                              )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(height: 30,),
                              Container(
                                child:Text(getLang(context, "Mailing"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),)
                              ),
                              SizedBox(height: 30,),
                              Container(
                                  child:Text("Version : " + version,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),)
                              ),
                              SizedBox(height: 20,),
                              Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white70, width: 3),
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: AssetImage("images/logo.png"),
                                      fit: BoxFit.contain,
                                    )),
                                child: null,
                              ),
                              SizedBox(height: 20,),
                              Container(
                                  child:Text("2022 - "+DateTime.now().year.toString() +"  "+ getLang(context, "Mailing"),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                              ),
                              SizedBox(height: 20,),
                              Container(
                                  child:Text(getLang(context, "developer"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white70, width: 3),
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      image: AssetImage("images/Snapshot.png"),
                                      fit: BoxFit.contain,
                                    )),
                                child: null,
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                              child:Text("Telegram: @OSuleiman",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                          ),
                          SizedBox(height: 20,),
                          Container(
                              child:Text("Email: affinity.source.sy@gmail.com",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)
                          ),
                          SizedBox(height: 20,),
                        ],
                      )),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
