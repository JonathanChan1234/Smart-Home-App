import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:room_repository/room_repository.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/rooms/bloc/rooms_bloc.dart';
import 'package:smart_home/rooms/widgets/widget.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';

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
    return BlocBuilder<RoomsBloc, RoomsState>(
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        return Scaffold(
          body: Builder(
            builder: (_) {
              switch (state.status) {
                case RoomsStatus.initial:
                  return InitialView(
                    title: localizations.initializingRoom,
                  );
                case RoomsStatus.loading:
                  return LoadingView(message: '${localizations.loading}...');
                case RoomsStatus.success:
                  return const RoomOverview();
                case RoomsStatus.failure:
                  return ErrorView(
                    message: state.requestError,
                    retryCallback: () => context
                        .read<RoomsBloc>()
                        .add(const RoomListInitEvent()),
                  );
              }
            },
          ),
        );
      },
    );
  }
}
