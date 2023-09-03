import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:air_conditioner_repository/air_conditioner_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:devices_api/devices_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/air_conditioner/bloc/air_conditioner_bloc.dart';
import 'package:smart_home/air_conditioner/widgets/air_conditioner_overview.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class AirConditionerPage extends StatelessWidget {
  const AirConditionerPage({
    super.key,
    required this.home,
    required this.room,
  });

  final SmartHome home;
  final Room room;

  static MaterialPageRoute<void> route({
    required SmartHome home,
    required Room room,
  }) {
    return MaterialPageRoute(
      builder: (context) => RepositoryProvider(
        create: (context) {
          final authRepository = context.read<AuthRepository>();
          final apiClient = context.read<SmartHomeApiClient>();
          return AirConditionerRepository(
            airConditionerApi: AirConditionerApi(
              apiClient: apiClient,
            ),
            authRepository: authRepository,
            deviceApi: DeviceApi(
              smartHomeApiClient: apiClient,
              authRepository: authRepository,
            ),
            mqttClient: context.read<MqttSmartHomeClient>(),
          );
        },
        child: AirConditionerPage(home: home, room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AirConditionerBloc(
        home: home,
        room: room,
        airConditionerRepository: context.read<AirConditionerRepository>(),
        homeRepository: context.read<HomeRepository>(),
      )
        ..add(
          const AirConditionerMqttStatusSubscriptionRequestEvent(),
        )
        ..add(
          const AirConditionerProcessorStatusSubscriptionRequestEvent(),
        )
        ..add(const AirConditionerListInitEvent())
        ..add(const AirConditionerStatusSubscriptionRequestEvent()),
      child: const AirConditionerView(),
    );
  }
}

class AirConditionerView extends StatelessWidget {
  const AirConditionerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AirConditionerBloc, AirConditionerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${state.room.name} - ${AppLocalizations.of(context).ac}',
            ),
          ),
          body: Builder(
            builder: (context) {
              switch (state.status) {
                case AirConditionerStatus.initial:
                  return const InitialView();
                case AirConditionerStatus.loading:
                  return const LoadingView();
                case AirConditionerStatus.success:
                  return AirConditionerOverview(
                    room: state.room,
                    devices: state.devices,
                  );
                case AirConditionerStatus.failure:
                  return ErrorView(
                    message: state.requestError,
                    retryCallback: () => context.read<AirConditionerBloc>().add(
                          const AirConditionerListInitEvent(),
                        ),
                  );
              }
            },
          ),
        );
      },
    );
  }
}
