import 'package:devices_api/devices_api.dart';
import 'package:flutter/material.dart';
import 'package:home_api/home_api.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/devices/widgets/devices_tile.dart';
import 'package:smart_home/lights/view/light_page.dart';
import 'package:smart_home/shades/view/shade_page.dart';

class DevicesOverview extends StatelessWidget {
  const DevicesOverview({
    super.key,
    required this.devices,
    required this.home,
    required this.room,
  });

  final List<DeviceCount> devices;
  final SmartHome home;
  final Room room;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.question_mark,
                color: Colors.red,
                size: 50,
              ),
            ),
            Text(
              'No device found',
              style: textTheme.bodyLarge!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: devices.map((device) {
                    final params = DeviceParams.fromDeviceType(
                      type: device.mainCategory.toDeviceMainCategory(),
                      home: home,
                      room: room,
                    );
                    return DevicesTile(
                      name: params.name,
                      icon: params.icon,
                      statusText: '${device.count} devices',
                      color: params.color,
                      route: params.route,
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DeviceParams {
  const DeviceParams({
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
  });

  factory DeviceParams.fromDeviceType({
    required DeviceMainCategory type,
    required SmartHome home,
    required Room room,
  }) {
    switch (type) {
      case DeviceMainCategory.light:
        return DeviceParams(
          name: 'Lights',
          icon: Icons.lightbulb_rounded,
          color: Colors.yellow,
          route: () => LightPage.route(home: home, room: room),
        );
      case DeviceMainCategory.shade:
        return DeviceParams(
          name: 'Shades',
          color: Colors.lightBlue,
          icon: Icons.roller_shades_rounded,
          route: () => ShadePage.route(home: home, room: room),
        );
      case DeviceMainCategory.unknown:
        return DeviceParams(
          name: 'Unknown',
          icon: Icons.question_mark,
          color: Colors.red,
          route: () => LightPage.route(home: home, room: room),
        );
    }
  }

  final String name;
  final IconData icon;
  final MaterialColor color;
  final Route<void> Function() route;
}
