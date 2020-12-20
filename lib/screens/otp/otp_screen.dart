import 'package:flutter/material.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/widgets/no_account_text.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:mosques_donation_app/screens/otp/widgets/otp_digit_text_field.dart';

import '../tab_screens.dart';

class OTPScreen extends StatelessWidget {
  static String routeName = "/otp_screen";

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    print(SizeConfig.safeBlockHorizontal);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "OTP Verification",
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Please enter the OTP code sent to you by SMS",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 45),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildOTPRow(context),
                          SizedBox(height: 50),
                          AccountText(
                            question: "Didn't get a code? ",
                            action: 'Send again',
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: DefaultButton(
                              text: "Verify",
                              press: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  // if all are valid then go to success screen
                                  Navigator.pushReplacementNamed(
                                      context, TabsScreen.routeName);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildOTPRow(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OTPDigitTextFieldBox(first: true, last: false),
            OTPDigitTextFieldBox(first: false, last: false),
            OTPDigitTextFieldBox(first: false, last: false),
            OTPDigitTextFieldBox(first: false, last: true),
          ],
        )
      ]),
    );
  }
}
