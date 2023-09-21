// ignore: file_names
class Message {
  final String id;
  final String message;
  final String SenderEmail;
  final String code;
  final String SenderName;
  final dynamic Time;
  bool isRead;

  Message(
      {required this.message,
      required this.SenderEmail,
      required this.SenderName,
      required this.Time,
      required this.code,
      required this.id,
      required this.isRead});

  factory Message.fromJson(JsonData) {
    return Message(
        message: JsonData["message"],
        SenderEmail: JsonData["SenderEmail"],
        SenderName: JsonData["SenderName"],
        Time: JsonData["Time"],
        code: JsonData["code"],
        id: JsonData["id"],
        isRead: JsonData["isRead"]);
  }
}
