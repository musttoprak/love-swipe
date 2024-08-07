class ChatMessage {
  final String image;
  final String image_user;
  final String message;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  final String user;

  ChatMessage({
    required this.image,
    required this.image_user,
    this.message = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    required this.user,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'image_user': image_user,
      'message': message,
      'messageType': messageType.index,
      'messageStatus': messageStatus.index,
      'isSender': isSender,
      'user': user,
    };
  }

  // JSON deserialization
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      image: json['image'],
      image_user: json['image_user'],
      message: json['message'],
      messageType: ChatMessageType.values[json['messageType']],
      messageStatus: MessageStatus.values[json['messageStatus']],
      isSender: json['isSender'],
      user: json['user'],
    );
  }
}

enum ChatMessageType { text, image }
enum MessageStatus { not_sent, not_view, viewed }
