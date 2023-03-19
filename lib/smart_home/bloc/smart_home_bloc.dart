import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart' hide SmartHome;
import 'package:json_annotation/json_annotation.dart';
import 'package:smart_home/smart_home/models/smart_home.dart';

part 'smart_home_bloc.g.dart';
part 'smart_home_event.dart';
part 'smart_home_state.dart';

class SmartHomeBloc extends Bloc<SmartHomeEvent, SmartHomeState> {
  SmartHomeBloc(HomeApiClient homeApiClient)
      : _homeApiClient = homeApiClient,
        super(const SmartHomeState()) {
    on<FetchSmartHomeEvent>(onFetchSmartHomeEvent);
    on<RefreshSmartHomeEvent>(onRefreshSmartHomeEvent);
  }

  final HomeApiClient _homeApiClient;

  Future<void> onFetchSmartHomeEvent(
    FetchSmartHomeEvent event,
    Emitter<SmartHomeState> emit,
  ) async {
    emit(state.copyWith(status: SmartHomeStatus.loading));
    try {
      final smartHome = await _homeApiClient.getHomeList();
      emit(
        state.copyWith(
          status: SmartHomeStatus.success,
          smartHome: smartHome.map(SmartHome.fromRepository).toList(),
          errorMessage: '',
        ),
      );
    } on HomeApiBadRequestException catch (e) {
      emit(
        state.copyWith(
          status: SmartHomeStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SmartHomeStatus.failure,
          errorMessage: 'Something is wrong',
        ),
      );
    }
  }

  Future<void> onRefreshSmartHomeEvent(
    RefreshSmartHomeEvent event,
    Emitter<SmartHomeState> emit,
  ) async {
    try {
      final smartHome = await _homeApiClient.getHomeList();
      emit(
        state.copyWith(
          status: SmartHomeStatus.success,
          smartHome: smartHome.map(SmartHome.fromRepository).toList(),
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(state);
    }
  }
}
