import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_action/view/scene_action_page.dart';
import 'package:smart_home/scene_action_edit/bloc/scene_action_edit_bloc.dart';
import 'package:smart_home/scene_action_edit/widgets/light/light_action_edit.dart';
import 'package:smart_home/scene_action_edit/widgets/shade/shade_action_edit.dart';
import 'package:smart_home/widgets/confirm_dialog.dart';
import 'package:smart_home/widgets/error_view.dart';

class SceneActionEditArgument {
  const SceneActionEditArgument({
    required this.scene,
    this.action,
    this.device,
  });

  final Scene scene;
  final SceneAction? action;
  final Device? device;
}

class SceneActionEditPage extends StatelessWidget {
  const SceneActionEditPage({
    super.key,
    required this.scene,
    this.action,
    this.device,
  });

  static const routeName = 'sceneActionEdit';

  final Scene scene;
  final SceneAction? action;
  final Device? device;

  static Route<void> route({
    required Scene scene,
    SceneAction? action,
    Device? device,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => SceneActionEditBloc(
          scene: scene,
          action: action,
          sceneActionRepository: context.read<SceneActionRepository>(),
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
    return BlocListener<SceneActionEditBloc, SceneActionEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final localizations = AppLocalizations.of(context);
        if (state.status == SceneActionEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.action != null
                    ? state.eventType == SceneActionEditEventType.edit
                        ? localizations.editActionSuccessMessage
                        : localizations.deleteActionSuccessMessage
                    : localizations.createActionSuccessMessage,
              ),
            ),
          );
          Navigator.of(context)
              .popUntil(ModalRoute.withName(SceneActionPage.routeName));
          return;
        }

        if (state.status == SceneActionEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.action != null
                    ? state.eventType == SceneActionEditEventType.edit
                        ? localizations.editActionFailureMessage
                        : localizations.deleteActionFailureMessage
                    : localizations.createActionFailureMessage +
                        (state.requestError ??
                            localizations.somethingWentWrong),
              ),
            ),
          );
        }
      },
      child: SceneActionEditView(
        scene: scene,
        action: action,
        device: device,
      ),
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
    final localizations = AppLocalizations.of(context);
    final actionDevice = device ?? action?.device;
    if (actionDevice == null) {
      return ErrorView(
        message: localizations.failToFindAction,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          actionDevice.name,
        ),
        actions: [
          if (action != null)
            IconButton(
              onPressed: () async {
                final deleted = await showDialog<bool?>(
                  context: context,
                  builder: (dialogContext) => ConfirmDialog(
                    title: localizations.deleteAction,
                    content: localizations.deleteActionDialogContent,
                    onLeftBtnClick: () {
                      Navigator.pop(dialogContext, false);
                    },
                    onRightBtnClick: () {
                      Navigator.pop(dialogContext, true);
                    },
                  ),
                );
                if (deleted == null || !deleted) return;
                if (context.mounted) {
                  context
                      .read<SceneActionEditBloc>()
                      .add(const SceneActionEditDeletedEvent());
                }
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: Builder(
        builder: (_) {
          switch (actionDevice.deviceMainCategory) {
            case DeviceMainCategory.light:
              return LightActionEditPage(
                light: actionDevice,
                action: action,
              );
            case DeviceMainCategory.shade:
              return ShadeActionEditPage(
                shade: actionDevice,
                action: action,
              );
            case DeviceMainCategory.unknown:
              return ErrorView(
                message: localizations.deviceTypeNotSupported,
              );
          }
        },
      ),
    );
  }
}
