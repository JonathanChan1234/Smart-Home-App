import 'package:flutter/material.dart';
import 'package:smart_home/rooms/models/floor.dart';
import 'package:smart_home/rooms/widgets/room_card.dart';

class FloorsList extends StatelessWidget {
  const FloorsList({super.key, required this.floors});

  final List<Floor> floors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final widgets = <Widget>[];
    for (final floor in floors) {
      widgets
        ..add(
          Text(
            floor.name,
            style: textTheme.titleSmall,
          ),
        )
        ..add(
          const SizedBox(
            height: 6,
          ),
        )
        ..addAll(
          floor.rooms.map((room) => RoomCard(room: room)),
        )
        ..add(
          const SizedBox(
            height: 12,
          ),
        );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: widgets.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => widgets[index],
      ),
    );
  }
}
