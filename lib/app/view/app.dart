import 'package:auth_local_storage/auth_local_storage.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_repository/home_repository.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_repository/room_repository.dart';
import 'package:scene_action_repository/scene_action_repository.dart';
import 'package:scene_repository/scene_repository.dart';
import 'package:smart_home/auth_unknown/auth_unknown_page.dart';
import 'package:smart_home/authentication/bloc/authentication_bloc.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/home/view/home_page.dart';
import 'package:smart_home/l10n/cubit/l10n_cubit.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/login/view/login_page.dart';
import 'package:smart_home/scene_action/view/scene_action_page.dart';
import 'package:smart_home/scene_action_edit/view/scene_action_edit_page.dart';
import 'package:smart_home/theme/app_theme.dart';
import 'package:smart_home/widgets/error_view.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.authRepository,
    required this.homeRepository,
    required this.localeRepository,
    required this.mqttSmartHomeClient,
    required this.roomRepository,
    required this.sharedPreferences,
    required this.smartHomeApiClient,
    required this.sceneRepository,
    required this.sceneActionRepository,
  });

  final AuthRepository authRepository;
  final HomeRepository homeRepository;
  final RoomRepository roomRepository;
  final LocaleRepository localeRepository;
  final MqttSmartHomeClient mqttSmartHomeClient;
  final SharedPreferences sharedPreferences;
  final SmartHomeApiClient smartHomeApiClient;
  final SceneRepository sceneRepository;
  final SceneActionRepository sceneActionRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void dispose() {
    widget.authRepository.dispose();
    widget.homeRepository.dispose();
    widget.mqttSmartHomeClient.dispose();
    widget.roomRepository.dispose();
    widget.sceneRepository.dispose();
    widget.sceneActionRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SharedPreferences>.value(
          value: widget.sharedPreferences,
        ),
        RepositoryProvider<AuthRepository>.value(
          value: widget.authRepository,
        ),
        RepositoryProvider<SmartHomeApiClient>.value(
          value: widget.smartHomeApiClient,
        ),
        RepositoryProvider<MqttSmartHomeClient>.value(
          value: widget.mqttSmartHomeClient,
        ),
        RepositoryProvider<HomeRepository>.value(
          value: widget.homeRepository,
        ),
        RepositoryProvider<RoomRepository>.value(
          value: widget.roomRepository,
        ),
        RepositoryProvider<SceneRepository>.value(
          value: widget.sceneRepository,
        ),
        RepositoryProvider<SceneActionRepository>.value(
          value: widget.sceneActionRepository,
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authRepository: widget.authRepository,
            ),
          ),
          BlocProvider(create: (_) => HomeBloc()),
          BlocProvider(
            create: (_) => L10nCubit(
              localeRepository: widget.localeRepository,
            ),
          )
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<L10nCubit>().state;
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.authenticated:
              return const HomePage();
            case AuthenticationStatus.unauthenticated:
              return const LoginPage();
            case AuthenticationStatus.unknown:
              return const AuthUnknownPage();
          }
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SceneActionPage.routeName:
            final routeArgs = settings.arguments;
            if (routeArgs == null) {
              return MaterialPageRoute(
                builder: (_) => const ErrorView(
                  message: 'Scene action page contains null arguments',
                ),
              );
            }
            final args = routeArgs as SceneActionPageArgument;
            return SceneActionPage.route(
              home: args.home,
              scene: args.scene,
            );
          case SceneActionEditPage.routeName:
            final routeArgs = settings.arguments;
            if (routeArgs == null) {
              return MaterialPageRoute(
                builder: (_) => const ErrorView(
                  message: 'Scene action page contains null arguments',
                ),
              );
            }
            final args = routeArgs as SceneActionEditArgument;
            return SceneActionEditPage.route(
              scene: args.scene,
              device: args.device,
              action: args.action,
            );
          default:
            return SplashPage.route();
        }
      },
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
