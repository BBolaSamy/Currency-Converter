import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/network/connectivity_cubit.dart';
import 'di/injection.dart';
import 'router/app_shell.dart';
import 'theme/app_theme.dart';

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ConnectivityCubit>()),
      ],
      child: MaterialApp(
        title: 'Currency Converter',
        theme: AppTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}


