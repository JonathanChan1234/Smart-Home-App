import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

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
    on<SmartHomeOverviewHomeDeletedEvent>(
      _onSmartHomeOverviewHomeDeleted,
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
            error is SmartHomeException ? error.message : 'Something is wrong',
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
        eventType: SmartHomeOverviewEventType.fetch,
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

  Future<void> _onSmartHomeOverviewHomeDeleted(
    SmartHomeOverviewHomeDeletedEvent event,
    Emitter<SmartHomeOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SmartHomeOverviewStatus.loading,
        eventType: SmartHomeOverviewEventType.delete,
      ),
    );
    try {
      await _homeRepository.removeHome(event.home.id);
      emit(
        state.copyWith(
          status: SmartHomeOverviewStatus.success,
          eventType: SmartHomeOverviewEventType.delete,
          requestError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SmartHomeOverviewStatus.failure,
          eventType: SmartHomeOverviewEventType.delete,
          requestError: e is SmartHomeException ? e.message : '',
        ),
      );
    }
  }
}
