import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/ChatMessage.dart';
import '../components/PremiumScreen.dart';
class ChatPageBody extends StatefulWidget {
  final ChatMessage user;

  const ChatPageBody(this.user, {super.key});

  @override
  State<ChatPageBody> createState() => _ChatPageBodyState();
}

class _ChatPageBodyState extends State<ChatPageBody> {
  late final ChatMessage user;
  late List<ChatMessage> chatMessages;

  @override
  void initState() {
    user = widget.user;
    chatMessages = [
      ChatMessage(
        user: user.user,
        image: user.image,
        message: user.message,
        messageType: ChatMessageType.text,
        messageStatus: MessageStatus.viewed,
        isSender: false,
      ),
      ChatMessage(
        user: user.user,
        image: user.image,
        message: user.image,
        messageType: ChatMessageType.image,
        messageStatus: MessageStatus.viewed,
        isSender: false,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppColors.pDefaultPadding),
          child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) =>
                  Messages(message: chatMessages[index])),
        )),
        chatTextField(context),
      ],
    );
  }

  Container chatTextField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppColors.pDefaultPadding,
          vertical: AppColors.pDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 40,
              color: Colors.grey.withOpacity(0.2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(
              width: AppColors.pDefaultPadding * 0.1,
            ),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.pPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PremiumScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: AppColors.pDefaultPadding * 0.01,
                    ),
                    const Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Mesasjınızı Girin',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: AppColors.pDefaultPadding * 0.01,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PremiumScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messages extends StatelessWidget {
  const Messages({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    print(message.message);
    return Padding(
      padding: const EdgeInsets.only(top: AppColors.pDefaultPadding * 0.9),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage(message.image.trim()),
            )
          ],
          const SizedBox(
            width: AppColors.pDefaultPadding / 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppColors.pDefaultPadding * 0.5,
                vertical: AppColors.pDefaultPadding / 2),
            decoration: BoxDecoration(
                color: message.isSender
                    ? AppColors.pSecondaryColor.withOpacity(0.9)
                    : AppColors.pSecondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(35)),
            child: message.messageType == ChatMessageType.text
                ? Text(
                    message.message,
                    style: const TextStyle(color: Colors.black),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PremiumScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Blurlu arka plan için BackdropFilter kullanımı
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                                sigmaX: 6, sigmaY: 6, tileMode: TileMode.decal),
                            enabled: true,
                            child: Image.network(
                              message.message.trim(),
                              width: MediaQuery.of(context).size.width * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Kilit ikonu
                          Icon(
                            Icons.lock,
                            size: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          if (message.isSender) MessageTick(status: message.messageStatus)
        ],
      ),
    );
  }
}

class MessageTick extends StatelessWidget {
  final MessageStatus? status;

  const MessageTick({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return AppColors.pErrorColor;
        case MessageStatus.not_view:
          return Colors.black.withOpacity(0.3);
        case MessageStatus.viewed:
          return AppColors.pPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: AppColors.pDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
