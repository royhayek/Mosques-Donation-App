import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/no_account_text.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:mosques_donation_app/screens/otp/widgets/otp_digit_text_field.dart';

import '../tab_screens.dart';

class OTPScreen extends StatelessWidget {
  static String routeName = "/otp_screen";

  final User user;

  const OTPScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                    trans(context, 'otp_verification'),
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Text(
                    trans(context, 'please_enter_the_otp_code'),
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
                  horizontal: SizeConfig.blockSizeHorizontal * 5,
                ),
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
                          SizedBox(height: SizeConfig.blockSizeVertical * 8),
                          AccountText(
                            question: '${trans(context, 'didnt_get_a_code')} ',
                            action: trans(context, 'send_again'),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 8),
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: DefaultButton(
                              text: trans(context, 'verify'),
                              press: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
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
