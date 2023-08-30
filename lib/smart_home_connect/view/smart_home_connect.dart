import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/smart_home_connect/bloc/smart_home_connect_bloc.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_connect_disconnected.dart';
import 'package:smart_home/smart_home_connect/widgets/smart_home_connected.dart';
import 'package:smart_home/widgets/confirm_dialog.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';

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
      )
        ..add(const SmartHomeConnectRequestEvent())
        ..add(const SmartHomeConnectProcessorStatusSubscriptionRequestEvent())
        ..add(const SmartHomeConnectProcessStatusRefreshEvent()),
      child: const SmartHomeConnectView(),
    );
  }
}

class SmartHomeConnectView extends StatelessWidget {
  const SmartHomeConnectView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartHomeConnectBloc, SmartHomeConnectState>(
      buildWhen: (previous, current) =>
          previous.serverConnectStatus != current.serverConnectStatus ||
          previous.processorConnectStatus != current.processorConnectStatus,
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () async {
                  final res = await showDialog<bool?>(
                    context: context,
                    builder: (dialogContext) => ConfirmDialog(
                      title: localizations.exitHome,
                      content:
                          '''${localizations.exitHomeMessage} ${state.home.name}?''',
                      onLeftBtnClick: () => Navigator.of(context).pop(false),
                      onRightBtnClick: () => Navigator.of(context).pop(true),
                      rightBtnText: localizations.confirm,
                    ),
                  );
                  if (res == null || !res) return;
                  if (context.mounted) {
                    context.read<HomeBloc>().add(const HomeDeselectedEvent());
                  }
                },
              ),
            ],
            title: Text(state.home.name),
          ),
          body: Builder(
            builder: (context) {
              switch (state.serverConnectStatus) {
                case SmartHomeServerConnectStatus.initial:
                  return InitialView(
                    title: '${localizations.initializing}...',
                  );
                case SmartHomeServerConnectStatus.connecting:
                  return LoadingView(
                    message: localizations.connectingMessage,
                  );
                case SmartHomeServerConnectStatus.connected:
                  return SmartHomeConnected(
                    home: state.home,
                    status: state.processorConnectStatus,
                    error: state.connectionError,
                  );
                case SmartHomeServerConnectStatus.disconnected:
                  return SmartHomeConnectDisconnected(home: state.home);
                case SmartHomeServerConnectStatus.failure:
                  return ErrorView(message: state.connectionError);
                case SmartHomeServerConnectStatus.reconnecting:
                  return LoadingView(
                    message: localizations.reconnectingMessage,
                  );
              }
            },
          ),
        );
      },
    );
  }
}
