import 'package:flutter/material.dart';
import 'package:smart_home/rooms/models/room.dart';
import 'package:smart_home/rooms/widgets/room_card.dart';

class FloorRoomList extends StatelessWidget {
  const FloorRoomList({
    super.key,
    required this.rooms,
  });

  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    return rooms.isEmpty
        ? _EmptyItemCard()
        : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rooms.length,
              itemBuilder: (context, index) =>
                  rooms.map((room) => RoomCard(room: room)).toList()[index],
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
            Text('You do not have any room yet'),
          ],
        ),
      ),
    );
  }
}
