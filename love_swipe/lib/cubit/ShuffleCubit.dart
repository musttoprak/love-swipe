import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/StoryModel.dart';
import '../services/StoryService.dart';

class ShuffleCubit extends Cubit<ShuffleState> {
  final StoryService _storyService = StoryService();
  List<StoryModel> stories = [];
  bool isLoading = false;

  ShuffleCubit() : super(ShuffleInitialState()) {
    fetchStories();
  }

  Future<void> fetchStories() async {
    try {
      changeLoadingView();
      var fetchedStories = await _storyService.getRandomUser(limit: 12);
      stories.addAll(fetchedStories);
      changeLoadingView();
    } catch (e) {
      print('Error fetching stories: $e');
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(ShuffleLoadingState(isLoading));
  }
}

abstract class ShuffleState {}

class ShuffleInitialState extends ShuffleState {}

class ShuffleLoadingState extends ShuffleState {
  final bool isLoading;

  ShuffleLoadingState(this.isLoading);
}
