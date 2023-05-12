import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/rooms/bloc/rooms_bloc.dart';
import 'package:smart_home/rooms/widgets/floors_list.dart';

class RoomOverview extends StatelessWidget {
  const RoomOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final floors = context.watch<RoomsBloc>().state.floors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoomFilterDropdownMenu(floors: floors),
        FloorsList(
          floors: floors,
        ),
      ],
    );
  }
}

class _RoomFilterDropdownMenu extends StatelessWidget {
  const _RoomFilterDropdownMenu({required this.floors});

  final List<Floor> floors;

  static const floorAll = 'all';
  static const floorFavorite = 'favorite';

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<RoomsBloc>().state.isFavorite;
    final selectedFloor = context.watch<RoomsBloc>().state.selectedFloor;

    void handleDropdownChanged(String? value) {
      if (value == floorAll) {
        context.read<RoomsBloc>().add(
              const RoomFilterUpdatedEvent(),
            );
      } else if (value == floorFavorite) {
        context.read<RoomsBloc>().add(
              const RoomSetFavoriteFilterEvent(),
            );
      } else {
        try {
          final floor = floors.firstWhere((floor) => floor.id == value);
          context.read<RoomsBloc>().add(
                RoomFilterUpdatedEvent(floor: floor),
              );
        } catch (e) {
          context.read<RoomsBloc>().add(
                const RoomFilterUpdatedEvent(),
              );
        }
      }
    }

    return DropdownButton<String>(
      value: isFavorite
          ? floorFavorite
          : selectedFloor == null
              ? floorAll
              : selectedFloor.id,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      onChanged: handleDropdownChanged,
      items: [
        const DropdownMenuItem(value: floorAll, child: Text('All')),
        const DropdownMenuItem(
          value: floorFavorite,
          child: Text('Favorite'),
        ),
        for (final floor in floors)
          DropdownMenuItem(value: floor.id, child: Text(floor.name))
      ],
    );
  }
}
