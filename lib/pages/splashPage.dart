import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:warehouse/lang/localss.dart';
import 'package:warehouse/pages/homePage.dart';
import 'package:warehouse/pages/loginPage.dart';


class Splash extends StatefulWidget {
  @override
  _Splash createState() => new _Splash();
}

class _Splash extends State<Splash> {

  SpecificLocalizationDelegate _specificLocalizationDelegate;
  String langSave;




  Future navigationPage() async {

    var preferences = await SharedPreferences.getInstance();
    String sessionId = preferences.getString('sessionId');
    langSave = preferences.getString('lang');
    print("lang saved == $langSave");
    //langSave=lang1;
    if (langSave == 'ar') {
      _specificLocalizationDelegate =
          SpecificLocalizationDelegate(new Locale("ar"));

      AppLocalizations.load(new Locale("ar"));
    } else {
      _specificLocalizationDelegate =
          SpecificLocalizationDelegate(new Locale("en"));
      AppLocalizations.load(new Locale("en"));
    }
    if(sessionId!=null){
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Directionality(
            textDirection:
            langSave == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child:homePage()),
        ),
      );
    }else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Directionality(
            textDirection:
            langSave == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child:login()),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      title: new Text(
        'Welcome In Warehouse App',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.praimarydark,
            fontSize: 20.0),
      ),
      seconds: 4,
      navigateAfterSeconds: navigationPage(),
      image: new Image.asset(
        'assets/images/warelogos.png',
      ),
      backgroundColor: Colors.white,
      // styleTextUnderTheLoader: new TextStyle(),

      photoSize: 150.0,
      // onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.praimarydark,
    );
  }
}
