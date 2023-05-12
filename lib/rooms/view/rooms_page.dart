import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/rooms/bloc/rooms_bloc.dart';
import 'package:smart_home/rooms/widgets/widget.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({
    super.key,
    required this.home,
  });

  final SmartHome home;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (cotnext) => RoomsBloc(
        home: home,
        roomRepository: context.read<RoomRepository>(),
      )
        ..add(const RoomSubscriptionRequestEvent())
        ..add(const RoomListInitEvent()),
      child: const RoomView(),
    );
  }
}

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    void showExitDialog(String homeName) {
      final alert = AlertDialog(
        title: const Text('Exit Home'),
        content: Text(
          'Would you like to exit $homeName?',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<HomeBloc>().add(const HomeDeselectedEvent());
            },
            style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text(
              'Exit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return BlocBuilder<RoomsBloc, RoomsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.home.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<RoomsBloc>().add(const RoomListInitEvent()),
              ),
              IconButton(
                onPressed: () => {showExitDialog(state.home.name)},
                icon: const Icon(Icons.exit_to_app_sharp),
              ),
            ],
          ),
          body: Builder(
            builder: (_) {
              switch (state.status) {
                case RoomsStatus.initial:
                  return const RoomInitial();
                case RoomsStatus.loading:
                  return const RoomLoading();
                case RoomsStatus.success:
                  return const RoomOverview();
                case RoomsStatus.failure:
                  return const RoomError();
              }
            },
          ),
        );
      },
    );
  }
}
