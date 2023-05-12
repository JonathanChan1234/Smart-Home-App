import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';

class SmartHomeConnectFailure extends StatelessWidget {
  const SmartHomeConnectFailure({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.error,
              size: 100,
            ),
          ),
          Text(
            error,
            style: textTheme.headlineSmall,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () =>
                context.read<HomeBloc>().add(const HomeDeselectedEvent()),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
