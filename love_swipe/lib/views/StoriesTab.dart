import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/StoriesCubit.dart';
import 'ShowStoryScreen.dart';

class StoriesTab extends StatefulWidget {
  const StoriesTab({super.key});

  @override
  State<StoriesTab> createState() => _StoriesTabState();
}

// Örnek veri
final List<Map<String, dynamic>> sampleData = [
  {'image': 'https://i.hizliresim.com/7rexq9g.jpg', 'name': 'User 1'},
  {'image': 'https://i.hizliresim.com/gk22twc.jpg', 'name': 'User 2'},
  {'image': 'https://i.hizliresim.com/2vzojg2.jpg', 'name': 'User 3'},
  {'image': 'https://i.hizliresim.com/7rexq9g.jpg', 'name': 'User 4'},
  {'image': 'https://i.hizliresim.com/gk22twc.jpg', 'name': 'User 5'},
  {'image': 'https://i.hizliresim.com/2vzojg2.jpg', 'name': 'User 6'},
  {'image': 'https://i.hizliresim.com/7rexq9g.jpg', 'name': 'User 7'},
  {'image': 'https://i.hizliresim.com/gk22twc.jpg', 'name': 'User 8'},
  {'image': 'https://i.hizliresim.com/2vzojg2.jpg', 'name': 'User 9'},
  {'image': 'https://i.hizliresim.com/7rexq9g.jpg', 'name': 'User 10'},
  {'image': 'https://i.hizliresim.com/gk22twc.jpg', 'name': 'User 11'},
  {'image': 'https://i.hizliresim.com/2vzojg2.jpg', 'name': 'User 12'},
  {'image': 'https://i.hizliresim.com/7rexq9g.jpg', 'name': 'User 13'},
  {'image': 'https://i.hizliresim.com/gk22twc.jpg', 'name': 'User 14'},
  {'image': 'https://i.hizliresim.com/2vzojg2.jpg', 'name': 'User 15'},
  {'image': 'https://i.hizliresim.com/7rexq9g.jpg', 'name': 'User 16'},
  {'image': 'https://i.hizliresim.com/gk22twc.jpg', 'name': 'User 17'},
  {'image': 'https://i.hizliresim.com/2vzojg2.jpg', 'name': 'User 18'},
  {'image': 'https://i.hizliresim.com/7rexq9g.jpg', 'name': 'User 19'},
  {'image': 'https://i.hizliresim.com/gk22twc.jpg', 'name': 'User 20'},
];

class _StoriesTabState extends State<StoriesTab> with StoriesMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoriesCubit(context),
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          return buildScaffold(context);
        },
      ),
    );
  }
}

mixin StoriesMixin {
  Scaffold buildScaffold(BuildContext context) {
    print(sampleData.length);
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        title: const Text(
          "Hikayeler",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: (sampleData.length / 3).ceil(), // Toplam satır sayısı
        itemBuilder: (context, rowIndex) {
          return Row(
            children: List.generate(3, (colIndex) {
              final dataIndex = rowIndex * 3 + colIndex;
              if (dataIndex < sampleData.length) {
                return buildStoryItem(context, sampleData[dataIndex]);
              } else {
                return const SizedBox(); // Boş bir widget döndür
              }
            }),
          );
        },
      ),
    );
  }

  Widget buildStoryItem(BuildContext context, Map<String, dynamic> data) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowStoryScreen(data: data)));
      },
      child: Stack(
        children: [
          Align(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width / 3,
              height: MediaQuery.sizeOf(context).height * .25,
              child: Hero(
                tag: "image${data['name']}",
                child: Image.network(
                  data['image'],
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              width: MediaQuery.sizeOf(context).width / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(.1),
                      Colors.grey.withOpacity(.2),
                      Colors.grey.withOpacity(.3),
                      Colors.grey.withOpacity(.4),
                      Colors.grey.withOpacity(.4),
                    ]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 2), // changes position of shadow
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUvYaJOC1XJEMneXwSLCUizp-FaD-75JIxkg&s"),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['name'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
