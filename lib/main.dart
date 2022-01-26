import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mailing/Home_Page.dart';

import 'Class/Class_database.dart';
import 'Login_Mailing.dart';
import 'l10n/applocal.dart';


Member member = new Member();

String en_ar = "en";
bool notife = false;
late final checksignin;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
    builder: (context, AsyncSnapshot snapshot) {
      // Show splash screen while waiting for app resources to load:
      if (snapshot.connectionState == ConnectionState.waiting) {
        return MaterialApp(

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
        return MaterialApp(

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
  }
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
