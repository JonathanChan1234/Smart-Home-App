import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:lights_api/lights_api.dart';
import 'package:lights_repository/lights_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/lights/bloc/light_bloc.dart';
import 'package:smart_home/lights/widgets/widget.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class LightPage extends StatelessWidget {
  const LightPage({
    super.key,
    required this.room,
    required this.home,
  });

  final Room room;
  final SmartHome home;

  static Route<void> route({
    required SmartHome home,
    required Room room,
  }) {
    return MaterialPageRoute(
      builder: (_) => RepositoryProvider(
        create: (context) => LightsRepository(
          authRepository: context.read<AuthRepository>(),
          mqttClient: context.read<MqttSmartHomeClient>(),
          lightsApi: LightsApi(
            smartHomeApiClient: context.read<SmartHomeApiClient>(),
          ),
        ),
        child: BlocProvider(
          create: (context) => LightBloc(
            lightsRepository: context.read<LightsRepository>(),
            room: room,
            home: home,
          )
            ..add(
              const LightStatusSubscriptionRequestedEvent(),
            )
            ..add(const LightListInitEvent()),
          child: LightPage(home: home, room: room),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LightView();
  }
}

class LightView extends StatelessWidget {
  const LightView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LightBloc, LightState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('${state.room.name} - Lighting')),
          body: Builder(
            builder: (_) {
              switch (state.status) {
                case LightStatus.initial:
                  return const LightInitial();
                case LightStatus.loading:
                  return const LightLoading();
                case LightStatus.success:
                  return LightOverview(lights: state.lights);
                case LightStatus.failure:
                  return LightError(message: state.requestError);
              }
            },
          ),
        );
      },
    );
  }
}
