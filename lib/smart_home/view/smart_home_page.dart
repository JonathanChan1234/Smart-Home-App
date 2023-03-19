import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/smart_home/bloc/smart_home_bloc.dart';
import 'package:smart_home/smart_home/view/smart_home_error.dart';
import 'package:smart_home/smart_home/view/smart_home_initial.dart';
import 'package:smart_home/smart_home/view/smart_home_list.dart';
import 'package:smart_home/smart_home/view/smart_home_loading.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class SmartHomePage extends StatelessWidget {
  const SmartHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SmartHomeBloc(
        HomeApiClient(
          authRepository: context.read<AuthRepository>(),
          smartHomeApiClient: context.read<SmartHomeApiClient>(),
        ),
      )..add(const FetchSmartHomeEvent()),
      child: const SmartHomeView(),
    );
  }
}

class SmartHomeView extends StatelessWidget {
  const SmartHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartHomeBloc, SmartHomeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Home'),
            actions: [
              IconButton(
                onPressed: state.status == SmartHomeStatus.loading
                    ? null
                    : () {
                        context
                            .read<SmartHomeBloc>()
                            .add(const RefreshSmartHomeEvent());
                      },
                icon: const Icon(Icons.refresh),
              )
            ],
          ),
          body: getBodyWidget(state),
        );
      },
    );
  }

  Widget getBodyWidget(SmartHomeState state) {
    switch (state.status) {
      case SmartHomeStatus.initial:
        return const SmartHomeInitial();
      case SmartHomeStatus.loading:
        return const SmartHomeLoading();
      case SmartHomeStatus.success:
        return SmartHomeList(home: state.smartHome);
      case SmartHomeStatus.failure:
        return SmartHomeError(
          message: state.errorMessage,
        );
    }
  }
}
