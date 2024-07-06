import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/ShuffleCubit.dart';

class ShuffleTab extends StatefulWidget {
  const ShuffleTab({super.key});

  @override
  State<ShuffleTab> createState() => _ShuffleTabState();
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
class _ShuffleTabState extends State<ShuffleTab>  with ShuffleMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShuffleCubit(context),
      child: BlocBuilder<ShuffleCubit, ShuffleState>(
        builder: (context, state) {
          return buildScaffold(context);
        },
      ),
    );
  }
}

mixin ShuffleMixin {
  Scaffold buildScaffold(BuildContext context) {
    print(sampleData.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shuffle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
      ),
      body: ListView.builder(
        itemCount: sampleData.length , // Toplam satır sayısı
        itemBuilder: (context, index) {
          return Column(
            children: [
              buildStoryItem(context, sampleData[index]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(height: .5,color: Colors.grey,thickness: .5,),
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildStoryItem(BuildContext context, Map<String, dynamic> data) {
    return ListTile(
      title: Text(data['name'],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      leading:  Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue)
        ),
        child: const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUvYaJOC1XJEMneXwSLCUizp-FaD-75JIxkg&s"),
        ),
      ),
      subtitle: const Text('Açıklama',style: TextStyle(color: Colors.grey),),
      trailing: const Icon(Icons.diamond),
    );
  }
}