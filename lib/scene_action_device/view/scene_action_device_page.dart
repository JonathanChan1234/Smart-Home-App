import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_action_device/bloc/scene_action_device_bloc.dart';
import 'package:smart_home/scene_action_device/widgets/scene_action_device_populated.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';

class SceneActionDevicePage extends StatelessWidget {
  const SceneActionDevicePage({super.key});

  static Route<void> route(
    Scene scene,
  ) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (_) => SceneActionDeviceBloc(
          scene: scene,
          sceneActionRepository: context.read<SceneActionRepository>(),
        )
          ..add(const SceneActionDeviceInitEvent())
          ..add(const SceneActionDeviceSubscriptionRequestEvent()),
        child: const SceneActionDevicePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SceneActionDeviceView();
  }
}

class SceneActionDeviceView extends StatelessWidget {
  const SceneActionDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SceneActionDeviceBloc, SceneActionDeviceState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        switch (state.status) {
          case SceneActionDeviceStatus.initial:
            return InitialView(title: localizations.initializing);
          case SceneActionDeviceStatus.loading:
            return LoadingView(message: localizations.loading);
          case SceneActionDeviceStatus.success:
            return const SceneActionDevicePopulated();
          case SceneActionDeviceStatus.failure:
            return ErrorView(
              message: state.error,
              retryCallback: () => context
                  .read<SceneActionDeviceBloc>()
                  .add(const SceneActionDeviceInitEvent()),
            );
        }
      },
    );
  }
}
