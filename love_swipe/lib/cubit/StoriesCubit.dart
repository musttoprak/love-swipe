import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoriesCubit extends Cubit<StoriesState> {
  bool isLoading = true;
  BuildContext context;

  StoriesCubit(this.context) : super(StoriesInitialState()) {}

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(StoriesLoadingState(isLoading));
  }
}

abstract class StoriesState {}

class StoriesInitialState extends StoriesState {}

class StoriesLoadingState extends StoriesState {
  final bool isLoading;

  StoriesLoadingState(this.isLoading);
}
