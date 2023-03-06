import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/rooms/cubit/rooms_cubit.dart';
import 'package:smart_home/rooms/widgets/room_overview.dart';
import 'package:smart_home/rooms/widgets/widget.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit()..getAllRooms(),
      child: const RoomView(),
    );
  }
}

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<RoomsCubit>().getAllRooms();
            },
          )
        ],
      ),
      body: BlocBuilder<RoomsCubit, RoomsState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.selectedFloor != current.selectedFloor,
        builder: (context, state) {
          switch (state.status) {
            case RoomsStatus.initial:
              return const RoomInitial();
            case RoomsStatus.loading:
              return const RoomLoading();
            case RoomsStatus.success:
              return RoomOverview(
                floors: state.floors,
              );
            case RoomsStatus.failure:
              return const RoomError();
          }
        },
      ),
    );
  }
}
