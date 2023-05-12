import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/smart_home_connect/view/smart_home_connect.dart';
import 'package:smart_home/smart_home_overview/view/smart_home_overview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.selectedHome != current.selectedHome,
      builder: (ctx, state) {
        final home = state.selectedHome;
        if (home == null) return const SmartHomeOverview();
        return SmartHomeConnect(home: home);
      },
    );
  }
}
