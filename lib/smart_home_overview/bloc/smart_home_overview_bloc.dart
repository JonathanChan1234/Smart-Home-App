import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'smart_home_overview_bloc.g.dart';
part 'smart_home_overview_event.dart';
part 'smart_home_overview_state.dart';

class SmartHomeOverviewBloc
    extends Bloc<SmartHomeOverviewEvent, SmartHomeOverviewState> {
  SmartHomeOverviewBloc({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(const SmartHomeOverviewState()) {
    on<SmartHomeOverviewSubscriptionRequestEvent>(
      _onSmartHomeOverviewSubscriptionRequested,
    );
    on<SmartHomeOverviewFetchEvent>(
      _onSmartHomeOverviewFetch,
    );
    on<SmartHomeOverviewTabChangedEvent>(
      _onSmartHomeOverviewTabChanged,
    );
  }

  final HomeRepository _homeRepository;

  Future<void> _onSmartHomeOverviewSubscriptionRequested(
    SmartHomeOverviewSubscriptionRequestEvent event,
    Emitter<SmartHomeOverviewState> emit,
  ) async {
    await emit.forEach(
      _homeRepository.homes,
      onData: (homes) => state.copyWith(
        status: SmartHomeOverviewStatus.success,
        homes: homes,
      ),
      onError: (error, _) => state.copyWith(
        status: SmartHomeOverviewStatus.failure,
        requestError:
            error is HomeApiException ? error.message : 'Something is wrong',
      ),
    );
  }

  Future<void> _onSmartHomeOverviewFetch(
    SmartHomeOverviewFetchEvent event,
    Emitter<SmartHomeOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SmartHomeOverviewStatus.loading,
      ),
    );
    await _homeRepository.fetchHomeList();
  }

  void _onSmartHomeOverviewTabChanged(
    SmartHomeOverviewTabChangedEvent event,
    Emitter<SmartHomeOverviewState> emit,
  ) {
    emit(
      state.copyWith(
        tab: event.tab,
      ),
    );
  }
}
