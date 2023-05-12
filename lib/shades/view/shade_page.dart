import 'package:flutter/material.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home/shades/view/shade_slider_thumb.dart';

class ShadePage extends StatelessWidget {
  const ShadePage({super.key, required this.room});

  final Room room;

  static Route<void> route(Room room) {
    return MaterialPageRoute(builder: (_) => ShadePage(room: room));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final shades = [
      'Shade 1',
      'Shade 2',
      'Shade 3',
      'Shade 4',
      'Shade 5',
      'Shade 6',
    ];
    return Scaffold(
      appBar: AppBar(title: Text('${room.name} - Shades')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 9, 12, 19),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'CONTROLS',
                  style: textTheme.titleSmall!.copyWith(
                    color: const Color.fromARGB(255, 222, 223, 225),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListView.builder(
                  itemCount: shades.length,
                  itemBuilder: (context, index) => _ShadeControl(
                    name: shades[index],
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

class _ShadeControl extends StatefulWidget {
  const _ShadeControl({
    required this.name,
  });

  final String name;

  @override
  State<_ShadeControl> createState() => _ShadeControlState();
}

class _ShadeControlState extends State<_ShadeControl> {
  double _level = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 34, 37, 44),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 119, 120, 124),
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      activeTrackColor:
                          const Color.fromARGB(255, 223, 224, 227),
                      inactiveTrackColor: const Color.fromARGB(255, 70, 73, 80),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 2),
                      thumbShape: ShadeSliderThumb(
                        height: 30,
                        width: 50,
                        sliderValue: _level,
                      ),
                    ),
                    child: SizedBox(
                      width: width * 0.85,
                      child: Slider(
                        max: 100,
                        divisions: 100,
                        value: _level,
                        onChanged: (value) {
                          setState(() {
                            _level = value;
                          });
                        },
                      ),
                    ),
                  ),
                  // ignore: lines_longer_than_80_chars
                  Icon(
                    _level == 0
                        ? Icons.roller_shades_closed
                        : Icons.roller_shades_outlined,
                    color: const Color.fromARGB(255, 222, 223, 255),
                    size: 30,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
