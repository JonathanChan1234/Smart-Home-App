import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/smart_home_connect/bloc/smart_home_connect_bloc.dart';

class SmartHomeConnectDisconnected extends StatelessWidget {
  const SmartHomeConnectDisconnected({
    super.key,
    required this.home,
  });

  final SmartHome home;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_tethering_error,
            size: 100,
          ),
          Text(
            'Disconnnected from ${home.name}',
            style: textTheme.headlineSmall,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () => context
                .read<SmartHomeConnectBloc>()
                .add(const SmartHomeConnectRequestEvent()),
            child: const Text('Reconnect'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () =>
                context.read<HomeBloc>().add(const HomeDeselectedEvent()),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
