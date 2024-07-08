import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_swipe/services/StoryService.dart'; // Replace with your actual service import
import 'package:love_swipe/services/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/StoryModel.dart';
import '../models/UserModel.dart'; // Replace with your actual model import

class StoriesCubit extends Cubit<StoriesState> {
  final StoryService _storyService = StoryService(); // Initialize your service
  List<StoryModel> stories = []; // List to hold fetched stories
  bool isLoading = false;
  bool isLoadingMore = false;
  int pageSize = 15;
  int currentPage = 1;

  StoriesCubit() : super(StoriesInitialState()) {
    fetchStories();
  }

  Future<void> fetchStories() async {
    try {
      pageSize = 15;
      currentPage = 1;
      changeLoadingView();
      var fetchedStories =
          await _storyService.getPaginatedStories(pageSize, currentPage);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sharedStoryPath = prefs.getString('sharedStoryPath');
      StoryModel? storyModel;
      if (sharedStoryPath != null) {
        String? email = prefs.getString('email');
        UserService userService = UserService();
        UserModel? userModel = await userService.getUserByEmail(email!);
        storyModel = StoryModel(
          id: 1,
          user: userModel!,
          photoUrl: sharedStoryPath,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        stories.add(storyModel);
      }
      stories.addAll(fetchedStories);
      changeLoadingView();
    } catch (e) {
      print('Error fetching stories: $e');
    }
  }

  Future<void> fetchMoreStories() async {
    try {
      changeLoadingMoreView(stories);
      currentPage++;
      var fetchedStories =
          await _storyService.getPaginatedStories(pageSize, currentPage);
      stories.addAll(fetchedStories);
      changeLoadingMoreView(stories);
    } catch (e) {
      print('Error fetching more stories: $e');
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(StoriesLoadingState(isLoading));
  }

  void changeLoadingMoreView(List<StoryModel> stories) {
    isLoadingMore = !isLoadingMore;
    emit(StoriesLoadingMoreState(isLoadingMore, stories));
  }
}

// States
abstract class StoriesState {}

class StoriesInitialState extends StoriesState {}

class StoriesLoadingState extends StoriesState {
  final bool isLoading;

  StoriesLoadingState(this.isLoading);
}

class StoriesLoadingMoreState extends StoriesState {
  final bool isLoadingMore;
  final List<StoryModel> stories;

  StoriesLoadingMoreState(this.isLoadingMore, this.stories);
}

class StoriesLoadedState extends StoriesState {
  final List<StoryModel> stories;

  StoriesLoadedState(this.stories);
}

class StoriesErrorState extends StoriesState {
  final String error;

  StoriesErrorState(this.error);
}
