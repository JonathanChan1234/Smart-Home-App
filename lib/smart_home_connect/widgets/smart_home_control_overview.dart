import 'package:flutter/material.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/rooms/room.dart';
import 'package:smart_home/scenes/view/scene_page.dart';

class SmartHomeControlOverview extends StatefulWidget {
  const SmartHomeControlOverview({
    super.key,
    required this.home,
  });

  final SmartHome home;

  @override
  State<SmartHomeControlOverview> createState() =>
      _SmartHomeControlOverviewState();
}

enum SmartHomeConnectedTab {
  rooms,
  scenes,
}

class _SmartHomeControlOverviewState extends State<SmartHomeControlOverview> {
  SmartHomeConnectedTab currentTab = SmartHomeConnectedTab.rooms;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: currentTab.index,
        children: [
          RoomsPage(home: widget.home),
          ScenePage(home: widget.home),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SmartHomeConnectedTabButton(
              value: SmartHomeConnectedTab.rooms,
              groupValue: currentTab,
              icon: Icons.house,
              label: localizations.rooms,
              onclick: () => setState(() {
                currentTab = SmartHomeConnectedTab.rooms;
              }),
            ),
            _SmartHomeConnectedTabButton(
              value: SmartHomeConnectedTab.scenes,
              groupValue: currentTab,
              icon: Icons.smart_button,
              label: localizations.scenes,
              onclick: () => setState(() {
                currentTab = SmartHomeConnectedTab.scenes;
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmartHomeConnectedTabButton extends StatelessWidget {
  const _SmartHomeConnectedTabButton({
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.label,
    required this.onclick,
  });

  final SmartHomeConnectedTab value;
  final SmartHomeConnectedTab groupValue;
  final IconData icon;
  final String label;
  final void Function() onclick;

  @override
  Widget build(BuildContext context) {
    final color = groupValue == value
        ? Theme.of(context).colorScheme.secondary
        : Colors.black;
    return TextButton.icon(
      onPressed: onclick,
      icon: Icon(icon, size: 32, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
