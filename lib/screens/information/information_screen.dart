import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../size_config.dart';

class InformationScreen extends StatelessWidget {
  static const routeName = "information_screen";

  final String title;

  const InformationScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _body(context),
    );
  }

  _appBar() {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }

  _body(BuildContext context) {
    AppProvider appProvider = Provider.of(context, listen: false);
    if (title == trans(context, 'about_us')) {
      return _buildHtmlContent(
        body: _buildHtmlBody(content: appProvider.settings.aboutUs),
      );
    } else if (title == trans(context, 'privacy_policy')) {
      return _buildHtmlContent(
        body: _buildHtmlBody(content: appProvider.settings.privacyPolicy),
      );
    } else if (title == trans(context, 'terms_and_conditions')) {
      return _buildHtmlContent(
        body: _buildHtmlBody(content: appProvider.settings.termsAndConditions),
      );
    }
  }

  _buildHtmlContent({Widget body}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2,
        ),
        child: body,
      ),
    );
  }

  _buildHtmlBody({String content, Map<String, Style> style}) {
    return Html(
      data: content,
      style: style != null ? style : null,
    );
  }
}
