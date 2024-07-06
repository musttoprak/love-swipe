import 'package:flutter/material.dart';

class ShowStoryScreen extends StatelessWidget {
  final Map<String, dynamic>  data; // Buraya görsel için id ekleyebilirsiniz, kullanmadım çünkü örnek veride id yoktu.

  const ShowStoryScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                decoration:BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), //color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 2), // changes position of shadow
                    )
                  ],
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUvYaJOC1XJEMneXwSLCUizp-FaD-75JIxkg&s"),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      data['name'],
                      style: const TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration:BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), //color of shadow
                      spreadRadius: 5, //spread radius
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
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.all(Radius.circular(24)))
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send,color: Colors.white,),
                      onPressed: () {
                        // Mesaj gönderme işlemini burada gerçekleştirin
                        // Örneğin: showMessage(context);
                      },
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
