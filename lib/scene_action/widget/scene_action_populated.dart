import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home/scene_action/bloc/scene_action_bloc.dart';
import 'package:smart_home/scene_action_device/view/scene_action_device_page.dart';
import 'package:smart_home/scene_edit/view/scene_edit_page.dart';

class SceneActionPopulated extends StatelessWidget {
  const SceneActionPopulated({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SceneActionBloc>().state;
    final actions = state.actions;
    return Scaffold(
      appBar: AppBar(
        title: Text(state.scene.name),
        actions: [
          IconButton(
            onPressed: () async {
              if (!context.mounted) return;
              final newSceneName = await Navigator.of(context).push<String?>(
                SceneEditPage.route(
                  state.scene,
                  context.read<SceneRepository>(),
                ),
              );
              if (context.mounted) {
                if (newSceneName == null) return;
                context
                    .read<SceneActionBloc>()
                    .add(SceneActionNameChangedEvent(name: newSceneName));
              }
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return ListTile(
            title: Text(action.device.name),
            subtitle:
                Text(actionsToDescriptionHelper(action.device, action.action)),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            SceneActionDevicePage.route(
              state.scene,
              context.read<SceneActionRepository>(),
            ),
          );
        },
      ),
    );
  }
}

String actionsToDescriptionHelper(Device device, Map<String, dynamic> actions) {
  switch (device.mainCategory.toDeviceMainCategory()) {
    case DeviceMainCategory.light:
      final lightAction = LightAction.fromJson(actions);
      return lightAction.toString();
    case DeviceMainCategory.shade:
      final shadeAction = ShadeAction.fromJson(actions);
      return shadeAction.toString();
    case DeviceMainCategory.unknown:
      return '';
  }
}
