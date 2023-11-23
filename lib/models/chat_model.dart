class ChatModel {
  final String msg;
  final int chtIndex;

  ChatModel({required this.msg, required this.chtIndex});

  factory ChatModel.fromjson(Map<String, dynamic> json) =>
      ChatModel(msg: json["msg"], chtIndex: json["chatIndex"]);
}
