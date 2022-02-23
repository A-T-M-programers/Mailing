import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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


Member member = new Member();

String en_ar = "en";
bool notife = false;
late final checksignin;
late final PackageInfo packageInfo;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();
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
}
class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);

  MyAppstate createState() => MyAppstate();
}

class MyAppstate extends State<MyApp> {
  static final String AppIdOneSignal ="cc6f0e3f-bea7-478c-a743-230d2640c689";
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configOneSignel();

  }

  Future<void> configOneSignel()async
  {
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
  Widget build(BuildContext context) =>
      ChangeNotifierProvider(create: (context) =>
          ThemeProvider(),
  builder: (context, _)
  {
    return FutureBuilder(
        future: Init.instance.initialize(),
    builder: (context, AsyncSnapshot snapshot) {
      // Show splash screen while waiting for app resources to load:
      if (snapshot.connectionState == ConnectionState.waiting) {
        final themeProvider = Provider.of<ThemeProvider>(context);
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
          locale: Locale(en_ar,""),
          localeResolutionCallback: (currentLang,supportLang){
            if(currentLang!=null){
              for(Locale locale in supportLang){
                if(locale.languageCode==currentLang.languageCode){
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
          locale: Locale(en_ar,""),
          localeResolutionCallback: (currentLang,supportLang){
            if(currentLang!=null){
              for(Locale locale in supportLang){
                if(locale.languageCode==currentLang.languageCode){
                  return currentLang;
                }
              }
            }
            return supportLang.first;
          },
          home: checksignin? home_page(): LoginPage(),
        );
      }
    }
    );
  });
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
      lightMode ? const Color(0xffe1f5fe) : const Color(0xffe1f5fe),
      body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children:[ Center(
          child:  Container(height: MediaQuery
              .of(context)
              .size
              .height,width: MediaQuery
              .of(context)
              .size
              .width, child:lightMode
              ? Image.asset('images/iPhone 12 Pro Max – 14.png',fit: BoxFit.fill)
              : Image.asset('images/iPhone 12 Pro Max – 14.png',fit: BoxFit.fill,)
    )),
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height/5,
            width: MediaQuery
                .of(context)
                .size
                .height/5,
            child:CircularProgressIndicator())
    ])
    );
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
