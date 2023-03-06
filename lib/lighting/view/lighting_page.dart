import 'package:flutter/material.dart';
import 'package:smart_home/rooms/models/room.dart';

class LightingPage extends StatelessWidget {
  const LightingPage({super.key, required this.room});

  final Room room;

  static Route<void> route(Room room) {
    return MaterialPageRoute(builder: (_) => LightingPage(room: room));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final lights = [
      'Light 1',
      'Light 2',
      'Light 3',
      'Light 4',
      'Light 5',
      'Light 6',
    ];

    return Scaffold(
      appBar: AppBar(title: Text('${room.name} - Lighting')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text('CONTROLS', style: textTheme.titleSmall),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: lights.length,
                itemBuilder: (context, index) => _LightControl(
                  name: lights[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _LightControl extends StatefulWidget {
  const _LightControl({
    required this.name,
  });

  final String name;

  @override
  State<_LightControl> createState() => _LightControlState();
}

class _LightControlState extends State<_LightControl> {
  double level = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.name),
            subtitle: Text('${level.round()}%'),
            trailing: Switch(
              activeColor: Colors.yellow,
              value: level > 0,
              onChanged: (value) => setState(() {
                level = level > 0 ? 0 : 100;
              }),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 30,
              trackShape: const RoundedRectSliderTrackShape(),
              activeTrackColor: Colors.yellow,
              inactiveTrackColor: Colors.grey.shade300,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 15,
                pressedElevation: 8,
              ),
              thumbColor: Colors.white,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
            ),
            child: Slider(
              max: 100,
              value: level,
              onChanged: (value) {
                setState(() {
                  level = value;
                });
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
