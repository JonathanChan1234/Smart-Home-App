import 'package:auth_repository/auth_repository.dart';
import 'package:devices_api/devices_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/devices/bloc/devices_bloc.dart';
import 'package:smart_home/devices/widgets/widget.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({
    super.key,
    required this.home,
    required this.room,
  });

  final SmartHome home;
  final Room room;

  static Route<void> route({
    required SmartHome home,
    required Room room,
  }) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (_) => DevicesBloc(
          home: home,
          room: room,
          deviceApi: DeviceApi(
            authRepository: context.read<AuthRepository>(),
            smartHomeApiClient: context.read<SmartHomeApiClient>(),
          ),
        )..add(FetchDeviceListEvent()),
        child: DevicesPage(home: home, room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DevicesView();
  }
}

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(context.read<DevicesBloc>().state.room.name),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<DevicesBloc>().add(FetchDeviceListEvent()),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: BlocBuilder<DevicesBloc, DevicesState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case DevicesStatus.initial:
              return const DevicesInitial();
            case DevicesStatus.loading:
              return const DevicesLoading();
            case DevicesStatus.success:
              return DevicesOverview(
                devices: state.devices
                    .where((device) => device.numberOfDevice != 0)
                    .toList(),
                home: state.home,
                room: state.room,
              );
            case DevicesStatus.failure:
              return DevicesError(message: state.requestError);
          }
        },
      ),
    );
  }
}
