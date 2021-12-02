


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_example/bloc/fetch_event.dart';
import 'package:food_example/bloc/fetch_state.dart';
import 'package:food_example/domain/repositories/repository.dart';

class FetchBloc extends Bloc<FetchEvent,FetchState> {


  @override
  FetchState get initialState => FetchInitial();

  @override
  Stream<FetchState> mapEventToState(
      FetchEvent event,
      ) async* {
    yield FetchInitial();
    if (event is FetchFoodEvent) {
      yield FetchLoadingState();
      try {
        var foodScreen = await Repository().getFood();
        yield FetchLoadedState(foodScreen: foodScreen);
      } catch (e) {
        yield FetchErrorState(message: e.toString());
      }
    }
  }
}
