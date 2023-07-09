import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home/scene_action_edit/bloc/scene_action_edit_bloc.dart';

class SceneActionEditPage extends StatelessWidget {
  const SceneActionEditPage({
    super.key,
    required this.scene,
    this.action,
    this.device,
  });

  final Scene scene;
  final SceneAction? action;
  final Device? device;

  static Route<void> route({
    required Scene scene,
    SceneAction? action,
    Device? device,
    required SceneActionRepository sceneActionRepository,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => SceneActionEditBloc(
          scene: scene,
          action: action,
          sceneActionRepository: sceneActionRepository,
        ),
        child: SceneActionEditPage(
          scene: scene,
          action: action,
          device: device,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SceneActionEditView(
      scene: scene,
      action: action,
      device: device,
    );
  }
}

class SceneActionEditView extends StatelessWidget {
  const SceneActionEditView({
    super.key,
    required this.scene,
    this.action,
    this.device,
  });

  final Scene scene;
  final SceneAction? action;
  final Device? device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${action == null ? 'Create' : 'Edit'} Scene Action'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.of(context).popUntil((route) => route.)
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }
}
