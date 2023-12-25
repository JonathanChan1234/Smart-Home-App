import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_action/view/scene_action_page.dart';
import 'package:smart_home/scene_edit/view/scene_edit_page.dart';
import 'package:smart_home/scenes/bloc/scene_bloc.dart';
import 'package:smart_home/smart_home_connect/bloc/smart_home_connect_bloc.dart';

class ScenePopulated extends StatelessWidget {
  const ScenePopulated({
    super.key,
    required this.scenes,
  });

  final List<Scene> scenes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context);

    return BlocListener<SceneBloc, SceneState>(
      listenWhen: (previous, current) =>
          previous.activateStatus != current.activateStatus,
      listener: (context, state) {
        if (state.activateStatus == SceneActivateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizations.sceneActivateSuccessMessage(
                  state.activateScene?.name ?? '',
                ),
              ),
            ),
          );
          return;
        }
        if (state.activateStatus == SceneActivateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '''
                ${localizations.sceneActivateFailureMessage(state.activateScene?.name ?? '')}. ${state.error}''',
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Builder(
          builder: (context) {
            if (scenes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.question_mark, size: 96),
                    Text(
                      'You do have any scene yet',
                      style: textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () {
                context.read<SceneBloc>().add(const SceneListInitEvent());
                return Future.value();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Wrap(
                  children: scenes
                      .map(
                        (scene) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: _SceneCard(scene: scene),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            final home = context.read<HomeBloc>().state.selectedHome;
            if (home == null) return;
            Navigator.of(context).push(SceneEditPage.route(home: home));
          },
        ),
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final state = context.watch<SceneBloc>().state;
    return SizedBox(
      width: 175,
      height: 150,
      child: GestureDetector(
        onTap: state.activateStatus == SceneActivateStatus.loading
            ? null
            : () => context
                .read<SceneBloc>()
                .add(SceneActivatedEvent(scene: scene)),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.bolt_outlined, size: 50),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          SceneActionPage.route(
                            home:
                                context.read<SmartHomeConnectBloc>().state.home,
                            scene: scene,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scene.name,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.titleLarge!.copyWith(fontSize: 20),
                    ),
                    if (state.activateStatus == SceneActivateStatus.loading &&
                        state.activateScene?.id == scene.id)
                      const CircularProgressIndicator(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
