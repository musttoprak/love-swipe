import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_swipe/cubit/ChatCubit.dart';

import '../../constants/app_colors.dart';
import '../../models/Chat.dart';
import '../../models/ChatMessage.dart';
import '../../models/UserModel.dart';
import 'ChatScreen.dart';

class Chats extends StatefulWidget {
  const Chats({
    super.key,
  });

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return buildScaffold(context, AppColors.pPrimaryColor, Colors.white);
        },
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context, Color bgColor, Color contain) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.pPrimaryColor,
        title: const Text(
          'Mesajlar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
            color: contain,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            )),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 8),
              child: Text('Favoriler',
                  style: TextStyle(
                      // color: Colors.grey[800],
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: 110.0,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: context.watch<ChatCubit>().users.length,
                itemBuilder: (BuildContext context, int index) {
                  String user = context.read<ChatCubit>().users[index];
                  String message = context.read<ChatCubit>().messages[index];
                  String image = context.read<ChatCubit>().images[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Chatting(user, message, image, index)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(image.trim()),
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            user.split(" /")[0],
                            style: const TextStyle(
                                // color: Colors.grey[850],
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: context.read<ChatCubit>().users.length,
                itemBuilder: (BuildContext context, int index) {
                  print(index);
                  String user = context.read<ChatCubit>().users[index];
                  String message = context.read<ChatCubit>().messages[index];
                  String image = context.read<ChatCubit>().images[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Chatting(user, message, image, index)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppColors.pDefaultPadding,
                          vertical: AppColors.pDefaultPadding * 0.75),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(image.trim()),
                              ),
                              if (true)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          width: 3,
                                        )),
                                  ),
                                )
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppColors.pDefaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.split(" /")[0],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.bolt,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      Text(
                                        user.split(" /")[2],
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      message,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: 0.7, child: Text(user.split(" /")[1]))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
