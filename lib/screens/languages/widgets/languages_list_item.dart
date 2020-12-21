import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/language.dart';
import 'package:mosques_donation_app/utils/utils.dart';

import '../../../size_config.dart';

class LanguagesListItem extends StatelessWidget {
  final Language language;
  final Language selectedLanguage;
  final Function onPressed;

  const LanguagesListItem(
      {Key key, this.language, this.selectedLanguage, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 20,
          vertical: SizeConfig.blockSizeVertical * 1,
        ),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: language == selectedLanguage
                ? BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  )
                : BoxDecoration(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 4,
                vertical: SizeConfig.blockSizeVertical * 2.5,
              ),
              child: Center(
                child: Text(
                  trans(context, language.name.toLowerCase()),
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 6,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
