import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../size_config.dart';

class CustomDropDown extends StatelessWidget {
  final String hint;
  final double height;
  final List<DropdownMenuItem> items;
  final int selectedValue;
  final Function onChanged;
  final bool enabled;

  const CustomDropDown({
    Key key,
    this.hint,
    this.height,
    this.items,
    this.selectedValue,
    this.onChanged,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(
          SizeConfig.safeBlockHorizontal * 3,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
        child: SizedBox(
          child: DropdownButtonFormField<int>(
            isDense: false,
            itemHeight: 60,
            decoration: InputDecoration.collapsed(hintText: ''),
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 4.8,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            hint: Text(
              hint,
              style: TextStyle(
                color: Color(0xFF8A8A8F),
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.safeBlockHorizontal * 5,
              ),
            ),
            onChanged: onChanged,
            items: items,
            value: selectedValue,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}

class CustomStringDropDown extends StatelessWidget {
  final String hint;
  final double height;
  final List<DropdownMenuItem> items;
  final String selectedValue;
  final Function onChanged;
  final bool enabled;

  const CustomStringDropDown({
    Key key,
    this.hint,
    this.height,
    this.items,
    this.selectedValue,
    this.onChanged,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(
          SizeConfig.safeBlockHorizontal * 3,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
        child: SizedBox(
          child: DropdownButtonFormField<String>(
            isDense: false,
            itemHeight: 60,
            decoration: InputDecoration.collapsed(hintText: ''),
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 4.8,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            hint: Text(
              hint,
              style: TextStyle(
                color: Color(0xFF8A8A8F),
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.safeBlockHorizontal * 5,
              ),
            ),
            onChanged: onChanged,
            items: items,
            value: selectedValue,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
