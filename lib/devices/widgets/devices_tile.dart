import 'package:flutter/material.dart';

class DevicesTile extends StatelessWidget {
  const DevicesTile({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    this.statusText = '',
    required this.route,
    this.isError = false,
  });

  final String name;
  final IconData icon;
  final MaterialColor color;
  final String statusText;
  final bool isError;
  final Route<void> Function() route;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 180,
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(route()),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    icon,
                    size: 100,
                    color: color,
                  ),
                  Column(
                    children: [
                      Text(
                        name,
                        style: textTheme.labelSmall!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        statusText,
                        style: textTheme.labelSmall!.copyWith(fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
