import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/StoryModel.dart';
import '../services/StoryService.dart';

class ShuffleCubit extends Cubit<ShuffleState> {
  final StoryService _storyService = StoryService();
  List<StoryModel> stories = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int pageSize = 15;
  int currentPage = 1;

  ShuffleCubit() : super(ShuffleInitialState()) {
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
    emit(ShuffleLoadingState(isLoading));
  }
  void changeLoadingMoreView(List<StoryModel> stories) {
    isLoadingMore = !isLoadingMore;
    emit(ShuffleLoadingMoreState(isLoadingMore,stories));
  }
}

abstract class ShuffleState {}

class ShuffleInitialState extends ShuffleState {}

class ShuffleLoadingState extends ShuffleState {
  final bool isLoading;

  ShuffleLoadingState(this.isLoading);
}
class ShuffleLoadingMoreState extends ShuffleState {
  final bool isLoadingMore;
  final  List<StoryModel> stories;
  ShuffleLoadingMoreState(this.isLoadingMore,this.stories);
}
