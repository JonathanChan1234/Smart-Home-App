import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/devices/view/devices_page.dart';
import 'package:smart_home/rooms/cubit/rooms_cubit.dart';
import 'package:smart_home/rooms/models/room.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(DevicesPage.route(room));
      },
      child: Card(
        child: ListTile(
          title: Text(room.name),
          subtitle: const Text(
            '1 devices',
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: room.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              context
                  .read<RoomsCubit>()
                  .updateRoom(room, isFavorite: !room.isFavorite);
            },
          ),
        ),
      ),
    );
  }
}
