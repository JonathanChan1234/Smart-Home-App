import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_api/home_api.dart';
import 'package:smart_home/home/bloc/home_bloc.dart';

import '../../helpers/hydrated_bloc.dart';

void main() {
  initHydratedStorage();
  const home =
      SmartHome(id: 'test', name: 'test', description: 'test', ownerId: 'test');
  late HomeBloc homeBloc;

  setUp(() {
    homeBloc = HomeBloc();
  });

  group('HomeState', () {
    test('initial state is correct', () {
      final bloc = HomeBloc();
      expect(bloc.state, const HomeState());
    });

    test('toJson/fromJson', () {
      final bloc = HomeBloc();
      expect(bloc.fromJson(bloc.toJson(bloc.state)!), bloc.state);
    });

    blocTest<HomeBloc, HomeState>(
      'emit [selectedHome] when HomeSelectedEvent',
      build: () => homeBloc,
      act: (bloc) => bloc.add(const HomeSelectedEvent(home: home)),
      expect: () => [
        isA<HomeState>()
            .having((h) => h.selectedHome?.name, 'name', home.name)
            .having((h) => h.selectedHome?.id, 'id', home.id)
            .having(
              (h) => h.selectedHome?.description,
              'description',
              home.description,
            )
            .having(
              (h) => h.selectedHome?.ownerId,
              'ownerId',
              home.ownerId,
            )
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'emit [null] when HomeDeselectedEvent',
      build: () => homeBloc,
      act: (bloc) => bloc.add(const HomeDeselectedEvent()),
      expect: () => [
        isA<HomeState>().having((h) => h.selectedHome, 'selectedHome', null)
      ],
    );
  });
}
