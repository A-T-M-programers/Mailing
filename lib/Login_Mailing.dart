import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailing/Class/Notification_OneSignal.dart';
import 'package:mailing/Validate.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mailing/Home_Page.dart';
import 'package:http/http.dart' as http;

import 'Class/Class_database.dart';
import 'Class/Constant.dart';
import 'Validate.dart';
import 'l10n/applocal.dart';
import 'main.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

GoogleSignInAccount? _currentUser;



bool switch_check = true, checkbox_check = false;

String sendnumber = "";

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController checknumber = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Login_state createState() => Login_state();
}

enum SingingCharacter { lafayette, jefferson }

class Login_state extends State<LoginPage> {
  double WidthDevice = 0, HieghDevice = 0;


  @override
  Widget build(BuildContext context) {
    //Width Device
    WidthDevice = MediaQuery.of(context).size.width;
    //Hieght Device
    HieghDevice = MediaQuery.of(context).size.height;

    //Design
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(children: [
              Stack(alignment: AlignmentDirectional.topEnd, children: [
                Container(
                    child: Image.asset(
                  "images/Untitled.png",
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                )),
                Container(
                  alignment: Alignment.topRight,
                  height: 35,
                  margin: EdgeInsets.only(top: 30, right: 15),
                  child: RollingSwitch.icon(
                    animationDuration: Duration(milliseconds: 300),
                    height: 50,
                    width: 90,
                    innerSize: 40,
                    onChanged: (bool state) {
                      print('turned ${(state) ? 'on' : 'off'}');
                      notife = state;
                      if (!state) {
                        //state in true
                        en_ar = "en";
                        runApp(MyApp());
                      } else {
                        //state is false
                        en_ar = "ar";
                        runApp(MyApp());
                      }
                    },
                    rollingInfoRight: const RollingIconInfo(
                      icon: Icons.unpublished,
                      text: Text('Ar'),
                    ),
                    rollingInfoLeft: const RollingIconInfo(
                      icon: Icons.check,
                      backgroundColor: Colors.grey,
                      text: Text('En'),
                    ),
                    initialState: notife,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("images/Snapshot.png"),
                      fit: BoxFit.contain,
                    )),
                    child: null,
                  ),
                ),
                Center(
                    child: Column(children: [
                  SizedBox(
                    height: HieghDevice / 10,
                  ),
                  Text(
                    "${getLang(context, "Mailing")}",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(alignment: AlignmentDirectional.topCenter, children: [
                    Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 20),
                            height: 400,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 90,
                                    spreadRadius: 20,
                                    offset: Offset(30, 30)),
                                BoxShadow(color: Colors.white60),
                                BoxShadow(color: Colors.white60)
                              ],
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            width: WidthDevice / 1.2,
                            child: Column(children: [
                              Container(
                                  width: WidthDevice,
                                  margin: EdgeInsets.only(
                                      top: 40, left: 15, right: 15),
                                  child: Text(
                                    "${getLang(context, "Email")}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black38),
                                  )),
                              getelementemail(
                                  true, "Exampl@gmail.com", context),
                              Container(
                                  width: WidthDevice,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Text(
                                    "${getLang(context, "Password")}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black38),
                                  )),
                              getelamentpassword("Password", context),
                              ListTile(
                                  title: Text(
                                    "${getLang(context, "Save_Information")}",
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                  leading: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor: Colors.black38,
                                          primarySwatch: Colors.green),
                                      child: Checkbox(
                                          value: checkbox_check,
                                          onChanged: (value) {
                                            setState(() {
                                              checkbox_check = value!;
                                            });
                                          }))),
                              Container(
                                width: WidthDevice,
                                child: TextButton(
                                  child: Text(
                                      "${getLang(context, "Forgate_Password")}",
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                  onPressed: ()=>SendEmail(context),
                                ),
                              ),
                            ]))),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "${getLang(context, "Login")}",
                        style: TextStyle(fontSize: 25, color: Colors.black54),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 390),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        shape: BoxShape.circle,
                        color: Colors.amberAccent,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          String m = email.text;
                          String p = password.text;
                          m.trim();
                          p.trim();
                          if (m != '' && p != '') {
                            if(m == "admin@gmail.com" && p == "123456"){
                              member.setEmail = m;
                              member.setPassword = p;
                              if(checkbox_check) {
                                member.writeFileLogIn();
                              }
                              checkadmin = true;
                              email.text = password.text = "";
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => home_page()),
                                      (route) => false);
                            }else {
                              var secret = Crypt.sha256("mailing_login");
                              Uri url = Uri(
                                  host: host,
                                  path: 'Mailing_API/login.php',
                                  scheme: scheme);
                              var response = await http.post(url, body: {
                                'password': p,
                                'email': m,
                                'secret': '$secret'
                              });
                              int status = response.statusCode;
                              String errorMsg = '';
                              switch (status) {
                                case 200:
                                  {
                                    var membervar = jsonDecode(response.body);
                                    member.setEmail = email.text;
                                    if (membervar['MemberImage'] != null)
                                      member.setImage =
                                      membervar['MemberImage'];
                                    if (checkbox_check) {
                                      member.writeFileLogIn();
                                    }
                                    email.text = password.text = "";
                                    checkadmin = false;
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => home_page()),
                                            (route) => false);
                                    break;
                                  }
                                case 400:
                                  {
                                    errorMsg = response.reasonPhrase!;
                                    break;
                                  }
                                case 500:
                                  {
                                    errorMsg =
                                    'Something went wrong! please try again later';
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
                            }
                          } else {
                            showtoast("Please enter your email and your password!!");
                          }
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          size: 40,
                        ),
                        color: Colors.black38,
                      ),
                    )
                  ])
                ])),
              ]),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "${getLang(context, "Or_SignUp_With")}",
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  margin: EdgeInsets.only(bottom: HieghDevice / 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: 150,
                  child: SignInButton(
                    Buttons.Google,
                    text: "Google",
                    onPressed: _handleSignInwithgoogle,
                    elevation: 30,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: HieghDevice / 10),
                  width: 150,
                  child: SignInButton(Buttons.Facebook,
                      text: "Facebook",
                      onPressed: _handleSignInwithfacebook,
                      elevation: 30),
                )
              ])
            ])));
  }

  Future<void> _handleSignInwithgoogle() async {
    try {
      await googleSignIn.signOut();
      _currentUser = await googleSignIn.signIn();

      if (Validation.isValidnull(_currentUser!.email)) {
        String m = _currentUser!.email;
        var secret = Crypt.sha256("mailing_validemail");
        Uri url =
            Uri(host: host, path: 'Mailing_API/validemail.php', scheme: scheme);
        var response =
            await http.post(url, body: {'email': m, 'secret': '$secret'});
        int status = response.statusCode;
        String errorMsg = '';
        switch (status) {
          case 200:
            {
              email.text = _currentUser!.email;
              member.setEmail = _currentUser!.email;
              if (_currentUser!.photoUrl != null &&
                  _currentUser!.photoUrl != "") {
                member.setImage = _currentUser!.photoUrl!;
              }
              errorMsg = 'Email is an exsist Enter Password';
              break;
            }
          case 400:
            {
              email.text = _currentUser!.email;
              member.setEmail = _currentUser!.email;
              if (_currentUser!.photoUrl != null &&
                  _currentUser!.photoUrl != "") {
                member.setImage = _currentUser!.photoUrl!;
              }
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => MyDialoge(ins_ubd: "ins_mem",)).then((value) {
                setState(() {
                  print(value);
                });
              });
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
  }

  Future<void> _handleSignInwithfacebook() async {
    try {
      final LoginResult result = await FacebookAuth.i.login();

      if (result.status == LoginStatus.success) {

        final data = await FacebookAuth.i.getUserData();
        member = Member.fromJson(data);

        if (Validation.isValidnull(member.getEmail)) {
          String m = member.getEmail;
          var secret = Crypt.sha256("mailing_validemail");
          Uri url = Uri(
              host: host, path: 'Mailing_API/validemail.php', scheme: scheme);
          var response =
              await http.post(url, body: {'email': m, 'secret': '$secret'});
          int status = response.statusCode;
          String errorMsg = '';
          switch (status) {
            case 200:
              {
                email.text = member.getEmail;
                errorMsg = 'Email is an exsist Enter Password';
                break;
              }
            case 400:
              {
                email.text = member.getEmail;
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => MyDialoge(ins_ubd: "ins_mem",)).then((value) {
                  setState(() {
                    print(value);
                  });
                });
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
  }
}

void _handleSignUp(BuildContext buildContext,String type) async {
  if(type == "ins_mem") {
    String m = member.getEmail;
    String p = password.text;
    String i = member.getImage;
    if (m != '' && p != '') {
      var secret = Crypt.sha256("mailing_signup");
      Uri url = Uri(host: host, path: 'Mailing_API/signup.php', scheme: scheme);
      var response = await http.post(url,
          body: {'password': p, 'email': m, 'image': i, 'secret': '$secret'});
      int status = response.statusCode;
      String errorMsg = '';
      switch (status) {
        case 200:
          {
            errorMsg = response.reasonPhrase!;
            if (checkbox_check) {
              member.writeFileLogIn();
            }
            Navigator.pushAndRemoveUntil(
                buildContext,
                MaterialPageRoute(builder: (context) => home_page()),
                    (route) => false);
            break;
          }
        case 400:
          {
            errorMsg = response.reasonPhrase!;
            break;
          }
        case 500:
          {
            errorMsg = 'Something went wrong! please try again later';
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
      showtoast("Please enter your password!!");
    }
  }else if(type == "ubd_mem_pass"){
    var secret = Crypt.sha256("Ubdate_password");
    Uri url = Uri(
        host: host,
        path: 'Mailing_API/Ubdate/Ubdate_password.php',
        scheme: scheme);
    var response = await http.post(url, body: {
      'email': email.text,
      'password': password.text,
      'secret': '$secret'
    });
    String msg;

    if (response.statusCode == 200 && response.reasonPhrase == 'Saved Process') {
      member.writeFileLogIn();
      Navigator.pop(buildContext, 'Saved Process');
      msg = 'Saved Process';
      Navigator.pushAndRemoveUntil(
          buildContext,
          MaterialPageRoute(builder: (context) => home_page()),
              (route) => false);

    } else {
      msg=response.reasonPhrase ?? 'Please restart the app!!';
    }
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.cyanAccent,
        fontSize: 16.0
    );
  }
  }

Widget getelementemail(
    bool checkenable, String hint, BuildContext buildContext) {
  return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      // ignore: prefer_const_constructors
      child: TextFormField(
        enabled: checkenable,
        controller: email,
        style: TextStyle(color: Colors.black38),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          hintStyle: TextStyle(color: Colors.black38),
          icon: Icon(
            Icons.email,
            color: Colors.black38,
          ),
          hintText: hint,
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => Validation.isValidEmail(value!)
            ? null
            : '${getLang(buildContext, "ValidEmail")}',
        onSaved: (val) => email.text = val!,
      ));
}

Widget getelamentpassword(String hint, BuildContext buildContext) {
  return Container(
      // ignore: prefer_const_constructors
      margin: EdgeInsets.only(left: 10, right: 10),
      // ignore: prefer_const_constructors
      child: TextFormField(
        controller: password,
        obscureText: true,
        style: TextStyle(color: Colors.black38),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          hintStyle: TextStyle(color: Colors.black38),
          icon: Icon(
            Icons.lock,
            color: Colors.black38,
          ),
          hintText: hint,
        ),
        keyboardType: TextInputType.visiblePassword,
        validator: (value) =>
            Validation.isValidnull(value!) || Validation.isValidPass(value)
                ? null
                : '${getLang(buildContext, "ValidPass")}',
        onSaved: (val) => password.text = val!,
      ));
}

class MyDialoge extends StatefulWidget {
  @override
  MyDialogeState createState() => MyDialogeState();

  MyDialoge({required this.ins_ubd});

  late final String ins_ubd;
}

class MyDialogeState extends State<MyDialoge> {
  @override
  Widget build(BuildContext context) {
    bool check_ins_ubd = true;
    if(widget.ins_ubd=="ins_mem"){
      check_ins_ubd = true;
    }else{
      check_ins_ubd = false;
    }
      return AlertDialog(
          scrollable: true,
          title: const Text('Sign Up'),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
                // Then, the content of your dialog.
                mainAxisSize: MainAxisSize.min,
                children: [
                  getelementemail(false, member.getEmail, context),
                  getelamentpassword("Password", context),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.black38),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          hintStyle: TextStyle(color: Colors.black38),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.black38,
                          ),
                          hintText: "Password Confirm",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => Validation.isValidnull(value!) ||
                                Validation.isValidPass(value) ||
                                Validation.isValidPassConf(password.text, value)
                            ? null
                            : '${getLang(context, "ValidPass")}',
                        onSaved: (val) => password.text = val!,
                      )),
                  if (check_ins_ubd) ListTile(
                      title: Text(
                        "${getLang(context, "Save_Information")}",
                        style: TextStyle(color: Colors.black38),
                      ),
                      leading: Theme(
                          data: ThemeData(
                              unselectedWidgetColor: Colors.black38,
                              primarySwatch: Colors.green),
                          child: Checkbox(
                              value: checkbox_check,
                              onChanged: (value) {
                                setState(() {
                                  checkbox_check = value!;
                                });
                              }))) else SizedBox(height: 0) ,
                  Row(children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => _handleSignUp(context,widget.ins_ubd),
                      child: const Text('OK'),
                    )
                  ]),
                ]);
          }));
  }
}

class MyDialogecheckpass extends StatefulWidget {
  @override
  MyDialogecheckpassState createState() => MyDialogecheckpassState();
}

class MyDialogecheckpassState extends State<MyDialogecheckpass> {
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
                        hintStyle: TextStyle(color: Colors.black38),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black38,
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
                          if(verfipass()){
                          Navigator.pop(context, 'Cancel');
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => MyDialoge(ins_ubd: "ubd_mem_pass",)).then((value) {
                            setState(() {
                              print(value);
                            });
                          });
                          }else{
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

SendEmail(BuildContext context)async{
  if (Validation.isValidnull(email.text) &&
      Validation.isValidEmail(email.text)) {
    if(await member.checkemail(email.text)) {
      var res = await EmailAuth(sessionName: "Ubd_pass").sendOtp(
          recipientMail: email.text);
      if (res) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => MyDialogecheckpass());
      }
    }else{
      showtoast("Email not found in apllication");
    }
  }else{
    showtoast("Not email empty");
  }
}

bool verfipass(){
  var res = EmailAuth(sessionName: "Ubd_pass").validateOtp(recipientMail: email.text, userOtp: checknumber.text);
  return res;
}
void showtoast(String ms){
  Fluttertoast.showToast(
      msg: ms,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white70,
      fontSize: 16.0
  );
}
