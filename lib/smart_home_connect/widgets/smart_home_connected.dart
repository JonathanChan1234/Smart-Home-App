import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/smart_home_connect/bloc/smart_home_connect_bloc.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_control_overview.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';

class SmartHomeConnected extends StatelessWidget {
  const SmartHomeConnected({
    super.key,
    required this.home,
    required this.status,
    required this.error,
  });

  final SmartHome home;
  final ProcessorConnectionStatus status;
  final String error;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          switch (status) {
            case ProcessorConnectionStatus.initial:
              return InitialView(
                title: '${localizations.findYourProcessorMessage}...',
              );
            case ProcessorConnectionStatus.notExist:
              return ErrorView(
                message: localizations.noProcessorMessage,
                retryCallback: () => context
                    .read<SmartHomeConnectBloc>()
                    .add(const SmartHomeConnectProcessStatusRefreshEvent()),
              );
            case ProcessorConnectionStatus.offline:
              return ErrorView(
                message: localizations.offlineProcessorMessage,
                retryCallback: () => context
                    .read<SmartHomeConnectBloc>()
                    .add(const SmartHomeConnectProcessStatusRefreshEvent()),
              );
            case ProcessorConnectionStatus.online:
              return SmartHomeControlOverview(home: home);
            case ProcessorConnectionStatus.failure:
              return ErrorView(
                message: error,
                retryCallback: () => context
                    .read<SmartHomeConnectBloc>()
                    .add(const SmartHomeConnectProcessStatusRefreshEvent()),
              );
            case ProcessorConnectionStatus.loading:
              return LoadingView(
                message: '${localizations.findYourProcessorMessage}...',
              );
          }
        },
      ),
    );
  }
}
