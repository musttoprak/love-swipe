import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love/components/display_widget.dart';
import 'package:love/constants/app_colors.dart';
import '../../cubit/ShuffleCubit.dart';
import '../../models/StoryModel.dart';
import '../components/PremiumScreen.dart';

class ShuffleTab extends StatefulWidget {
  const ShuffleTab({super.key});

  @override
  State<ShuffleTab> createState() => _ShuffleTabState();
}

class _ShuffleTabState extends State<ShuffleTab> with ShuffleMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShuffleCubit(),
      child: BlocBuilder<ShuffleCubit, ShuffleState>(
        builder: (context, state) {
          if (state is ShuffleLoadingState && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return buildScaffold(context);
          }
        },
      ),
    );
  }
}

mixin ShuffleMixin {
  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shuffle",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: context.watch<ShuffleCubit>().stories.length,
        itemBuilder: (context, index) {
          return buildStoryItem(
            context,
            context.read<ShuffleCubit>().stories[index],
          );
        },
      ),
    );
  }

  Widget buildStoryItem(BuildContext context, StoryModel story) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PremiumScreen(),
          ),
        );
      },
      child: ListTile(
        title: Text(
          story.user.username,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: SizedBox(
          width: MediaQuery.of(context).size.width * .2,
          child: DisplayImage(
            imagePath: story.photoUrl,
            onPressed: () {},
            isEditIcon: false,
          ),
        ),
        subtitle: const Text(
          'Açıklama', // Description text
          style: TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.diamond,
          color: AppColors.pinkColor,
        ),
      ),
    );
  }
}
