import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_swipe/views/PremiumScreen.dart';

import '../../cubit/StoriesCubit.dart';
import '../../models/StoryModel.dart';
import '../AddStory.dart';
import '../ShowStoryScreen.dart';

class StoriesTab extends StatefulWidget {
  const StoriesTab({super.key});

  @override
  State<StoriesTab> createState() => _StoriesTabState();
}

class _StoriesTabState extends State<StoriesTab> with StoriesMixin {
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StoriesCubit()..fetchStories(), // Initialize and fetch stories
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          if (state is StoriesLoadingState && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return buildScaffold(context);
          }
        },
      ),
    );
  }
}

mixin StoriesMixin {
  final ScrollController _scrollController = ScrollController();

  void _onScroll(BuildContext context) {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      bool isLoadingMore = context.read<StoriesCubit>().isLoadingMore;
      if (!isLoadingMore) {
        context.read<StoriesCubit>().fetchMoreStories();
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
        actions: [
          IconButton(
            onPressed: () {
              // eğer ilk defa paylaşıyorsa izin ver fazla ise premium sayfasına at
              Navigator.push(
                context,
                MaterialPageRoute(
                  //builder: (context) => const AddStory(),
                  builder: (context) => PremiumScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
        title: const Text(
          "Hikayeler",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: (context.watch<StoriesCubit>().stories.length / 3)
            .ceil(), // Calculate total rows
        itemBuilder: (context, rowIndex) {
          return Row(
            children: List.generate(3, (colIndex) {
              final dataIndex = rowIndex * 3 + colIndex;
              if (dataIndex == 0) {
                return buildShareYourStoryItem(
                    context); // "Kendi Storyini Paylaş" alanı
              } else if (dataIndex <
                  context.read<StoriesCubit>().stories.length) {
                return buildStoryItem(context,
                    context.read<StoriesCubit>().stories[dataIndex - 1]);
              } else {
                return const SizedBox(); // Return empty widget if no data
              }
            }),
          );
        },
      ),
    );
  }

  Widget buildShareYourStoryItem(BuildContext context) {
    return InkWell(
      onTap: () {
        // eğer ilk defa paylaşıyorsa izin ver fazla ise premium sayfasına at
        Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) => const AddStory(),
            builder: (context) => PremiumScreen(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height * .25,
        color: Colors.grey.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
                Icons.add,
                size: 48,
                color: Colors.black,
              ),
            Container(
              padding: const EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width / 3,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "X10 Kat daha fazla görüntülenme",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStoryItem(BuildContext context, StoryModel story) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowStoryScreen(data: {
              'image': story.photoUrl,
              'name': story.user.username.toString(),
              // Example: Use user id as name
            }),
          ),
        );
      },
      child: Stack(
        children: [
          Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height * .25,
              child: Hero(
                tag: "image${story.user.id}", // Use userId as tag
                child: Image.network(
                  story.photoUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.1),
                    Colors.black.withOpacity(.2),
                    Colors.black.withOpacity(.3),
                    Colors.black.withOpacity(.4),
                    Colors.black.withOpacity(.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage("${story.user.profilePhoto}"),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story.user.username.toString(), // Example: Display user id
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
