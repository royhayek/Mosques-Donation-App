import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../size_config.dart';

class PhoneTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextInputType textInputType;
  final List<TextInputFormatter> textInputFormatters;
  final TextEditingController controller;

  const PhoneTextField(
      {Key key,
      this.controller,
      this.hint,
      this.obscure = false,
      this.textInputType,
      this.textInputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 1.2),
      child: Container(
        height: SizeConfig.blockSizeVertical * 7.2,
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              autofocus: false,
              obscureText: obscure,
              keyboardType: textInputType,
              inputFormatters: textInputFormatters,
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 3,
                ),
                counter: Offstage(),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
