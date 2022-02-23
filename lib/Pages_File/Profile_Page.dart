import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypt/crypt.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailing/Class/Class_database.dart';
import 'package:mailing/Class/Constant.dart';
import 'package:mailing/Class/Get_Photo.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/Login_Mailing.dart';
import 'package:mailing/Validate.dart';
import 'package:mailing/l10n/applocal.dart';
import 'package:mailing/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

late String Path_member_image = "";
late get_photo set_image_member = get_photo();
GoogleSignIn googleSignIn = GoogleSignIn();
late double totalprice = 0.0;
late int count_message_buy = 0;

GoogleSignInAccount? _currentUser;

class Profile extends StatefulWidget {
  const Profile({required this.member, required this.type});

  @override
  Profile_State createState() => Profile_State();

  final Member member;
  final String type;
}

class Profile_State extends State<Profile> {
  late TextEditingController Profile_Email, Profile_Password;
  late double WidthDevice, HieghDevice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!checkadmin) {
      count_message_buy = 0;
      totalprice = 0.0;
      for (int i = 0; i < notification_message.length; i++) {
        if (notification_message[i].type == "S" &&
            notification_message[i].Notifi_State!) {
          count_message_buy++;
          messaging.forEach((element) {
            if (element.MessageID == notification_message[i].messaging_id) {
              totalprice += element.getmessageprice;
            }
          });
        }
      }
    }else{

    }

    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    if (widget.member != null && widget.type == "info") {
      Profile_Email = TextEditingController(text: widget.member.Email);
      Profile_Password = TextEditingController();
    } else {
      Profile_Email = TextEditingController();
      Profile_Password = TextEditingController();
    }

    return Container(
        margin: EdgeInsets.only(top: 20, bottom: HieghDevice / 3),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  width: WidthDevice / 1.15,
                  margin: EdgeInsets.only(top: 140, left: 20, right: 20),
                  child: Column(
                    children: [
                      Text(
                        '${getLang(context, "Email")}',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline2!.color,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                          child: TextFormField(
                        readOnly: true,
                        controller: Profile_Email,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () async{
                              //await showSelectionDialogChangeEmail(context);
                              setState(() {
                                print("Hello");
                              });
                            },
                            icon: Icon(Icons.edit_outlined),
                          ),
                          hintText: "Exampl@gmail.com",
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).shadowColor, width: 5),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  width: WidthDevice / 1.15,
                  margin: EdgeInsets.only(top: 260, left: 20, right: 20),
                  child: Column(
                    children: [
                      Text(
                        '${getLang(context, "Password")}',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline2!.color,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                          child: TextFormField(
                        readOnly: true,
                        controller: Profile_Password,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: ()async {
                              await SendEmail(context);
                              setState(() {
                                print("Hello");
                              });
                            },
                            icon: Icon(Icons.edit_outlined),
                          ),
                          hintText: "***********",
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).shadowColor, width: 5),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: Stack(children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Validation.isValidnull(
                                                Path_member_image)
                                            ? show_photo(
                                                path: Path_member_image,
                                                type: "D",
                                              )
                                            : show_photo(
                                                path: widget.member.getImage,
                                                type: "N",
                                              )));
                          });
                        },
                        child: Path_member_image.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(Path_member_image)),
                                      fit: BoxFit.fill),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context).shadowColor,
                                        blurRadius: 10)
                                  ],
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                ),
                                child: null,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.member.getImage,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context).shadowColor,
                                          blurRadius: 10)
                                    ],
                                    borderRadius: BorderRadius.circular(50),
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
                    Container(
                        margin: EdgeInsets.only(top: 62, left: 62),
                        child: IconButton(
                          onPressed: () async {
                            await set_image_member.showSelectionDialog(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => show_photo_member(
                                          path: set_image_member.path.path,member: widget.member,
                                        )));
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 30,
                          ),
                        ))
                  ]),
                ),
                Container(
                  width: WidthDevice,
                  margin: EdgeInsets.only(top: 380, left: 40, right: 20),
                  child: Text(
                    '${getLang(context, "Pay_Total")} '+ totalprice.toString() + r"$",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline2!.color,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  width: WidthDevice,
                  margin: EdgeInsets.only(top: 420, left: 40, right: 20),
                  child: Text(
                    '${getLang(context, "Sell_Message_Count")} '+count_message_buy.toString(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline2!.color,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            )));
  }

  Future<  void> _handleSignInwithgoogle() async {
    try {
      await googleSignIn.signOut();
      _currentUser = await googleSignIn.signIn();

      if (Validation.isValidnull(_currentUser!.email)) {
        String m = _currentUser!.email;
        var secret = Crypt.sha256("ubdate_member");
        Uri url =
        Uri(host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
        var response =
        await http.post(url, body: {'emailnew': m,'emailold': widget.member.getEmail,'image': member.getImage, 'secret': '$secret'});
        int status = response.statusCode;
        String errorMsg = '';
        switch (status) {
          case 200:
            {
              member.setEmail = _currentUser!.email;
              if (_currentUser!.photoUrl != null &&
                  _currentUser!.photoUrl != "") {
                member.setImage = _currentUser!.photoUrl!;
              }
              errorMsg = 'Successfully';
              break;
            }
          case 500:
            {
              errorMsg = 'Find user in app ,try change account';
              break;
            }
          case 401:
            {
              errorMsg = response.reasonPhrase!;
              break;
            }
          default:
            {
              errorMsg = 'Please check your internet connection and try again';
            }
        }

        if (errorMsg.isNotEmpty) {
          showtoast(errorMsg);
        }
      } else {
        showtoast("Please choose your email!!");
      }
    } catch (error) {
      print(error);
    }
    Navigator.pop(context);
  }

  Future<void> _handleSignInwithfacebook() async {
    try {
      final LoginResult result = await FacebookAuth.i.login();

      if (result.status == LoginStatus.success) {
        final data = await FacebookAuth.i.getUserData();
        member = Member.fromJson(data);

        if (Validation.isValidnull(member.getEmail)) {
          String m = member.getEmail;
          var secret = Crypt.sha256("ubdate_member");
          Uri url = Uri(
              host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
          var response =
          await http.post(url, body: {'emailnew': m,'emailold': widget.member.getEmail,'image': member.getImage, 'secret': '$secret'});
          int status = response.statusCode;
          String errorMsg = '';
          switch (status) {
            case 200:
              {
                errorMsg = 'Successfully';
                break;
              }
            case 500:
              {
                errorMsg = 'Something went wrong! please try again later';
                break;
              }
            case 401:
              {
                errorMsg = response.reasonPhrase!;
                break;
              }
            default:
              {
                errorMsg =
                'Please check your internet connection and try again';
              }
          }
          if (errorMsg.isNotEmpty) {
            showtoast(errorMsg);
          }
        } else {
          showtoast("Please choose your email!!");
        }
      }
    } catch (error) {
      print(error);
    }
    Navigator.pop(context);
  }
  showSelectionDialogChangeEmail(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to Change Email?"),
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                        child: Icon(
                          Icons.mark_email_read_sharp, color: Colors.redAccent, size: 70,),
                        onTap: _handleSignInwithgoogle
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Icon(
                        Icons.facebook_rounded, color: Colors.blue,
                        size: 70,),
                      onTap: _handleSignInwithfacebook
                    )
                  ],
                ),
              ));
        });
  }
}

class show_photo_member extends StatefulWidget {
  final String path;
  final Member member;

  show_photo_member({required this.path, required this.member});

  @override
  show_photo_member_state createState() => show_photo_member_state();
}

class show_photo_member_state extends State<show_photo_member> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).textTheme.headline1!.color,
          actions: [
            Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 10,
                      spreadRadius: 3)
                ]),
                margin: EdgeInsets.only(right: 20, left: 20),
                child: TextButton(
                    onPressed: () async {

                      member.setImage = await set_image_member.Upload(set_image_member.path);

                      var secret = Crypt.sha256("ubdate_member");
                      Uri url = Uri(
                          host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
                      var response =
                      await http.post(url, body: {'emailold': widget.member.getEmail,'image': member.getImage,'emailnew': '', 'secret': '$secret'});
                      int status = response.statusCode;
                      String errorMsg = '';
                      switch (status) {
                        case 200:
                          {
                            Path_member_image = "";
                            errorMsg = 'Successfully';
                            break;
                          }
                        case 500:
                          {
                            errorMsg = 'Something went wrong! please try again later';
                            break;
                          }
                        case 403:
                          {
                            errorMsg = response.reasonPhrase!;
                            break;
                          }
                        default:
                          {
                            errorMsg =
                            'Please check your internet connection and try again';
                          }
                      }
                      showtoast(errorMsg);
                      setState(() {
                        Path_member_image = set_image_member.path.path;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      getLang(context, "Choose"),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 17),
                    )))
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
            child: PhotoView(imageProvider: FileImage(File(widget.path)))));
  }
}

class MyDialogecheckpassProfile extends StatefulWidget {
  @override
  MyDialogecheckpassProfileState createState() => MyDialogecheckpassProfileState();
}

class MyDialogecheckpassProfileState extends State<MyDialogecheckpassProfile> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        title: const Text('Check number'),
        content: StatefulBuilder(builder: (context, setState) {
          return Column(
            // Then, the content of your dialog.
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: TextFormField(
                      controller: checknumber,
                      style: TextStyle(color: Colors.black38),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        hintStyle: TextStyle(color: Theme.of(context).textTheme.headline2!.color),
                        icon: Icon(
                          Icons.lock,
                        ),
                        hintText: "the number here",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => Validation.isValidnull(value!)
                          ? null
                          : '${getLang(context, "ValidPass")}',
                      onSaved: (val) => checknumber.text = val!,
                    )),
                Row(children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (Validation.isValidnull(checknumber.text)) {
                          if (verfipassProfile()) {
                            Navigator.pop(context, 'Cancel');
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => MyDialoge(
                                  ins_ubd: "ubd_mem_pass",
                                )).then((value) {
                              setState(() {
                                print(value);
                              });
                            });
                          } else {
                            showtoast("Number not correct!!");
                          }
                        }
                      });
                    },
                    child: const Text('OK'),
                  )
                ]),
              ]);
        }));
  }
}

SendEmail(BuildContext context) async {
      var res = await EmailAuth(sessionName: "Ubd_pass")
          .sendOtp(recipientMail: member.getEmail);
      if (res) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => MyDialogecheckpassProfile());
      }
}

bool verfipassProfile() {
  var res = EmailAuth(sessionName: "Ubd_pass")
      .validateOtp(recipientMail: member.getEmail, userOtp: checknumber.text);
  return res;
}
