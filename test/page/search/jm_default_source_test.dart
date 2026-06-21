import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/page/search/cubit/search_cubit.dart';

void main() {
  test('initial search state defaults to jm', () {
    final state = SearchStates.initial();

    expect(state.from, 'jm');
    expect(state.aggregateSources, containsPair('jm', true));
    expect(state.aggregateSources.containsKey('bika'), isFalse);
  });
}
