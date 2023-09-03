import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:air_conditioner_repository/air_conditioner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/air_conditioner/bloc/air_conditioner_bloc.dart';
import 'package:smart_home/air_conditioner_details/widgets/fan_speed_select.dart';
import 'package:smart_home/air_conditioner_details/widgets/operation_mode_select.dart';
import 'package:smart_home/air_conditioner_details/widgets/set_temperature_button_group.dart';
import 'package:smart_home/air_conditioner_details/widgets/temperature_details_gauge.dart';
import 'package:smart_home/air_conditioner_edit/view/air_conditioner_edit_page.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/widgets/error_view.dart';

class AirConditionerDetailsPage extends StatelessWidget {
  const AirConditionerDetailsPage({
    super.key,
    required this.deviceId,
  });

  final String deviceId;

  static MaterialPageRoute<void> route({
    required AirConditionerRepository airConditionerRepository,
    required AirConditionerBloc bloc,
    required String deviceId,
  }) {
    return MaterialPageRoute(
      builder: (context) => RepositoryProvider.value(
        value: airConditionerRepository,
        child: BlocProvider.value(
          value: bloc,
          child: AirConditionerDetailsPage(
            deviceId: deviceId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AirConditionerDetailsView(
      deviceId: deviceId,
    );
  }
}

class AirConditionerDetailsView extends StatelessWidget {
  const AirConditionerDetailsView({
    super.key,
    required this.deviceId,
  });

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AirConditionerBloc, AirConditionerState>(
      builder: (context, state) {
        final airConditionerIndex =
            state.devices.indexWhere((d) => d.id == deviceId);
        if (airConditionerIndex == -1) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.room.name,
              ),
            ),
            body: ErrorView(
              message: 'Cannot find AC',
              retryCallback: () => Navigator.of(context).pop(),
            ),
          );
        }
        final airConditioner = state.devices[airConditionerIndex];
        final setTemperature = airConditioner.properties.setTemperature;
        final capabilities = airConditioner.capabilities;

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    AirConditionerEditPage.route(
                      airConditioner,
                      context.read<AirConditionerRepository>(),
                    ),
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
            title: Text(
              state.room.name,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.thermostat_sharp,
                            size: 30,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                airConditioner.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).control,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ]
                            .map(
                              (widget) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: widget,
                              ),
                            )
                            .toList(),
                      ),
                      const Divider(),
                      TemperatureDetailsGauge(airConditioner: airConditioner),
                      const Divider(),
                      SetTemperatureButtonGroup(
                        capabilities: capabilities,
                        temperature: setTemperature,
                        onTemperatureChanaged: (temperature) =>
                            context.read<AirConditionerBloc>().add(
                                  AirConditionerStatusChangedEvent(
                                    deviceId: airConditioner.id,
                                    properties: AirConditionerProperties(
                                        setTemperature: temperature),
                                  ),
                                ),
                      ),
                      const Divider(),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OperationModeSelect(
                              capabilities: capabilities,
                              operationMode:
                                  airConditioner.properties.operationMode,
                              onOperationModeChanged: (operationMode) =>
                                  context.read<AirConditionerBloc>().add(
                                        AirConditionerStatusChangedEvent(
                                          deviceId: airConditioner.id,
                                          properties: AirConditionerProperties(
                                            operationMode: operationMode,
                                          ),
                                        ),
                                      ),
                            ),
                            const VerticalDivider(),
                            FanSpeedSelect(
                              capabilities: capabilities,
                              fanSpeed: airConditioner.properties.fanSpeed,
                              onFanSpeedChanged: (fanSpeed) =>
                                  context.read<AirConditionerBloc>().add(
                                        AirConditionerStatusChangedEvent(
                                          deviceId: airConditioner.id,
                                          properties: AirConditionerProperties(
                                            fanSpeed: fanSpeed,
                                          ),
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ]
                        .map(
                          (widget) => Padding(
                            padding: const EdgeInsets.all(4),
                            child: widget,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
