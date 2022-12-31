class Message {
  late final String userName;
  late final String messageContent;
  late final DateTime time;

  Message({
    required this.userName,
    required this.messageContent,
    required this.time,});

  Message.fromJson(dynamic json) {
    userName = json['user_name'] ?? '';
    messageContent = json['content'] ?? '';
    time = json['time'] == null ? DateTime.now() : DateTime.parse(json['time']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_name'] = userName;
    map['content'] = messageContent;
    map['time'] = time.toString();
    return map;
  }
}