import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:air_conditioner_repository/air_conditioner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/air_conditioner/bloc/air_conditioner_bloc.dart';
import 'package:smart_home/air_conditioner/widgets/air_conditioner_tile.dart';
import 'package:smart_home/air_conditioner_details/view/air_conditioner_details_page.dart';

class AirConditionerOverview extends StatelessWidget {
  const AirConditionerOverview({
    super.key,
    required this.room,
    required this.devices,
  });

  final Room room;
  final List<AirConditioner> devices;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.of(context).push(
          AirConditionerDetailsPage.route(
            airConditionerRepository: context.read<AirConditionerRepository>(),
            deviceId: devices[index].id,
            bloc: context.read<AirConditionerBloc>(),
          ),
        ),
        child: AirConditionerTile(airConditioner: devices[index]),
      ),
    );
  }
}
