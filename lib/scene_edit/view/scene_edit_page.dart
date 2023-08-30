import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:scene_api/scene_api.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_edit/bloc/scene_edit_bloc.dart';
import 'package:smart_home/widgets/confirm_dialog.dart';

class SceneEditPage extends StatelessWidget {
  const SceneEditPage({
    super.key,
  });

  static Route<String?> route({
    required SmartHome home,
    Scene? scene,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => SceneEditBloc(
          home: home,
          scene: scene,
          sceneRepository: context.read<SceneRepository>(),
        ),
        child: const SceneEditPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SceneEditBloc, SceneEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final localizations = AppLocalizations.of(context);
        var message = '';
        if (state.scene == null) {
          message = state.status == SceneEditStatus.success
              ? localizations.sceneCreatedSuccessMessage
              : localizations.sceneCreatedFailureMessage;
        } else if (state.eventType == SceneEditEventType.edit) {
          message = state.status == SceneEditStatus.success
              ? localizations.sceneNameChangedSuccessMessage
              : localizations.sceneNameChangedFailureMessage;
        } else {
          message = state.status == SceneEditStatus.success
              ? localizations.sceneDeletedSuccessMessage
              : localizations.sceneDeletedFailureMessage;
        }
        if (state.status == SceneEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          if (state.eventType == SceneEditEventType.delete) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            return;
          }
          Navigator.of(context).pop(state.name);
          return;
        }
        if (state.status == SceneEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
      child: const SceneEditView(),
    );
  }
}

class SceneEditView extends StatelessWidget {
  const SceneEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((SceneEditBloc bloc) => bloc.state.status);
    final scene = context.select((SceneEditBloc bloc) => bloc.state.scene);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          scene == null ? localizations.createScene : localizations.editScene,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: scene == null ? localizations.create : localizations.edit,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context
                .read<SceneEditBloc>()
                .add(const SceneEditSubmittedEvent()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const _SceneNameField(),
                if (scene != null)
                  ElevatedButton(
                    onPressed: () async {
                      final res = await showDialog<bool?>(
                        builder: (dialogContext) => ConfirmDialog(
                          title: localizations.deleteScene,
                          content: localizations.deleteSceneDialogContent,
                          onLeftBtnClick: () =>
                              Navigator.of(dialogContext).pop(false),
                          onRightBtnClick: () =>
                              Navigator.of(dialogContext).pop(true),
                        ),
                        context: context,
                      );
                      if (res == null || !res) return;
                      if (context.mounted) {
                        context
                            .read<SceneEditBloc>()
                            .add(const SceneEditDeleteEvent());
                      }
                    },
                    child: Text(
                      localizations.deleteScene,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SceneNameField extends StatelessWidget {
  const _SceneNameField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SceneEditBloc>().state;

    return TextFormField(
      key: const Key('sceneEdit_textformfield'),
      initialValue: state.scene?.name ?? '',
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: AppLocalizations.of(context).sceneName,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context
            .read<SceneEditBloc>()
            .add(SceneEditNameChangedEvent(name: value));
      },
    );
  }
}
