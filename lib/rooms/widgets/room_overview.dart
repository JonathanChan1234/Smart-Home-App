import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/rooms/room.dart';

class RoomOverview extends StatelessWidget {
  const RoomOverview({super.key, required this.floors});
  final List<String> floors;

  @override
  Widget build(BuildContext context) {
    final selectedFloor =
        context.select((RoomsCubit cubit) => cubit.state.selectedFloor);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: selectedFloor,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (String? value) {
            context.read<RoomsCubit>().setSelectedFloor(value ?? selectedFloor);
          },
          items: [
            const DropdownMenuItem(value: RoomsState.all, child: Text('All')),
            const DropdownMenuItem(
              value: RoomsState.favorite,
              child: Text('Favorite'),
            ),
            for (final floor in floors)
              DropdownMenuItem(value: floor, child: Text(floor))
          ],
        ),
        const RoomCardList(),
      ],
    );
  }
}
