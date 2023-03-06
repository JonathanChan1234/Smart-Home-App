import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/devices/view/devices_page.dart';
import 'package:smart_home/rooms/models/model.dart';
import 'package:smart_home/rooms/room.dart';

class RoomCardList extends StatelessWidget {
  const RoomCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RoomsCubit>().state;
    final rooms = state.rooms;
    final floors = state.floors;
    final isAllRoomSelected = state.selectedFloor == RoomsState.all;
    final textTheme = Theme.of(context).textTheme;

    List<Widget> floorRoomToListWidget() {
      final widgets = <Widget>[];
      for (final floor in floors) {
        widgets
          ..add(
            Text(
              floor,
              style: textTheme.titleSmall,
            ),
          )
          ..add(
            const SizedBox(
              height: 6,
            ),
          )
          ..addAll(
            rooms
                .where((room) => room.floor == floor)
                .map((room) => _RoomCard(room: room)),
          )
          ..add(
            const SizedBox(
              height: 12,
            ),
          );
      }
      return widgets;
    }

    if (isAllRoomSelected) {
      final widgets = [
        Text('Favorites', style: textTheme.titleSmall),
        const SizedBox(
          height: 6,
        ),
        ...rooms.where((room) => room.isFavorite).map(
              (room) => _RoomCard(room: room),
            ),
        const SizedBox(
          height: 12,
        ),
        ...floorRoomToListWidget()
      ];
      return Expanded(
        child: ListView.builder(
          itemCount: widgets.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => widgets[index],
        ),
      );
    }

    final roomCards =
        state.filteredRooms.map((room) => _RoomCard(room: room)).toList();

    return rooms.isEmpty
        ? _EmptyItemCard()
        : Expanded(
            child: ListView.builder(
              itemCount: roomCards.length,
              itemBuilder: (context, index) => roomCards[index],
            ),
          );
  }
}

class _EmptyItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.question_mark,
                size: 128,
                color: Colors.redAccent,
              ),
            ),
            Text('You do not have any favorite room yet'),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room});

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
          subtitle: Text(
            '${room.numberOfDevices} devices',
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: room.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              // TODO: Add the toggle favorite logic
            },
          ),
        ),
      ),
    );
  }
}
