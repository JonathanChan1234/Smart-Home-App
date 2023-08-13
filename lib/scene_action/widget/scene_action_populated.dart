import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_action/bloc/scene_action_bloc.dart';
import 'package:smart_home/scene_action/helper/action_translation_helper.dart';
import 'package:smart_home/scene_action_device/view/scene_action_device_page.dart';
import 'package:smart_home/scene_action_edit/view/scene_action_edit_page.dart';
import 'package:smart_home/scene_edit/view/scene_edit_page.dart';

class SceneActionPopulated extends StatelessWidget {
  const SceneActionPopulated({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SceneActionBloc>().state;
    final actions = state.actions;
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(state.scene.name),
        actions: [
          IconButton(
            onPressed: () async {
              final home = context.read<HomeBloc>().state.selectedHome;
              if (home == null) return;
              final newSceneName = await Navigator.of(context).push<String?>(
                SceneEditPage.route(
                  home: home,
                  scene: state.scene,
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
            leading: Icon(action.device.deviceMainCategory.icon),
            title: Text(action.device.name),
            subtitle: Text(
              SceneActionTranslationHelper.toDescription(
                action,
                localizations,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () {
                Navigator.of(context).push(
                  SceneActionEditPage.route(
                    scene: state.scene,
                    action: action,
                  ),
                );
              },
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
            ),
          );
        },
      ),
    );
  }
}
