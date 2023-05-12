import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_bloc.g.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(
          const HomeState(),
        ) {
    on<HomeSelectedEvent>(_onHomeSelectedEvent);
    on<HomeDeselectedEvent>(_onHomeDeselectedEvent);
  }

  void _onHomeSelectedEvent(
    HomeSelectedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedHome: event.home));
  }

  void _onHomeDeselectedEvent(
    HomeDeselectedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(const HomeState());
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return HomeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return state.toJson();
  }
}
