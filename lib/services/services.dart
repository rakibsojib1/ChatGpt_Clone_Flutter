import 'package:flutter/material.dart';
import 'package:grok_ai_demo/constants/constants.dart';
import 'package:grok_ai_demo/widgets/drop_down.dart';

import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        )),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(30.0),
            child: Row(
              children: [
                Flexible(
                  child: TextWidget(
                    lavel: "Chosen Model:",
                    fonntSize: 16,
                  ),
                ),
                SizedBox(width: 20,),
                Flexible(
                  flex: 2,
                  child: ModelsDropDown(),
                ),
              ],
            ),
          );
        });
  }
}
