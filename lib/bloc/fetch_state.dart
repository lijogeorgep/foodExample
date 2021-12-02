

import 'package:equatable/equatable.dart';
import 'package:food_example/data/model/food.dart';

abstract class FetchState extends Equatable {
  const FetchState();
}

class FetchInitial extends FetchState {
  @override
  List<Object> get props => [];
}
class FetchLoadingState extends FetchState {
  @override
  List<Object> get props => [];
}
class FetchLoadedState extends FetchState {
  final List<Food> foodScreen;

  FetchLoadedState({this.foodScreen});

  @override
  List<Object> get props => [];
}

class FetchErrorState extends FetchState {
  final String message;

  FetchErrorState({this.message});

  @override
  List<Object> get props => [message];
}
