import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'home_delete_event.dart';
part 'home_delete_state.dart';

class HomeDeleteBloc extends Bloc<HomeDeleteEvent, HomeDeleteState> {
  HomeDeleteBloc({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(const HomeDeleteState()) {
    on<HomeDeleteHomeSubscriptionRequestedEvent>(_onHomeSubscriptionRequest);
    on<HomeDeleteHomeRefreshEvent>(_onHomeRefresh);
    on<HomeDeleteHomeDeletedEvent>(_onHomeDeleted);
  }

  final HomeRepository _homeRepository;

  Future<void> _onHomeSubscriptionRequest(
    HomeDeleteHomeSubscriptionRequestedEvent event,
    Emitter<HomeDeleteState> emit,
  ) async {
    emit(state.copyWith(refreshStatus: HomeDeleteRefreshStatus.loading));
    await emit.forEach(
      _homeRepository.homes,
      onData: (homes) => state.copyWith(
        refreshStatus: HomeDeleteRefreshStatus.success,
        homes: homes,
      ),
      onError: (error, _) => state.copyWith(
        refreshStatus: HomeDeleteRefreshStatus.failure,
        requestError: error is SmartHomeException ? error.message : '',
      ),
    );
  }

  Future<void> _onHomeRefresh(
    HomeDeleteHomeRefreshEvent event,
    Emitter<HomeDeleteState> emit,
  ) async {
    emit(state.copyWith(refreshStatus: HomeDeleteRefreshStatus.loading));
    await _homeRepository.fetchHomeList();
  }

  Future<void> _onHomeDeleted(
    HomeDeleteHomeDeletedEvent event,
    Emitter<HomeDeleteState> emit,
  ) async {
    try {
      emit(state.copyWith(requestStatus: HomeDeleteRequestStatus.loading));
      await _homeRepository.removeHome(event.home.id);
      emit(state.copyWith(requestStatus: HomeDeleteRequestStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          requestStatus: HomeDeleteRequestStatus.failure,
          requestError: e is SmartHomeException ? e.message : '',
        ),
      );
    }
  }
}
