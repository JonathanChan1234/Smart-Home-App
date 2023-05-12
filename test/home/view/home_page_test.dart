import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_home/authentication/bloc/authentication_bloc.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';
import 'package:smart_home/home/view/home_page.dart';
import 'package:smart_home/smart_home_connect/view/smart_home_connect.dart';
import 'package:smart_home/smart_home_overview/view/smart_home_overview.dart';

import '../../helpers/hydrated_bloc.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  initHydratedStorage();

  group('HomePage', () {
    late HomeBloc homeBloc;
    late AuthenticationBloc authenticationBloc;
    late HomeRepository homeRepository;

    const user = AuthUser(name: 'test', id: 'test');
    const selectedHome = SmartHome(
      id: 'test',
      name: 'test',
      description: 'test',
      ownerId: 'test',
    );

    setUp(() {
      homeBloc = MockHomeBloc();
      authenticationBloc = MockAuthenticationBloc();
      homeRepository = MockHomeRepository();
      when(() => authenticationBloc.state)
          .thenReturn(const AuthenticationState.authenticated(user));
      when(() => homeRepository.fetchHomeList()).thenAnswer((_) async {});
      when(() => homeRepository.homes).thenAnswer(
        (_) => Stream<List<SmartHome>>.fromIterable([]),
      );
    });

    testWidgets('render SmartHomeOverview correctly for initial state',
        (widgetTester) async {
      when(() => homeBloc.state).thenReturn(const HomeState());

      await widgetTester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider<HomeRepository>.value(
            value: homeRepository,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: authenticationBloc),
              ],
              child: const HomePage(),
            ),
          ),
        ),
      );
      expect(find.byType(SmartHomeOverview), findsOneWidget);
    });

    testWidgets('render SmartHomeConnect correctly when there is home cached',
        (widgetTester) async {
      when<dynamic>(() => hydratedStorage.read('$HomeBloc')).thenReturn(
        const HomeState(
          selectedHome: selectedHome,
        ).toJson(),
      );
      // when(() => homeBloc.state)
      //     .thenReturn(const HomeState(selectedHome: selectedHome));
      await widgetTester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider<HomeRepository>.value(
            value: homeRepository,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: authenticationBloc),
              ],
              child: const HomePage(),
            ),
          ),
        ),
      );
      expect(find.byType(SmartHomeConnect), findsOneWidget);
    });

    testWidgets('render SmartHomeConnect correctly when there is home selected',
        (widgetTester) async {
      when(() => homeBloc.state)
          .thenReturn(const HomeState(selectedHome: selectedHome));
      await widgetTester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider<HomeRepository>.value(
            value: homeRepository,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: authenticationBloc),
              ],
              child: const HomePage(),
            ),
          ),
        ),
      );
      expect(find.byType(SmartHomeConnect), findsOneWidget);
    });
  });
}
