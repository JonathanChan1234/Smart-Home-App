import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_api/home_api.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:shades_api/shades_api.dart';
import 'package:shades_repository/shades_repository.dart' hide ShadeStatus;
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/shades/bloc/shade_bloc.dart';
import 'package:smart_home/shades/widgets/shade_overview.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home/widgets/initial_view.dart';
import 'package:smart_home/widgets/loading_view.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class ShadePage extends StatelessWidget {
  const ShadePage({
    super.key,
  });

  static Route<void> route({
    required SmartHome home,
    required Room room,
  }) {
    return MaterialPageRoute(
      builder: (_) => RepositoryProvider(
        create: (context) => ShadesRepository(
          authRepository: context.read<AuthRepository>(),
          shadesApi: ShadesApi(
            smartHomeApiClient: context.read<SmartHomeApiClient>(),
          ),
          mqttSmartHomeClient: context.read<MqttSmartHomeClient>(),
        ),
        child: BlocProvider(
          create: (context) => ShadeBloc(
            shadesRepository: context.read<ShadesRepository>(),
            home: home,
            room: room,
          )
            ..add(const ShadeStatusSubscriptionRequestedEvent())
            ..add(const ShadeListInitEvent()),
          child: const ShadePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ShadeView();
  }
}

class ShadeView extends StatelessWidget {
  const ShadeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShadeBloc, ShadeState>(
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('${state.room.name} - ${localizations.shades}'),
          ),
          body: Builder(
            builder: (context) {
              switch (state.status) {
                case ShadeStatus.initial:
                  return InitialView(
                    title: localizations.initializing,
                  );
                case ShadeStatus.loading:
                  return LoadingView(message: localizations.loading);
                case ShadeStatus.success:
                  return ShadeOverview(shades: state.shades);
                case ShadeStatus.failure:
                  return ErrorView(
                    message: state.requestError,
                  );
              }
            },
          ),
        );
      },
    );
  }
}
