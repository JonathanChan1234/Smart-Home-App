import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_repository/home_repository.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/settings/view/setting_page.dart';
import 'package:smart_home/smart_home_overview/bloc/smart_home_overview_bloc.dart';
import 'package:smart_home/smart_home_overview/widget/smart_home_list.dart';

class SmartHomeOverview extends StatelessWidget {
  const SmartHomeOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmartHomeOverviewBloc(
        homeRepository: context.read<HomeRepository>(),
      )
        ..add(const SmartHomeOverviewSubscriptionRequestEvent())
        ..add(const SmartHomeOverviewFetchEvent()),
      child: const SmartHomeOverviewTabView(),
    );
  }
}

class SmartHomeOverviewTabView extends StatelessWidget {
  const SmartHomeOverviewTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTab =
        context.select((SmartHomeOverviewBloc bloc) => bloc.state.tab);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: currentTab.index,
        children: const [
          SmartHomeList(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              value: SmartHomeTab.home,
              groupValue: currentTab,
              icon: Icons.home,
              label: localization.home,
            ),
            _HomeTabButton(
              value: SmartHomeTab.settings,
              groupValue: currentTab,
              icon: Icons.settings,
              label: localization.settings,
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

  final SmartHomeTab value;
  final SmartHomeTab groupValue;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = groupValue == value
        ? Theme.of(context).colorScheme.secondary
        : Colors.black;
    return TextButton.icon(
      onPressed: () => context
          .read<SmartHomeOverviewBloc>()
          .add(SmartHomeOverviewTabChangedEvent(tab: value)),
      icon: Icon(icon, size: 32, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
