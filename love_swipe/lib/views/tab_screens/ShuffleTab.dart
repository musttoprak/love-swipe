import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_swipe/components/display_widget.dart';
import 'package:love_swipe/constants/app_colors.dart';
import '../../cubit/ShuffleCubit.dart';
import '../../models/StoryModel.dart';
import '../PremiumScreen.dart';

class ShuffleTab extends StatefulWidget {
  const ShuffleTab({super.key});

  @override
  State<ShuffleTab> createState() => _ShuffleTabState();
}

class _ShuffleTabState extends State<ShuffleTab> with ShuffleMixin {
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
  final ScrollController _scrollController = ScrollController();

  void _onScroll(BuildContext context) {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      bool isLoadingMore = context.read<ShuffleCubit>().isLoadingMore;
      if (!isLoadingMore) {
        context.read<ShuffleCubit>().fetchMoreStories();
      }
    }
  }

  Scaffold buildScaffold(BuildContext context) {
    _scrollController.addListener(
      () {
        _onScroll(context);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shuffle",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: context.watch<ShuffleCubit>().stories.length,
        itemBuilder: (context, index) {
          if (context.read<ShuffleCubit>().stories.length == index + 1) {
            return Column(
              children: [
                buildStoryItem(
                  context,
                  context.read<ShuffleCubit>().stories[index],
                ),
                Visibility(
                  visible: context.watch<ShuffleCubit>().isLoadingMore,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          } else {
            return buildStoryItem(
              context,
              context.read<ShuffleCubit>().stories[index],
            );
          }
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
          color: AppColors.greenColor,
        ),
      ),
    );
  }
}
