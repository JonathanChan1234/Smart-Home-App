import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_action_device/bloc/scene_action_device_bloc.dart';
import 'package:smart_home/scene_action_edit/view/scene_action_edit_page.dart';

class SceneActionDevicePopulated extends StatelessWidget {
  const SceneActionDevicePopulated({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SceneActionDeviceBloc>().state;
    final devices = state.devices;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${state.scene.name} - ${AppLocalizations.of(context).createAction}',
        ),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            leading: Icon(device.deviceMainCategory.icon),
            title: Text(device.name),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () {
                Navigator.of(context).push(
                  SceneActionEditPage.route(
                    scene: state.scene,
                    device: device,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
