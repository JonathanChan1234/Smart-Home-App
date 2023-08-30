import 'package:devices_api/devices_api.dart';
import 'package:flutter/material.dart';
import 'package:home_api/home_api.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/devices/widgets/devices_tile.dart';
import 'package:smart_home/l10n/l10n.dart';
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
    final localizations = AppLocalizations.of(context);

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
              localizations.noDeviceFound,
              style: textTheme.bodyLarge!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      children: devices.map((device) {
        switch (device.mainCategory.toDeviceMainCategory()) {
          case DeviceMainCategory.light:
            return DevicesTile(
              name: localizations.lights,
              icon: Icons.lightbulb_rounded,
              color: Colors.yellow,
              statusText: localizations.devices(device.count),
              route: () => LightPage.route(
                home: home,
                room: room,
              ),
            );
          case DeviceMainCategory.shade:
            return DevicesTile(
              name: localizations.shades,
              icon: Icons.roller_shades_rounded,
              color: Colors.blue,
              statusText: localizations.devices(device.count),
              route: () => ShadePage.route(
                home: home,
                room: room,
              ),
            );
          case DeviceMainCategory.unknown:
            return DevicesTile(
              name: localizations.unknown,
              icon: Icons.question_mark,
              color: Colors.red,
              statusText: localizations.devices(device.count),
              route: () => LightPage.route(
                home: home,
                room: room,
              ),
            );
        }
      }).toList(),
    );
  }
}
