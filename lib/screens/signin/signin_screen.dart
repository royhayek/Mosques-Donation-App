import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mosques_donation_app/models/user.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/screens/signup/signup_screen.dart';
import 'package:mosques_donation_app/widgets/custom_text_field.dart';
import 'package:mosques_donation_app/screens/tab_screens.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in_screen";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  AuthProvider authProvider;

  _signIn(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_phoneController.text.isEmpty && _passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: trans(context, 'please_fill_all_information'));
      return;
    } else {
      setState(() {
        _isLoading = true;
      });

      authProvider = Provider.of<AuthProvider>(context, listen: false);
      String _phone = _phoneController.value.text;
      String _password = _passwordController.value.text;

      User user = await authProvider.loginUser(context, _phone, _password);
      setState(() {
        _isLoading = false;
      });
      if (user != null) Navigator.pushNamed(context, TabsScreen.routeName);
    }

    setState(() {
      _isLoading = false;
    });
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
                    trans(context, 'sign_in'),
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Text(
                    trans(context, 'please_enter_your_login_information'),
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
                    SizedBox(height: SizeConfig.blockSizeVertical * 6),
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
                                    text: trans(context, 'sign_in'),
                                    press: () => _signIn(context),
                                  ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(trans(context, 'don\'t_have_an_account?')),
                              SizedBox(width: SizeConfig.blockSizeHorizontal),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, SignUpScreen.routeName),
                                child: Text(
                                  trans(context, 'sign_up_now'),
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
