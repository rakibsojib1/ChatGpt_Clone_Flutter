import 'package:flutter/material.dart';
import 'package:grok_ai_demo/constants/constants.dart';
import 'package:grok_ai_demo/models/models_model.dart';
import 'package:grok_ai_demo/providers/models_provider.dart';
import 'package:grok_ai_demo/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class ModelsDropDown extends StatefulWidget {
  const ModelsDropDown({super.key});

  @override
  State<ModelsDropDown> createState() => _ModelsDropDownState();
}

class _ModelsDropDownState extends State<ModelsDropDown> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(
      future: modelsProvider.getAllMOdels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(lavel: snapshot.error.toString()),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
              child: DropdownButton<String>(
                  iconEnabledColor: Colors.white,
                  dropdownColor: scaffoldBackgroundColor,
                  items: List<DropdownMenuItem<String>>.generate(
                    snapshot.data!.length,
                    (index) => DropdownMenuItem(
                      value: snapshot.data![index].id,
                      child: TextWidget(
                        lavel: snapshot.data![index].id,
                        fonntSize: 15,
                      ),
                    ),
                  ),
                  value: currentModel,
                  onChanged: (value) {
                    setState(() {
                      currentModel = value.toString();
                    });
                    modelsProvider.setCurrentModel(value.toString());
                  }),
            );
      },
    );
  }
}
