import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/rooms/bloc/rooms_bloc.dart';
import 'package:smart_home/rooms/widgets/room_card.dart';

class FloorsList extends StatelessWidget {
  const FloorsList({
    super.key,
    required this.floors,
  });

  final List<Floor> floors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedFloor = context.watch<RoomsBloc>().state.selectedFloor;
    final isFavorite = context.watch<RoomsBloc>().state.isFavorite;

    List<Widget> floorToListWidget({
      required Floor floor,
      required bool isFavorite,
    }) {
      final rooms = floor.rooms.where((room) => !isFavorite || room.isFavorite);
      if (rooms.isEmpty) return [];
      return [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            floor.name,
            style: textTheme.titleSmall,
          ),
        ),
        ...rooms.map((room) => RoomCard(room: room)),
        const SizedBox(
          height: 12,
        ),
      ];
    }

    final items = <Widget>[];
    for (final floor in floors) {
      if (selectedFloor == null) {
        items.addAll(floorToListWidget(floor: floor, isFavorite: isFavorite));
      } else if (floor.id == selectedFloor.id) {
        items.addAll(floorToListWidget(floor: floor, isFavorite: false));
      }
    }

    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => items[index],
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}
