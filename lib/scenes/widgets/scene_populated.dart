import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_api/scene_api.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
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

    return BlocListener<SceneBloc, SceneState>(
      listener: (context, state) {
        if (state.activateStatus == SceneActivateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '''Scene ${state.activateScene?.name ?? ''} activated successfully''',
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
                Fail to activate scene ${state.activateScene?.name ?? ''}. 
                Error: ${state.error}''',
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
                    const Icon(Icons.error, size: 96),
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
              child: GridView.count(
                padding: const EdgeInsets.all(8),
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children:
                    scenes.map((scene) => _SceneCard(scene: scene)).toList(),
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
    return GestureDetector(
      onTap: state.activateStatus == SceneActivateStatus.loading
          ? null
          : () =>
              context.read<SceneBloc>().add(SceneActivatedEvent(scene: scene)),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.bookmark, size: 30),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        SceneActionPage.route(
                          home: context.read<SmartHomeConnectBloc>().state.home,
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
                    style: textStyle.titleLarge,
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
    );
  }
}
