import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../size_config.dart';

class PhoneTextField extends StatelessWidget {
  final bool readOnly;
  final TextEditingController controller;

  const PhoneTextField({Key key, this.readOnly, this.controller})
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
              autofocus: true,
              showCursor: false,
              readOnly: readOnly,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 5),
                counter: Offstage(),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                // hintStyle: MyStyles.hintTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
