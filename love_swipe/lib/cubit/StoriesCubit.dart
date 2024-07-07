import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_swipe/services/StoryService.dart'; // Replace with your actual service import
import '../models/StoryModel.dart'; // Replace with your actual model import

class StoriesCubit extends Cubit<StoriesState> {
  final StoryService _storyService = StoryService(); // Initialize your service
  List<StoryModel> stories = []; // List to hold fetched stories
  bool isLoading = false;
  bool isLoadingMore = false;
  int pageSize = 15;
  int currentPage = 1;

  StoriesCubit() : super(StoriesInitialState()){
    fetchStories();
  }

  Future<void> fetchStories() async {
    try {
      changeLoadingView();
      var fetchedStories = await _storyService.getPaginatedStories(pageSize, currentPage);
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
      var fetchedStories = await _storyService.getPaginatedStories(pageSize, currentPage);
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
    emit(StoriesLoadingMoreState(isLoadingMore,stories));
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
  final  List<StoryModel> stories;
  StoriesLoadingMoreState(this.isLoadingMore,this.stories);
}

class StoriesLoadedState extends StoriesState {
  final List<StoryModel> stories;
  StoriesLoadedState(this.stories);
}

class StoriesErrorState extends StoriesState {
  final String error;
  StoriesErrorState(this.error);
}
