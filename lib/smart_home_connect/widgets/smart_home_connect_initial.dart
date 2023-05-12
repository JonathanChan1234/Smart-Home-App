import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';

class SmartHomeConnectInitial extends StatelessWidget {
  const SmartHomeConnectInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Initializing your smart home connection...',
            style: textTheme.headlineSmall,
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<HomeBloc>().add(const HomeDeselectedEvent()),
            child: const Text(
              'Back',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
