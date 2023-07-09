import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_api/scene_api.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home/scene_action/view/scene_action_page.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scene'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
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
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {},
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
                          sceneRepository: context.read<SceneRepository>(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                  )
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
                  Text(
                    'X actions',
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
