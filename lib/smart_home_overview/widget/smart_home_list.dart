import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/smart_home_add/view/smart_home_add_page.dart';
import 'package:smart_home/smart_home_overview/bloc/smart_home_overview_bloc.dart';
import 'package:smart_home/smart_home_overview/widget/smart_home_error.dart';
import 'package:smart_home/smart_home_overview/widget/smart_home_initial.dart';
import 'package:smart_home/smart_home_overview/widget/smart_home_loading.dart';
import 'package:smart_home/smart_home_overview/widget/smart_home_populated.dart';

class SmartHomeList extends StatelessWidget {
  const SmartHomeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartHomeOverviewBloc, SmartHomeOverviewState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).yourHome),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context
                    .read<SmartHomeOverviewBloc>()
                    .add(const SmartHomeOverviewFetchEvent()),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () =>
                    Navigator.of(context).push(SmartHomeAddPage.route()),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              switch (state.status) {
                case SmartHomeOverviewStatus.initial:
                  return const SmartHomeInitial();
                case SmartHomeOverviewStatus.success:
                  return SmartHomePopulated(homes: state.homes);
                case SmartHomeOverviewStatus.failure:
                  return SmartHomeError(
                    message: state.requestError,
                  );
                case SmartHomeOverviewStatus.loading:
                  return const SmartHomeLoading();
              }
            },
          ),
        );
      },
    );
  }
}
