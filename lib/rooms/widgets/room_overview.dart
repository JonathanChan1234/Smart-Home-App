import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/rooms/models/floor.dart';
import 'package:smart_home/rooms/models/room.dart';
import 'package:smart_home/rooms/room.dart';
import 'package:smart_home/rooms/widgets/floors_list.dart';

class RoomOverview extends StatelessWidget {
  const RoomOverview(
      {super.key, required this.selectedFloorId, required this.floors});

  final List<Floor> floors;
  final String selectedFloorId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: selectedFloorId,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (String? value) {
            context
                .read<RoomsCubit>()
                .setSelectedFloor(value ?? selectedFloorId);
          },
          items: [
            const DropdownMenuItem(value: RoomsState.all, child: Text('All')),
            const DropdownMenuItem(
              value: RoomsState.favorite,
              child: Text('Favorite'),
            ),
            for (final floor in floors)
              DropdownMenuItem(value: floor.id, child: Text(floor.name))
          ],
        ),
        IndexedStack(
          index: selectedFloorId == RoomsState.all
              ? 0
              : selectedFloorId == RoomsState.favorite
                  ? 1
                  : 2,
          children: [
            FloorsList(floors: floors),
            FloorRoomList(
              rooms: floors
                  .map((floor) => floor.rooms)
                  .expand((rooms) => rooms)
                  .where((room) => room.isFavorite)
                  .toList(),
            ),
            Builder(
              builder: (context) {
                final floor =
                    floors.where((floor) => floor.id == selectedFloorId);
                return FloorRoomList(
                  rooms: floor.isEmpty ? <Room>[] : floor.first.rooms,
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
