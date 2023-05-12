import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_api/room_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:smart_home/devices/devices.dart';
import 'package:smart_home/room_edit/view/room_edit_page.dart';
import 'package:smart_home/rooms/bloc/rooms_bloc.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final home = context.read<RoomsBloc>().state.home;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          DevicesPage.route(
            home: home,
            room: room,
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(room.name),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                RoomEditPage.route(
                  home: home,
                  room: room,
                  roomRepository: context.read<RoomRepository>(),
                ),
              );
            },
          ),
          leading: IconButton(
            icon: Icon(
              Icons.favorite,
              color: room.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              context.read<RoomsBloc>().add(
                    RoomUpdatedEvent(room: room, isFavorite: !room.isFavorite),
                  );
            },
          ),
        ),
      ),
    );
  }
}
