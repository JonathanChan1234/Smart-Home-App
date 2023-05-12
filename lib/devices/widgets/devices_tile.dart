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
    final minLength = MediaQuery.of(context).size.width / 4 - 40;
    final maxLength = MediaQuery.of(context).size.width / 2 - 10;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxLength,
          maxWidth: maxLength,
          minHeight: minLength,
          minWidth: minLength,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(route()),
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Icon(
                                icon,
                                size: constraints.maxWidth / 2,
                                color: color,
                              ),
                              Text(
                                name,
                                style: textTheme.labelSmall!
                                    .copyWith(fontSize: 20),
                              ),
                              Text(statusText, style: textTheme.labelSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
