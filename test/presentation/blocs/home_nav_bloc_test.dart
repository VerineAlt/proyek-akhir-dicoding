
import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/home_nav/home_nav_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeNavCubit', () {
    late HomeNavCubit homeNavCubit;

    setUp(() {
      homeNavCubit = HomeNavCubit();
    });

    test('initial state should be 0', () {
      expect(homeNavCubit.state, 0);
    });

    blocTest<HomeNavCubit, int>(
      'should emit 1 when changeTab(1) is called',
      build: () => homeNavCubit,
      act: (cubit) => cubit.changeTab(1),
      expect: () => [1],
    );

    blocTest<HomeNavCubit, int>(
      'should emit 2 when changeTab(2) is called',
      build: () => homeNavCubit,
      act: (cubit) => cubit.changeTab(2),
      expect: () => [2],
    );
  });
}
