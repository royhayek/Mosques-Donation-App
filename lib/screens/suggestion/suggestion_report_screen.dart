import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';

class SuggestionReportScreen extends StatefulWidget {
  static String routeName = "suggest_report_screen";

  @override
  _SuggestionReportScreenState createState() => _SuggestionReportScreenState();
}

class _SuggestionReportScreenState extends State<SuggestionReportScreen> {
  String _verticalGroupValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verticalGroupValue = trans(context, 'complaint');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'complain_or_suggest')),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 3),
            RadioGroup<String>.builder(
              direction: Axis.horizontal,
              horizontalAlignment: MainAxisAlignment.start,
              groupValue: _verticalGroupValue,
              onChanged: (value) => setState(() {
                _verticalGroupValue = value;
              }),
              items: [
                trans(context, 'complaint'),
                trans(context, 'suggestion')
              ],
              itemBuilder: (item) => RadioButtonBuilder(
                item,
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 3),
            Text(
              _verticalGroupValue == trans(context, 'suggestion')
                  ? trans(context, 'write_your_suggestion')
                  : trans(context, 'write_your_complaint'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.6),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(
                  SizeConfig.safeBlockHorizontal * 3,
                ),
              ),
              child: TextFormField(
                maxLines: 6,
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
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            DefaultButton(
              press: () => null,
              text: trans(context, 'submit'),
            ),
          ],
        ),
      ),
    );
  }
}
