import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mosques_donation_app/widgets/custom_text_field.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up_screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  _signUp(BuildContext context) async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: trans(context, 'please_fill_all_information'));
      return;
    } else {
      setState(() {
        _isLoading = true;
      });

      await HttpService.registerUser(
        context,
        _nameController.text,
        _phoneController.text,
        _passwordController.text,
      ).then((user) => user != null ? Navigator.pop(context) : null);

      setState(() {
        _isLoading = false;
      });
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
                    trans(context, 'sign_up'),
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Text(
                    trans(context, 'please_enter_your_information_to_signup'),
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
                  horizontal: SizeConfig.blockSizeHorizontal * 2,
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
                        PhoneTextField(
                          hint: trans(context, 'name'),
                          controller: _nameController,
                          obscure: false,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 4),
                        PhoneTextField(
                          hint: trans(context, 'phone'),
                          controller: _phoneController,
                          obscure: false,
                          textInputType: TextInputType.number,
                          textInputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 4),
                        PhoneTextField(
                          hint: trans(context, 'password'),
                          controller: _passwordController,
                          obscure: true,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 4),
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 2),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                : DefaultButton(
                                    text: trans(context, 'sign_up'),
                                    press: () => _signUp(context),
                                  ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(trans(context, 'already_have_an_account')),
                              SizedBox(width: SizeConfig.blockSizeHorizontal),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  trans(context, 'sign_in_now'),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
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

  // buildOTPRow(BuildContext context) {
  //   return PinFieldAutoFill(
  //     controller: codeController,
  //     decoration: UnderlineDecoration(
  //       textStyle: TextStyle(fontSize: 20, color: Colors.black),
  //       colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
  //     ),
  //     currentCode: _code,
  //     onCodeSubmitted: (code) {
  //       codeController.text = code;
  //     },
  //     onCodeChanged: (code) {
  //       if (code.length == 6) {
  //         FocusScope.of(context).requestFocus(FocusNode());
  //       }
  //     },
  //   );
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
  //}
}
