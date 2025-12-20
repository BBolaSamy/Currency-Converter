import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injection.dart';
import '../../../../app/utils/decimal_text_input_formatter.dart';
import '../../domain/entities/conversion.dart';
import '../bloc/converter_bloc.dart';
import '../widgets/currency_picker_sheet.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key, this.bloc});

  final ConverterBloc? bloc;

  @override
  Widget build(BuildContext context) {
    final provided = bloc;
    if (provided != null) {
      return BlocProvider.value(value: provided, child: const _ConverterView());
    }
    return BlocProvider(
      create: (_) => getIt<ConverterBloc>()..add(const ConverterStarted()),
      child: const _ConverterView(),
    );
  }
}

class _ConverterView extends StatefulWidget {
  const _ConverterView();

  @override
  State<_ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<_ConverterView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<ConverterBloc>().state.amountText,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert'),
        actions: [
          IconButton(
            tooltip: 'Refresh rate',
            onPressed: () => context.read<ConverterBloc>().add(
              const ConverterRefreshPressed(),
            ),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _CurrencySelect(
                            label: 'From',
                            codeSelector: (s) => s.from,
                            onTap: () => CurrencyPickerSheet.show(
                              context,
                              title: 'Select base currency',
                              onSelected: (code) => context
                                  .read<ConverterBloc>()
                                  .add(ConverterFromChanged(code)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        BlocBuilder<ConverterBloc, ConverterState>(
                          buildWhen: (p, n) => p.swapCount != n.swapCount,
                          builder: (context, state) {
                            return AnimatedRotation(
                              turns: state.swapCount * 0.5,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              child: IconButton.filledTonal(
                                onPressed: () => context
                                    .read<ConverterBloc>()
                                    .add(const ConverterSwapPressed()),
                                icon: const Icon(Icons.swap_horiz),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _CurrencySelect(
                            label: 'To',
                            codeSelector: (s) => s.to,
                            onTap: () => CurrencyPickerSheet.show(
                              context,
                              title: 'Select target currency',
                              onSelected: (code) => context
                                  .read<ConverterBloc>()
                                  .add(ConverterToChanged(code)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    BlocListener<ConverterBloc, ConverterState>(
                      listenWhen: (p, n) => p.amountText != n.amountText,
                      listener: (context, state) {
                        if (_controller.text != state.amountText) {
                          _controller.text = state.amountText;
                          _controller.selection = TextSelection.collapsed(
                            offset: _controller.text.length,
                          );
                        }
                      },
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          DecimalTextInputFormatter(decimalRange: 6),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: const Icon(Icons.payments_outlined),
                          errorText: context.select(
                            (ConverterBloc b) => b.state.amountErrorText,
                          ),
                          helperText:
                              context.select((ConverterBloc b) => b.state.amountErrorText) ==
                                      null
                                  ? ' '
                                  : null,
                        ),
                        controller: _controller,
                        onChanged: (v) => context.read<ConverterBloc>().add(
                          ConverterAmountChanged(v),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<ConverterBloc, ConverterState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: switch (state.status) {
                      ConverterStatus.loading => Center(
                        child: CircularProgressIndicator(color: scheme.primary),
                      ),
                      ConverterStatus.error => _ErrorState(
                        message: state.errorMessage,
                      ),
                      ConverterStatus.content => _ResultCard(
                        conversion: state.conversion!,
                      ),
                      ConverterStatus.idle => const _IdleState(),
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencySelect extends StatelessWidget {
  const _CurrencySelect({
    required this.label,
    required this.onTap,
    required this.codeSelector,
  });

  final String label;
  final VoidCallback onTap;
  final String Function(ConverterState s) codeSelector;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConverterBloc, ConverterState>(
      buildWhen: (p, n) => codeSelector(p) != codeSelector(n),
      builder: (context, state) {
        final code = codeSelector(state);
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(code, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                const Icon(Icons.expand_more),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.conversion});
  final Conversion conversion;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.########');
    final dateFmt = DateFormat('MMM d, HH:mm');
    final key = ValueKey(
      '${conversion.quote.from}_${conversion.quote.to}_${conversion.quote.fetchedAtUtc.toIso8601String()}',
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Card(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${fmt.format(conversion.amount)} ${conversion.quote.from} =',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${fmt.format(conversion.convertedAmount)} ${conversion.quote.to}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Rate: 1 ${conversion.quote.from} = ${fmt.format(conversion.quote.rate)} ${conversion.quote.to}',
              ),
              const SizedBox(height: 4),
              Text(
                'Last updated: ${dateFmt.format(conversion.quote.fetchedAtUtc.toLocal())}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdleState extends StatelessWidget {
  const _IdleState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Enter an amount to convert.'),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message ?? 'Failed to convert.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.read<ConverterBloc>().add(
                const ConverterRefreshPressed(),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
