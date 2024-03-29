import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shades_api/shades_api.dart';
import 'package:shades_repository/shades_repository.dart';
import 'package:smart_home/shade_edit/view/shade_edit_page.dart';

class ShadeEdit extends StatelessWidget {
  const ShadeEdit({
    super.key,
    required this.shade,
  });

  final Shade shade;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 34, 37, 44),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              shade.name,
              style: const TextStyle(
                color: Color.fromARGB(255, 119, 120, 124),
                fontSize: 18,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.mode_edit,
                color: Color.fromARGB(255, 223, 224, 227),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  ShadeEditPage.route(
                    shade: shade,
                    shadesRepository: context.read<ShadesRepository>(),
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
