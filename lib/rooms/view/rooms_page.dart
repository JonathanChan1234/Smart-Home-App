import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_api/room_api.dart' hide Floor;
import 'package:smart_home/rooms/cubit/rooms_cubit.dart';
import 'package:smart_home/rooms/widgets/room_overview.dart';
import 'package:smart_home/rooms/widgets/widget.dart';
import 'package:smart_home/smart_home/models/smart_home.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  static Route<void> route(SmartHome home) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => RoomsCubit(
            home: home,
            roomApi: RoomApi(
              authRepository: context.read<AuthRepository>(),
              smartHomeApiClient: context.read<SmartHomeApiClient>(),
            ),
          )..getAllRooms(),
          child: const RoomView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const RoomView();
  }
}

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeName = context.read<RoomsCubit>().state.home.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(homeName),
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
            previous.selectedFloorId != current.selectedFloorId,
        builder: (context, state) {
          switch (state.status) {
            case RoomsStatus.initial:
              return const RoomInitial();
            case RoomsStatus.loading:
              return const RoomLoading();
            case RoomsStatus.success:
              return RoomOverview(
                floors: state.floors,
                selectedFloorId: state.selectedFloorId,
              );
            case RoomsStatus.failure:
              return const RoomError();
          }
        },
      ),
    );
  }
}
