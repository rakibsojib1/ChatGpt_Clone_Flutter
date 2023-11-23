import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grok_ai_demo/constants/constants.dart';
import 'package:grok_ai_demo/models/chat_model.dart';
import 'package:grok_ai_demo/services/api_services.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../services/services.dart';
import '../widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
     final modelsProvider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            AssetsManager.openaiLogo,
          ),
        ),
        title: const Text("Meme AI"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ChatWidget(
                  msg: chatList[index].msg,
                  chatIndex: chatList[index].chtIndex,
                );
              },
            ),
          ),
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
          ],
          const SizedBox(height: 15),
          Material(
            color: cardColor,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _textEditingController,
                      onSubmitted: (value) {
                        //sent
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you?",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                   await sendMessageFCT(modelsProvider: modelsProvider);
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    _textEditingController.clear();
    try {
      setState(() {
        _isTyping = true;
      });
      chatList = await ApiServices.sendMessage(
        message: _textEditingController.text,
        modelID: modelsProvider.getCurrentModel,
      );
      setState(() {
        
      });
      log("request sent");
      print("done");
    } catch (e) {
      log("Error $e");
      print("Error $e");
    } finally {
      setState(
        () {
          _isTyping = false;
        },
      );
    }
  }
}
