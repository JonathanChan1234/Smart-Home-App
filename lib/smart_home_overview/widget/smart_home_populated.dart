import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';

class SmartHomePopulated extends StatelessWidget {
  const SmartHomePopulated({
    super.key,
    required this.homes,
  });

  final List<SmartHome> homes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (homes.isEmpty) {
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
      itemCount: homes.length,
      itemBuilder: (context, index) {
        final home = homes[index];
        return _SmartHomeCard(
          home: home,
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
        context.read<HomeBloc>().add(HomeSelectedEvent(home: home));
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
