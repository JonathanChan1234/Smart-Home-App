import 'package:flutter/material.dart';
import 'package:smart_home/rooms/view/rooms_page.dart';
import 'package:smart_home/smart_home/models/smart_home.dart';

class SmartHomeList extends StatelessWidget {
  const SmartHomeList({
    super.key,
    required this.home,
  });

  final List<SmartHome> home;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (home.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 96),
            Text(
              'You do have any home added yet',
              style: textTheme.headlineSmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: home.length,
      itemBuilder: (context, index) {
        final h = home[index];
        return _SmartHomeCard(
          home: h,
        );
      },
    );
  }
}

class _SmartHomeCard extends StatelessWidget {
  const _SmartHomeCard({required this.home});

  final SmartHome home;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(RoomsPage.route(home));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'images/home_banner.png',
              height: 128,
              width: 96,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    home.name,
                    style: textStyle.titleLarge,
                  ),
                  Text(
                    home.description,
                    style: textStyle.titleSmall,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
