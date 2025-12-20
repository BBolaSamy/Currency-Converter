import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/network/connectivity_cubit.dart';
import '../../core/network/connectivity_status.dart';
import '../widgets/offline_banner.dart';
import '../../features/converter/presentation/pages/converter_page.dart';
import '../../features/currencies/presentation/pages/currencies_page.dart';
import '../../features/historical/presentation/pages/historical_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [CurrenciesPage(), ConverterPage(), HistoricalPage()];

    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
            buildWhen: (p, n) => p != n,
            builder: (context, status) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: status == ConnectivityStatus.offline
                    ? const OfflineBanner()
                    : const SizedBox.shrink(),
              );
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: pages[_index],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Currencies',
          ),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Convert'),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Historical',
          ),
        ],
      ),
    );
  }
}
