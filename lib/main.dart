import 'dart:convert';
import 'dart:io';

import 'package:crypt/crypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mailing/Class/Constant.dart';
import 'package:mailing/Class/Theme_Dark_and_Light.dart';
import 'package:mailing/Home_Page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'Class/Class_database.dart';
import 'Class/Notification_OneSignal.dart';
import 'Login_Mailing.dart';
import 'l10n/applocal.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

Member member = new Member();

String en_ar = "en";
bool notife = false;
late final checksignin;
late final PackageInfo packageInfo;
dynamic mode;

Future<bool> CheckVersion(String version) async {
  try {
    var secret = Crypt.sha256("select_version");
    Uri url = Uri(
        host: host, path: 'Mailing_API/Select/get_Message.php', scheme: scheme);
    var response =
    await http.post(url, body: {'version': version, 'secret': '$secret'});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return false;
    } else {
      return true;
    }
  }catch(ex){
    return false;

  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
  try {
    bool check = await CheckVersion(packageInfo.version);
    if (check) {
      await MobileAds.instance.initialize();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          checksignin = await member.readFileLogIn();
          runApp(MyApp());
        }
      } on SocketException catch (_) {
        showtoast("Check Internet");
      }
    } else {
      runApp(MyApp2());
    }
  } on SocketException catch (_) {
    showtoast("Check Internet");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  MyAppstate createState() => MyAppstate();
}

class MyAppstate extends State<MyApp> {
  static final String AppIdOneSignal = "a2e05d33-3eed-4ec0-8961-d5df96631789";

  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configOneSignel();
  }

  Future<void> configOneSignel() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(AppIdOneSignal);
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
    Notification_OneSignal_class.callback_before_notifi();
    Notification_OneSignal_class.open_notifi();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        return FutureBuilder(
            future: Init.instance.initialize(),
            builder: (context, AsyncSnapshot snapshot) {
              // Show splash screen while waiting for app resources to load:
              if (snapshot.connectionState == ConnectionState.waiting) {
                final themeProvider = Provider.of<ThemeProvider>(context);
                StorageManager.readData("mode").then((value) {
                  mode = value;
                });
                if(mode == "light"){
                  themeProvider.themeMode = ThemeMode.light;
                }else{
                  themeProvider.themeMode = ThemeMode.dark;
                }
                return MaterialApp(
                  themeMode: themeProvider.themeMode,
                  theme: MyThemesApp.lightTheme,
                  darkTheme: MyThemesApp.darkTheame,
                  localizationsDelegates: [
                    AppLocale.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [
                    Locale('en', ''), // English, no country code
                    Locale('ar', ''), // Arabic, no country code
                  ],
                  debugShowCheckedModeBanner: false,
                  locale: Locale(en_ar, ""),
                  localeResolutionCallback: (currentLang, supportLang) {
                    if (currentLang != null) {
                      for (Locale locale in supportLang) {
                        if (locale.languageCode == currentLang.languageCode) {
                          return currentLang;
                        }
                      }
                    }
                    return supportLang.first;
                  },
                  home: Splash(),
                );
              } else {
                final themeProvider = Provider.of<ThemeProvider>(context);
                StorageManager.readData("mode").then((value) {
                  mode = value;
                });
                if(mode == "light"){
                  themeProvider.themeMode = ThemeMode.light;
                }else{
                  themeProvider.themeMode = ThemeMode.dark;
                }
                return MaterialApp(
                  themeMode: themeProvider.themeMode,
                  theme: MyThemesApp.lightTheme,
                  darkTheme: MyThemesApp.darkTheame,
                  localizationsDelegates: [
                    AppLocale.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [
                    Locale('en', ''), // English, no country code
                    Locale('ar', ''), // Arabic, no country code
                  ],
                  debugShowCheckedModeBanner: false,
                  locale: Locale(en_ar, ""),
                  localeResolutionCallback: (currentLang, supportLang) {
                    if (currentLang != null) {
                      for (Locale locale in supportLang) {
                        if (locale.languageCode == currentLang.languageCode) {
                          return currentLang;
                        }
                      }
                    }
                    return supportLang.first;
                  },
                  home: checksignin ? home_page() : LoginPage(),
                );
              }
            });
      });
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Colors.black,
        body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          Center(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                          'images/Screen.png',
                          fit: BoxFit.contain,
                        ))),
          Container(
            margin: EdgeInsets.only(bottom: 10),
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.height / 8,
              child: CircularProgressIndicator(color: Colors.white70,))
        ]));
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 3));
  }
}

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          bottomSheet: ListTile(
            leading: Text(
              "Check Update Your Version: " + packageInfo.version,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
            trailing: TextButton(onPressed: () => exit(0), child: Text("OK")),
          ),
          body: Splash()),
    );
  }
}