import 'package:toast/toast.dart';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/lang/localss.dart';
import 'package:warehouse/pages/LocalHelper.dart';
import 'package:warehouse/pages/splashPage.dart';
import 'package:warehouse/repository/drugRepository.dart';
import 'package:warehouse/response/registerResponse.dart';
import 'package:warehouse/pages/drugPage.dart';

class profile extends StatefulWidget {
  @override
  _profile createState() => new _profile();
}

class _profile extends State<profile> {
  GlobalKey<FormState> _keyFormDeposit = GlobalKey();
  final _pass = new TextEditingController();
  ProgressDialog pr;
  final _min = new TextEditingController();
  bool monVal = false;
  SpecificLocalizationDelegate _specificLocalizationDelegate;
  String langSave;

  Future navigationPage() async {
    var preferences = await SharedPreferences.getInstance();

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
  }

  Widget showDialogLang() {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/alert.png'),
                    fit: BoxFit.fill)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    AppLocalizations().lbChangeL,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.praimarydark),
                  ),
                ),
                GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('English'),
                    ),
                    onTap: () async {
                      var preferences = await SharedPreferences.getInstance();

                      AppLocalizations().locale == 'en';
                      helper.onLocaleChanged(new Locale("en"));
                      AppLocalizations.load(new Locale("en"));
                      preferences.setString('lang', 'en');

                      preferences.remove('sessionId');

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Directionality(
                                  textDirection: langSave == 'ar'
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  child: Splash())),
                          ModalRoute.withName("/Home"));
                    }),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('العربية'),
                  ),
                  onTap: () async {
                    String lang = AppLocalizations().locale;
                    var preferences = await SharedPreferences.getInstance();

// Save a value

                    AppLocalizations().locale == 'ar';
                    helper.onLocaleChanged(new Locale("ar"));
                    AppLocalizations.load(new Locale("ar"));
                    preferences.setString('lang', 'ar');

                    preferences.remove('sessionId');

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Directionality(
                                textDirection: langSave == 'ar'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Splash())),
                        ModalRoute.withName("/Home"));
                  },
                ),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    navigationPage();
    pr = new ProgressDialog(context);
    pr.update(
      progress: 50.0,
      message: AppLocalizations().lbWait,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.praimarydark))),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }

  onLocaleChange(Locale locale) {
    _specificLocalizationDelegate = new SpecificLocalizationDelegate(locale);
  }

  @override
  Widget build(BuildContext context) {
    helper.onLocaleChanged = onLocaleChange;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            AppLocalizations().lbWareI,
          ),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations().lbDrug,
                            style:
                                TextStyle(color: Colors.greyapp, fontSize: 17),
                          ),
                          new Spacer(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.greyapp,
                              size: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Directionality(
                              textDirection: langSave == 'ar'
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: drugPage(langSave)),
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.greyapp,
                    height: 1,
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return showDialogLang();
                            });
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations().lbChangeL,
                              style: TextStyle(
                                  color: Colors.greyapp, fontSize: 17),
                            ),
                            new Spacer(),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.greyapp,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      )),
                  Divider(
                    color: Colors.greyapp,
                    height: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations().lbChangeP,
                            style:
                                TextStyle(color: Colors.greyapp, fontSize: 17),
                          ),
                          new Spacer(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.greyapp,
                              size: 16,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return showDialogwindowAdd();
                            });
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.greyapp,
                    height: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations().lbAddM,
                            style:
                                TextStyle(color: Colors.greyapp, fontSize: 17),
                          ),
                          new Spacer(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.greyapp,
                              size: 16,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyDialog(this);
                            });
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.greyapp,
                    height: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: GestureDetector(
                        onTap: () {
                          _buildSubmitForm(context);
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Center(
                              child: Text(
                                AppLocalizations().lbLog,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.praimarydark),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget showDialogwindowAdd() {
    return AlertDialog(
      title: Text(AppLocalizations().lbChangeP),
      content: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _keyFormDeposit,
            child: Column(
              children: <Widget>[
                //Commission amount
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 35, 15, 0),
                  child: Material(
                    color: Colors.white,
                    child: TextFormField(
                      controller: _pass,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: AppLocalizations().lbNewP,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ), //can also add icon to the end of the textfiled
                        //  suffixIcon: Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(15, 50, 15, 10),
                  child: new RaisedButton(
                      onPressed: () {
                        if (!_keyFormDeposit.currentState.validate()) {
                          print("Not Validate Form");

                          return 0;
                        }
                        _keyFormDeposit.currentState.save();

                        _buildSubmitFormCo(context);
                      }
                      //  textColor: Colors.yellow,colorBrightness: Brightness.dark,
                      ,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      disabledColor: Colors.yellow,
                      child: Center(
                        child: new Text(
                          AppLocalizations().lbDone,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSubmitFormCo(BuildContext context) async {
    pr.show();
    var preferences = await SharedPreferences.getInstance();
    String sessionId = preferences.getString('sessionId');
    String wareid = preferences.getString('id');

    Map<String, dynamic> data = {"Id": wareid, "Password": _pass.text};
    //  ProjectBloc().addProjectRevnue(data);
    // BankBloc().addBankCommission(data);
    print(data);
    final DurgsRepository _repository = DurgsRepository();
    registerResponse response =
        await _repository.chacnePass(sessionId, data, langSave);

    //  GeneralResponse response = await _repository.addProjectRevnue(data);
    if (response.code == '1') {
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      Navigator.pop(context, true);
    } else {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      Toast.show(response.msg.toString(), context,
          duration: 4, gravity: Toast.BOTTOM);
    }
  }

  _buildSubmitForm(BuildContext context) async {
    var preferences = await SharedPreferences.getInstance();

    preferences.remove('sessionId');

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => Directionality(
            textDirection:
                langSave == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Splash()),
      ),
    );
  }

  _buildSubmitFormMin(BuildContext context, bool ischeck, String min) async {
    pr.show();
    var preferences = await SharedPreferences.getInstance();
    String sessionId = preferences.getString('sessionId');

    Map<String, dynamic> data = {
      "MinOrderValue": min,
      "DeliveryStatus": ischeck == true ? '1' : '0'
    };
    //  ProjectBloc().addProjectRevnue(data);
    // BankBloc().addBankCommission(data);
    print(data);
    final DurgsRepository _repository = DurgsRepository();
    registerResponse response =
        await _repository.addDeleviry(sessionId, data, langSave);

    //  GeneralResponse response = await _repository.addProjectRevnue(data);
    if (response.code == '1') {
      pr.hide().then((isHidden) {
        print(isHidden);
      });

      Navigator.pop(context, true);
    } else {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      Toast.show(response.msg.toString(), context,
          duration: 4, gravity: Toast.BOTTOM);
    }
  }
}

class MyDialog extends StatefulWidget {
  _profile bankA;

  MyDialog(this.bankA);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  GlobalKey<FormState> _keyFormDeposit = GlobalKey();
  final _pass = new TextEditingController();
  ProgressDialog pr;
  final _min = new TextEditingController();
  bool monVal = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations().lbMin),
      content: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _keyFormDeposit,
            child: Column(
              children: <Widget>[
                //Commission amount

                Padding(
                  padding: EdgeInsets.fromLTRB(15, 35, 15, 0),
                  child: Material(
                    color: Colors.white,
                    child: TextFormField(
                      controller: _min,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: AppLocalizations().lbMinP,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ), //can also add icon to the end of the textfiled
                        //  suffixIcon: Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 35, 15, 0),
                  child: Material(
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: monVal,
                            onChanged: (bool value) {
                              setState(() {
                                monVal = value;
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(AppLocalizations().lbDev),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 50, 15, 10),
                  child: new RaisedButton(
                      onPressed: () {
                        if (!_keyFormDeposit.currentState.validate()) {
                          print("Not Validate Form");

                          return 0;
                        }
                        _keyFormDeposit.currentState.save();

                        widget.bankA
                            ._buildSubmitFormMin(context, monVal, _min.text);
                      }
                      //  textColor: Colors.yellow,colorBrightness: Brightness.dark,
                      ,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      disabledColor: Colors.yellow,
                      child: Center(
                        child: new Text(
                          AppLocalizations().lbDone,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
