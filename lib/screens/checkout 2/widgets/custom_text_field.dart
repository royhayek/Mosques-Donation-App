import 'package:flutter/material.dart';

import '../../../size_config.dart';

class CustomTextField extends StatelessWidget {
  final int maxLines;

  const CustomTextField({Key key, this.maxLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(
          SizeConfig.safeBlockHorizontal * 3,
        ),
      ),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 3,
            vertical: SizeConfig.blockSizeHorizontal * 3,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
