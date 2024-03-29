import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class AccountListItem extends StatelessWidget {
  final String title;
  final Function onPressed;
  final IconData icon;
  final Widget end;
  final bool last;

  const AccountListItem(
      {Key key, this.title, this.icon, this.onPressed, this.end, this.last = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        contentPadding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1.2),
        onTap: onPressed != null ? onPressed : () => null,
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.5),
        ),
        trailing:
            end != null ? end : Icon(FluentIcons.ios_chevron_right_20_regular),
      ),
      !last ? Divider() : Container(),
    ]);
  }
}
