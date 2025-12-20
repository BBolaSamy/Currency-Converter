import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter/features/converter/presentation/pages/converter_page.dart';

import '../../../helpers/pump_app.dart';

class _MockConverterBloc extends MockBloc<ConverterEvent, ConverterState>
    implements ConverterBloc {}

void main() {
  testWidgets('ConverterPage shows amount field and refresh action', (
    tester,
  ) async {
    final bloc = _MockConverterBloc();
    when(
      () => bloc.state,
    ).thenReturn(const ConverterState(status: ConverterStatus.idle));
    whenListen(
      bloc,
      Stream.value(const ConverterState(status: ConverterStatus.idle)),
    );

    await pumpMaterialApp(tester, ConverterPage(bloc: bloc));
    expect(find.text('Convert'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
