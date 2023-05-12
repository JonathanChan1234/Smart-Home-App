import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';

class SmartHomeConnectConnecting extends StatelessWidget {
  const SmartHomeConnectConnecting({super.key, required this.home});

  final SmartHome home;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          ),
          Text(
            'Connecting To ${home.name}...',
            style: textTheme.headlineSmall,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Background color
              ),
              onPressed: () =>
                  context.read<HomeBloc>().add(const HomeDeselectedEvent()),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
