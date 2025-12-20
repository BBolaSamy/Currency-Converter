import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:currency_converter/features/currencies/presentation/bloc/currencies_bloc.dart';
import 'package:currency_converter/features/currencies/presentation/pages/currencies_page.dart';

import '../../../helpers/pump_app.dart';

class _MockCurrenciesBloc extends MockBloc<CurrenciesEvent, CurrenciesState>
    implements CurrenciesBloc {}

void main() {
  testWidgets('CurrenciesPage shows search field', (tester) async {
    final bloc = _MockCurrenciesBloc();
    when(
      () => bloc.state,
    ).thenReturn(const CurrenciesState(status: CurrenciesStatus.loading));
    whenListen(
      bloc,
      Stream.value(const CurrenciesState(status: CurrenciesStatus.loading)),
    );

    await pumpMaterialApp(tester, CurrenciesPage(bloc: bloc));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Currencies'), findsOneWidget);
  });
}
