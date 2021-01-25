import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/screens/signup/widgets/countdown.dart';
import 'package:mosques_donation_app/screens/signup/widgets/phone_text_field.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:mosques_donation_app/widgets/no_account_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../tab_screens.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up_screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showOtpScreen = false;
  bool showCountdown = false;
  String verificationId;
  String status;
  String _code;

  int counter = 0;
  AnimationController _controller;
  int levelClock = 120;

  // void _incrementCounter() {
  //   setState(() {
  //     counter++;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
  }

  void startCountdown() {
    _controller.forward();
  }

  Future loginUser(String phone, BuildContext context) async {
    await SmsAutoFill().listenForCode;

    setState(() {
      showOtpScreen = true;
    });
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserCredential result = await _auth.signInWithCredential(credential);
        print('token ${credential.token}');
        print('providerId ${credential.providerId}');
        print('signInMethod ${credential.signInMethod}');

        User user = result.user;

        if (user != null) {
          await prefs.setBool('authenticated', true);
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
        } else {
          print('Error');
        }

        // This callback is only called when verification is done automatically
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          status = '${authException.message}';

          print("Error message: " + status);
          if (authException.message.contains('not authorized'))
            status = 'Something has gone wrong, please try later';
          else if (authException.message.contains('Network'))
            status = 'Please check your internet connection and try again';
          else
            status = 'Something has gone wrong, please try later';
        });
      },
      codeSent: (String id, [int forceResendingToken]) {
        print('id $id');
        print('forceResendingToken $forceResendingToken');

        setState(() {
          showOtpScreen = true;
          verificationId = id;
        });
      },
      codeAutoRetrievalTimeout: (String id) async {
        verificationId = id;
        setState(() {
          print('Code sent to $phone');
          status = "\nEnter the code sent to " + phone;
        });
      },
    );
  }

  verifyOTPCode() async {
    print('we are here');
    setState(() {
      showCountdown = true;
    });

    startCountdown();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final code = codeController.text.trim();
    print(code);
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );
    print(credential);

    UserCredential result = await _auth.signInWithCredential(credential);

    User user = result.user;
    print(user);

    if (user != null) {
      print('we are here');
      await prefs.setBool('authenticated', true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabsScreen(),
        ),
      );
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    !showOtpScreen
                        ? trans(context, 'sign_up')
                        : trans(context, 'otp_verification'),
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Text(
                    !showOtpScreen
                        ? trans(context, 'please_enter_a_mobile_number')
                        : trans(context, 'please_enter_the_otp_code'),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 9),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        !showOtpScreen
                            ? buildPhoneTextField(context)
                            : buildOTPRow(context),
                        SizedBox(height: SizeConfig.blockSizeVertical * 4),
                        !showOtpScreen
                            ? Container()
                            : showCountdown
                                ? Countdown(
                                    animation: StepTween(
                                      begin: levelClock,
                                      end: 0,
                                    ).animate(_controller),
                                  )
                                : Container(),
                        SizedBox(height: SizeConfig.blockSizeVertical * 5),
                        !showOtpScreen
                            ? Container()
                            : AccountText(
                                question:
                                    '${trans(context, 'didnt_get_a_code')} ',
                                action: trans(context, 'send_again'),
                              ),
                        !showOtpScreen
                            ? Container()
                            : SizedBox(
                                height: SizeConfig.blockSizeVertical * 8,
                              ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: DefaultButton(
                              text: !showOtpScreen
                                  ? trans(context, 'continue')
                                  : trans(context, 'verify'),
                              press: () async {
                                if (!showOtpScreen) {
                                  if (phoneNoController.text.isNotEmpty) {
                                    setState(() {
                                      showOtpScreen = true;
                                    });
                                    loginUser(
                                        countryCodeController.text +
                                            phoneNoController.text,
                                        context);
                                  }
                                } else {
                                  verifyOTPCode();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPhoneTextField(BuildContext context) {
    countryCodeController.text = '+965';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: PhoneTextField(
              readOnly: true,
              controller: countryCodeController,
            ),
          ),
          Expanded(
            flex: 3,
            child: PhoneTextField(
              readOnly: false,
              controller: phoneNoController,
            ),
          ),
        ],
      ),
    );
  }

  buildOTPRow(BuildContext context) {
    return PinFieldAutoFill(
      controller: codeController,
      decoration: UnderlineDecoration(
        textStyle: TextStyle(fontSize: 20, color: Colors.black),
        colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
      ),
      currentCode: _code,
      onCodeSubmitted: (code) {
        codeController.text = code;
      },
      onCodeChanged: (code) {
        if (code.length == 6) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
    );
    // Container(
    //   child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         OTPDigitTextFieldBox(first: true, last: false),
    //         OTPDigitTextFieldBox(first: false, last: false),
    //         OTPDigitTextFieldBox(first: false, last: false),
    //         OTPDigitTextFieldBox(first: false, last: false),
    //         OTPDigitTextFieldBox(first: false, last: false),
    //         OTPDigitTextFieldBox(first: false, last: true),
    //       ],
    //     )
    //   ]),
    // );
  }
}
