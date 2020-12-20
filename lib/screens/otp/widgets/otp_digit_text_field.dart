import 'package:flutter/material.dart';

class OTPDigitTextFieldBox extends StatelessWidget {
  final bool first;
  final bool last;
  const OTPDigitTextFieldBox(
      {Key key, @required this.first, @required this.last})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          height: 55,
          child: Card(
            elevation: 4,
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: TextField(
                autofocus: true,
                onChanged: (value) {
                  if (value.length == 1 && last == false) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.length == 0 && first == false) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                showCursor: false,
                readOnly: false,
                textAlign: TextAlign.center,
                // style: MyStyles.inputTextStyle,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  counter: Offstage(),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "_",
                  // hintStyle: MyStyles.hintTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
