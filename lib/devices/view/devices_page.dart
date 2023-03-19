import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/devices/cubit/devices_cubit.dart';
import 'package:smart_home/devices/widgets/widget.dart';
import 'package:smart_home/rooms/models/room.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  static Route<void> route(Room room) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => DevicesCubit(room),
        child: const DevicesView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DevicesView();
  }
}

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final room = context.select((DevicesCubit cubit) => cubit.state.room);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(room.name),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('ROOM SERVICES', style: textTheme.titleSmall),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      DeviceTile(
                        name: 'Lights',
                        icon: Icons.lightbulb,
                        statusText: 'ON',
                        showMore: true,
                        room: room,
                      ),
                      DeviceTile(
                        name: 'Shades',
                        icon: Icons.roller_shades,
                        showMore: true,
                        room: room,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
