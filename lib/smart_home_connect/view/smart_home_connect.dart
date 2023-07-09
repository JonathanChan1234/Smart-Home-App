import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:smart_home/smart_home_connect/bloc/smart_home_connect_bloc.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_connect_connecting.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_connect_disconnected.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_connect_failure.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_connect_initial.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_connected.dart';

class SmartHomeConnect extends StatelessWidget {
  const SmartHomeConnect({
    super.key,
    required this.home,
  });

  final SmartHome home;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SmartHomeConnectBloc(
        home: home,
        homeRepository: context.read<HomeRepository>(),
      )..add(const SmartHomeConnectRequestEvent()),
      child: const SmartHomeConnectView(),
    );
  }
}

class SmartHomeConnectView extends StatelessWidget {
  const SmartHomeConnectView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartHomeConnectBloc, SmartHomeConnectState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              switch (state.status) {
                case SmartHomeConnectStatus.initial:
                  return const SmartHomeConnectInitial();
                case SmartHomeConnectStatus.connecting:
                  return SmartHomeConnectConnecting(home: state.home);
                case SmartHomeConnectStatus.connected:
                  return SmartHomeConnected(home: state.home);
                case SmartHomeConnectStatus.disconnected:
                  return SmartHomeConnectDisconnected(home: state.home);
                case SmartHomeConnectStatus.failure:
                  return SmartHomeConnectFailure(error: state.connectionError);
              }
            },
          ),
        );
      },
    );
  }
}
