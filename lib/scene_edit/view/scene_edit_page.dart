import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_api/scene_api.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home/scene_edit/bloc/scene_edit_bloc.dart';

class SceneEditPage extends StatelessWidget {
  const SceneEditPage({
    super.key,
  });

  static Route<String?> route(
    Scene scene,
    SceneRepository sceneRepository,
  ) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => SceneEditBloc(
          scene: scene,
          sceneRepository: sceneRepository,
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
        if (state.eventType == SceneEditEventType.edit &&
            state.status == SceneEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Scene name changed successfully')),
          );
          Navigator.of(context).pop(state.name);
          return;
        }
        if (state.eventType == SceneEditEventType.delete &&
            state.status == SceneEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Scene name deleted successfully')),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }
        if (state.status == SceneEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.requestError)),
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
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    Future<bool?> showDeleteConfirmDialog() async {
      return showDialog<bool?>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Scene'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    '''
                    Are you sure that you want to delete this scene? 
                    This will remove all the scene actions. 
                    This is an irreversiable change.''',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: theme.textTheme.bodySmall,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: theme.textTheme.bodySmall,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Scene'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Edit',
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
                ElevatedButton(
                  onPressed: () async {
                    final ans = await showDeleteConfirmDialog();
                    if (ans == null || !ans) return;
                    if (context.mounted) {
                      context
                          .read<SceneEditBloc>()
                          .add(const SceneEditDeleteEvent());
                    }
                  },
                  child: Text(
                    'Delete Scene',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
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
      key: const Key('lightEdit_name_text_form'),
      initialValue: state.scene.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'Scene Name',
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
