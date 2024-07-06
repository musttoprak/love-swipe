import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShuffleCubit extends Cubit<ShuffleState> {
  bool isLoading = true;
  BuildContext context;

  ShuffleCubit(this.context) : super(ShuffleInitialState()) {}

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
