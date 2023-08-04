import 'package:flutter/material.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/smart_home_connect/bloc/smart_home_connect_bloc.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_control_overview.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';

class SmartHomeConnected extends StatelessWidget {
  const SmartHomeConnected({
    super.key,
    required this.home,
    required this.status,
  });

  final SmartHome home;
  final SmartHomeProcessorConnectStatus status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home ${home.name}')),
      body: Builder(
        builder: (context) {
          switch (status) {
            case SmartHomeProcessorConnectStatus.initial:
              return const InitialView(title: 'Finding Your Home Processor');
            case SmartHomeProcessorConnectStatus.notExist:
              return const ErrorView(
                message:
                    '''No home processor in your home. Please contact your installer for more details''',
              );
            case SmartHomeProcessorConnectStatus.offline:
              return const ErrorView(
                message:
                    '''Your home processor is currently offline. Please check the network connection of your processor''',
              );
            case SmartHomeProcessorConnectStatus.online:
              return SmartHomeControlOverview(home: home);
          }
        },
      ),
    );
  }
}
