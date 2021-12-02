import 'package:equatable/equatable.dart';

abstract class FetchEvent extends Equatable {
  @override
  List<Object> get props => null;
}

class FetchFoodEvent extends FetchEvent {
  FetchFoodEvent();
  @override
  List<Object> get props => null;
}
