

class ChatMessage {
  final String image;
  final String message;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  ChatMessage({
    this.message = '',
    required this.image,
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
  });
}
enum ChatMessageType { text, image }
enum MessageStatus { not_sent, not_view, viewed }
