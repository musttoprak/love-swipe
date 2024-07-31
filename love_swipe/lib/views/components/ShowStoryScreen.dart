import 'dart:io';

import 'package:flutter/material.dart';

import 'PremiumScreen.dart';

class ShowStoryScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ShowStoryScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Dismissible(
          key: const Key('dismissible_key'),
          direction: DismissDirection.down,
          onDismissed: (direction) {
            Navigator.pop(context);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Positioned.fill(
                child: Hero(
                  tag: 'image${data['name']}',
                  child: data['image'].contains("data/user")
                      ? Image.file(
                          File(data['image']),
                          fit: BoxFit.fitWidth,
                        )
                      : Image.network(
                          data['image'],
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
              // Content
              Column(
                children: [
                  // Top bar
                  SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUvYaJOC1XJEMneXwSLCUizp-FaD-75JIxkg&s"),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                data['name'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 32),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Flexible space
                  Expanded(child: SizedBox()),
                  // Bottom bar
                  SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Mesajınızı buraya yazın',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                hintStyle: TextStyle(color: Colors.white70),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PremiumScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
