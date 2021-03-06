import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/code_screen.dart';
import 'package:flutter_app/Screens/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/amplitude.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String error = '';
  var controller = new MaskedTextController(mask: '+7 000 000-00-00');
  GlobalKey<ButtonState> buttonStateKey = new GlobalKey<ButtonState>();

  @override
  void initState() {
    super.initState();
    controller.beforeChange = (String previous, String next) {
      if(controller.text == '8') {
        controller.updateText('+7 ');
      }
      return true;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(left: 0, top: 30),
                        child: Container(
                            height: 40,
                            width: 60,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, right: 10),
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            ))),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 90),
                child: Text(
                  'Ваш номер телефона',
                  style: TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 150),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: Text(
                            'Россия +7',
                            style:
                            TextStyle(fontSize: 17, color: Color(0xFF979797)),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextField(
                              autofocus: true,
                              controller: controller,
                              style: TextStyle(fontSize: 28),
                              textAlign: TextAlign.start,
                              maxLength: 16,
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
                                hintStyle: TextStyle(
                                  color: Color(0xFFC0BFC6),
                                ),
                                hintText: '+7918 888-88-88',
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFD6F6D)),
                                ),
                              ),
                              onChanged: (String value) {
                                if(value == '+7 8'){
                                  controller.text = '+7';
                                }
                                if(value.length == 16){
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                }
                                currentUser.phone = value;
                                if (value.length > 0 &&
                                    buttonStateKey.currentState.color !=
                                        Color(0xFFFE534F)) {
                                  buttonStateKey.currentState.setState(() {
                                    buttonStateKey.currentState.color =
                                        Color(0xFFFE534F);
                                  });
                                } else if (value.length == 0 &&
                                    buttonStateKey.currentState.color !=
                                        Color(0xF3F3F3F3)) {
                                  buttonStateKey.currentState.setState(() {
                                    buttonStateKey.currentState.color =
                                        Color(0xF3F3F3F3);
                                  });
                                }
                              },
                            )
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 80, top: 10),
                  child: Text.rich(
                    TextSpan(
                        text:
                        'Нажимая кнопку “Далее”, вы принимете условия\n',
                        style: TextStyle(
                            color: Color(0x97979797), fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Пользовательского соглашения',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (await Internet.checkConnection()) {
                                    if (await canLaunch(
                                        "https://faem.ru/legal/agreement")) {
                                      await launch(
                                          "https://faem.ru/legal/agreement");
                                    }
                                  } else {
                                    noConnection(context);
                                  }
                                }),
                          TextSpan(
                            text: ' и ',
                          ),
                          TextSpan(
                              text: 'Политики\nконфиденцальности',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (await Internet.checkConnection()) {
                                    if (await canLaunch(
                                        "https://faem.ru/privacy")) {
                                      await launch(
                                          "https://faem.ru/privacy");
                                    }
                                  } else {
                                    noConnection(context);
                                  }
                                }),
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Button(key: buttonStateKey, color: Color(0xF3F3F3F3),)
              ),
            ),
          ],
        ));
  }
}

class Button extends StatefulWidget {
  Color color;

  Button({Key key, this.color}) : super(key: key);

  @override
  ButtonState createState() {
    return new ButtonState(color);
  }
}

class ButtonState extends State<Button> {
  String error = '';
  Color color = Color(0xFFF3F3F3);

  ButtonState(this.color);

  String validateMobile(String value) {
    String pattern = r'(^(?:[+]?7)[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Укажите норер';
    } else if (!regExp.hasMatch(value)) {
      return 'Указан неверный номер';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      child: Text('Далее',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.white)),
      color: color,
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.only(left: 120, top: 20, right: 120, bottom: 20),
      onPressed: () async {
        if (await Internet.checkConnection()) {
          currentUser.phone = currentUser.phone.replaceAll('-', '');
          currentUser.phone = currentUser.phone.replaceAll(' ', '');
          print(currentUser.phone);
          if (validateMobile(currentUser.phone) == null) {
            if (currentUser.phone[0] != '+') {
              currentUser.phone = '+' + currentUser.phone;
            }
            if (currentUser.phone != necessaryDataForAuth.phone_number) {
              necessaryDataForAuth.name = null;
              currentUser.isLoggedIn = false;
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new CodeScreen(),
                ),
              );
            } else {
              print(necessaryDataForAuth.refresh_token);
              String refresh_token_oppai = await NecessaryDataForAuth.refreshToken(necessaryDataForAuth.refresh_token);
              if (refresh_token_oppai == null) {
                currentUser.isLoggedIn = false;
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new CodeScreen(),
                  ),
                );
              }
              else {
                necessaryDataForAuth.refresh_token = refresh_token_oppai;
                currentUser.isLoggedIn = true;
                await AmplitudeAnalytics.analytics.setUserId(necessaryDataForAuth.phone_number);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false);
              }
            }
          } else {
            setState(() {
              error = 'Указан неверный номер';
            });
          }
        } else {
          noConnection(context);
        }
      },
    );
  }
}