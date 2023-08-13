import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_repository/home_repository.dart';
import 'package:smart_home/home_delete/bloc/home_delete_bloc.dart';
import 'package:smart_home/home_delete/widgets/home_delete_overview.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';

class HomeDeletePage extends StatelessWidget {
  const HomeDeletePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => HomeDeleteBloc(
          homeRepository: context.read<HomeRepository>(),
        )
          ..add(const HomeDeleteHomeSubscriptionRequestedEvent())
          ..add(const HomeDeleteHomeRefreshEvent()),
        child: const HomeDeletePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeDeleteBloc, HomeDeleteState>(
      listenWhen: (previous, current) =>
          previous.requestStatus != current.requestStatus,
      listener: (context, state) {
        final localizations = AppLocalizations.of(context);
        if (state.requestStatus == HomeDeleteRequestStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.deleteHomeSuccessMessage)),
          );
          return;
        }
        if (state.requestStatus == HomeDeleteRequestStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '''${localizations.deleteHomeFailureMessage} ${state.requestError}''',
              ),
            ),
          );
        }
      },
      child: const HomeDeleteView(),
    );
  }
}

class HomeDeleteView extends StatelessWidget {
  const HomeDeleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDeleteBloc, HomeDeleteState>(
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(localizations.removeHome)),
          body: Builder(
            builder: (_) {
              switch (state.refreshStatus) {
                case HomeDeleteRefreshStatus.initial:
                  return const InitialView(title: 'Initializing');
                case HomeDeleteRefreshStatus.loading:
                  return const LoadingView();
                case HomeDeleteRefreshStatus.success:
                  return HomeDeleteOverview(homes: state.homes);
                case HomeDeleteRefreshStatus.failure:
                  return ErrorView(message: state.requestError);
              }
            },
          ),
        );
      },
    );
  }
}
