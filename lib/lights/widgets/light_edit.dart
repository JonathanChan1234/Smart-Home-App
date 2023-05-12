import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lights_api/lights_api.dart';
import 'package:lights_repository/lights_repository.dart';
import 'package:smart_home/light_edit/view/light_edit_page.dart';

class LightEdit extends StatelessWidget {
  const LightEdit({
    super.key,
    required this.light,
  });

  final Light light;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(light.name),
            trailing: IconButton(
              icon: const Icon(Icons.mode_edit),
              onPressed: () {
                Navigator.of(context).push(
                  LightEditPage.route(
                    light,
                    context.read<LightsRepository>(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
