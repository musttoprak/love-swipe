import 'package:flutter/material.dart';
import 'package:love/views/chat/ChatPageBody.dart';

import '../../constants/app_colors.dart';
import '../../models/ChatMessage.dart';
import '../../models/UserModel.dart';
import '../components/PremiumScreen.dart';

class Chatting extends StatefulWidget {
  final ChatMessage user;

  const Chatting(this.user, {super.key});

  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {

  late final ChatMessage user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ChatPageBody(user),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.pPrimaryColor,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.image_user.trim()),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                ),
              )
            ],
          ),
          const SizedBox(
            width: AppColors.pDefaultPadding * 0.7,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.user,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 1,
              ),
              const Opacity(
                  opacity: 0.9,
                  child: Text('online',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)))
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PremiumScreen(),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam,
            color: Colors.white,
          ),
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
          width: AppColors.pDefaultPadding * 0.2,
        )
      ],
    );
  }
}
