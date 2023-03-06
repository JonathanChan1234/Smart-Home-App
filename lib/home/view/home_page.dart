import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/home/cubit/home_cubit.dart';
import 'package:smart_home/rooms/room.dart';
import 'package:smart_home/settings/view/setting_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTab =
        context.select((HomeCubit cubit) => cubit.state.currentTab);

    return Scaffold(
      body: IndexedStack(
        index: currentTab.index,
        children: const [
          RoomsPage(),
          Text('Scene Page'),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              value: HomeTabs.rooms,
              groupValue: currentTab,
              icon: Icons.home,
              label: 'Rooms',
            ),
            _HomeTabButton(
              value: HomeTabs.scenes,
              groupValue: currentTab,
              icon: Icons.dashboard_customize,
              label: 'Scenes',
            ),
            _HomeTabButton(
              value: HomeTabs.settings,
              groupValue: currentTab,
              icon: Icons.settings,
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.label,
  });

  final HomeTabs value;
  final HomeTabs groupValue;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = groupValue == value
        ? Theme.of(context).colorScheme.secondary
        : Colors.black;
    return TextButton.icon(
      onPressed: () => context.read<HomeCubit>().setCurrentTab(value),
      icon: Icon(icon, size: 32, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
