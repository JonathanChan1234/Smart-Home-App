import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home/scenes/bloc/scene_bloc.dart';
import 'package:smart_home/scenes/widgets/scene_populated.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';

class ScenePage extends StatelessWidget {
  const ScenePage({
    super.key,
    required this.home,
  });

  final SmartHome home;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SceneBloc(
        homeId: home.id,
        sceneRepository: context.read<SceneRepository>(),
      )
        ..add(const SceneListInitEvent())
        ..add(const SceneListSubscriptionRequestedEvent()),
      child: const SceneView(),
    );
  }
}

class SceneView extends StatelessWidget {
  const SceneView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SceneBloc, SceneState>(
      builder: (context, state) {
        switch (state.status) {
          case SceneStatus.initial:
            return const InitialView(title: 'Initializing Your Scenes');
          case SceneStatus.loading:
            return const LoadingView(message: 'Fetching scenes information');
          case SceneStatus.success:
            return ScenePopulated(scenes: state.scenes);
          case SceneStatus.failure:
            return ErrorView(message: state.error);
        }
      },
    );
  }
}
