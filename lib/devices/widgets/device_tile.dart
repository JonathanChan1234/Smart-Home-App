import 'package:flutter/material.dart';
import 'package:smart_home/lighting/view/lighting_page.dart';
import 'package:smart_home/rooms/models/room.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    super.key,
    required this.name,
    required this.showMore,
    required this.icon,
    required this.room,
    this.statusText = '',
    this.isError = false,
  });

  final String name;
  final bool showMore;
  final IconData icon;
  final String statusText;
  final bool isError;
  final Room room;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: 100,
        width: 160,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Icon(icon, size: 32),
                      const Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            style: textTheme.labelSmall,
                          ),
                          Text(statusText, style: textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    if (showMore)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(LightingPage.route(room));
                        },
                        icon: const Icon(Icons.more_horiz, size: 24),
                      ),
                    const Spacer(),
                    if (isError)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.error,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
