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
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Hero(
                  tag: 'image${data['name']}',
                  child: Image.network(
                    data['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // color of shadow
                        spreadRadius: 5, // spread radius
                        blurRadius: 7, // blur radius
                        offset: const Offset(0, 2), // changes position of shadow
                      )
                    ],
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // color of shadow
                        spreadRadius: 5, // spread radius
                        blurRadius: 7, // blur radius
                        offset: const Offset(0, 2), // changes position of shadow
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Mesajınızı buraya yazın',
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(24)))),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
