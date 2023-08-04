import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'smart_home_add_event.dart';
part 'smart_home_add_state.dart';

class SmartHomeAddBloc extends Bloc<SmartHomeAddEvent, SmartHomeAddState> {
  SmartHomeAddBloc({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(const SmartHomeAddState()) {
    on<SmartHomeQRcodeScannedEvent>(_onSmartHomeQRcodeScanned);
  }

  final HomeRepository _homeRepository;

  Future<void> _onSmartHomeQRcodeScanned(
    SmartHomeQRcodeScannedEvent event,
    Emitter<SmartHomeAddState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SmartHomeAddStatus.loading));
      final data = event.rawData.split('.');
      if (data.length != 2) {
        emit(
          state.copyWith(
            status: SmartHomeAddStatus.failure,
            requestError: 'Invalid QR Code',
          ),
        );
      }
      final home =
          await _homeRepository.addHome(homeId: data[0], password: data[1]);
      emit(
        state.copyWith(
          status: SmartHomeAddStatus.success,
          home: home,
          requestError: '',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SmartHomeAddStatus.failure,
          requestError: error is SmartHomeException
              ? error.message
              : 'Something is wrong',
        ),
      );
    }
  }
}
