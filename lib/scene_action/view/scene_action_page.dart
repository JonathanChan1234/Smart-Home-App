import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home/scene_action/bloc/scene_action_bloc.dart';
import 'package:smart_home/scene_action/widget/scene_action_populated.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';

class SceneActionPageArgument {
  const SceneActionPageArgument({
    required this.home,
    required this.scene,
  });

  final SmartHome home;
  final Scene scene;
}

class SceneActionPage extends StatelessWidget {
  const SceneActionPage({
    super.key,
    required this.home,
    required this.scene,
  });

  static const routeName = 'sceneAction';

  final SmartHome home;
  final Scene scene;

  static Route<void> route({
    required SmartHome home,
    required Scene scene,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: SceneActionPage.routeName,
        arguments: SceneActionPageArgument(home: home, scene: scene),
      ),
      builder: (_) => BlocProvider(
        create: (context) => SceneActionBloc(
          home: home,
          scene: scene,
          sceneActionRepository: context.read<SceneActionRepository>(),
        )
          ..add(const SceneActionSubscriptionRequestEvent())
          ..add(const SceneActionInitEvent()),
        child: SceneActionPage(
          home: home,
          scene: scene,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SceneActionView();
  }
}

class SceneActionView extends StatelessWidget {
  const SceneActionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SceneActionBloc, SceneActionState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        switch (state.status) {
          case SceneActionStatus.initial:
            return const InitialView(title: 'Initializing Scene Action');
          case SceneActionStatus.loading:
            return const LoadingView(message: 'Loading...');
          case SceneActionStatus.success:
            return const SceneActionPopulated();
          case SceneActionStatus.failure:
            return ErrorView(
              message: state.error,
              retryCallback: () => context
                  .read<SceneActionBloc>()
                  .add(const SceneActionInitEvent()),
            );
        }
      },
    );
  }
}
