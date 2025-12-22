import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import '../../../../app/di/injection.dart';
import '../../presentation/bloc/historical_bloc.dart';
import '../../../converter/presentation/widgets/currency_picker_sheet.dart';
import '../../../rates/domain/entities/rate_point.dart';

class HistoricalPage extends StatelessWidget {
  const HistoricalPage({super.key, this.bloc});

  final HistoricalBloc? bloc;

  @override
  Widget build(BuildContext context) {
    final provided = bloc;
    if (provided != null) {
      return BlocProvider.value(
        value: provided,
        child: const _HistoricalView(),
      );
    }
    return BlocProvider(
      create: (_) => getIt<HistoricalBloc>()..add(const HistoricalStarted()),
      child: const _HistoricalView(),
    );
  }
}

class _HistoricalView extends StatelessWidget {
  const _HistoricalView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical (7 days)'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<HistoricalBloc>().add(
              const HistoricalRefreshPressed(),
            ),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<HistoricalBloc, HistoricalState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HistoricalBloc>().add(
                const HistoricalRefreshPressed(),
              );
              await Future<void>.delayed(const Duration(milliseconds: 250));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _CurrencySelect(
                            label: 'From',
                            codeSelector: (s) => s.from,
                            onTap: () => CurrencyPickerSheet.show(
                              context,
                              title: 'Select base currency',
                              onSelected: (code) => context
                                  .read<HistoricalBloc>()
                                  .add(HistoricalFromChanged(code)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filledTonal(
                          onPressed: () => context.read<HistoricalBloc>().add(
                            const HistoricalSwapPressed(),
                          ),
                          icon: const Icon(Icons.swap_horiz),
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
                                  .read<HistoricalBloc>()
                                  .add(HistoricalToChanged(code)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: switch (state.status) {
                    HistoricalStatus.loading => const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    HistoricalStatus.error => _ErrorState(
                      message: state.errorMessage,
                    ),
                    HistoricalStatus.content => Column(
                      key: const ValueKey('content'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Summary(points: state.points),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 280,
                          child: _Chart(points: state.points),
                        ),
                      ],
                    ),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.points});

  final List<RatePoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    final rates = points.map((e) => e.rate).toList(growable: false);
    final min = rates.reduce((a, b) => a < b ? a : b);
    final max = rates.reduce((a, b) => a > b ? a : b);
    final avg = rates.reduce((a, b) => a + b) / rates.length;

    String fmt(double v) {
      final s = v.toStringAsFixed(6);
      return s
          .replaceFirst(RegExp(r'0+$'), '')
          .replaceFirst(RegExp(r'\.$'), '');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Metric(label: 'Low', value: fmt(min)),
            _Metric(label: 'Avg', value: fmt(avg)),
            _Metric(label: 'High', value: fmt(max)),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
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
  final String Function(HistoricalState s) codeSelector;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoricalBloc, HistoricalState>(
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

class _Chart extends StatelessWidget {
  const _Chart({required this.points});

  final List<RatePoint> points;

  double _niceStep(double raw) {
    if (raw <= 0) return 1;
    final exp = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    final f = raw / exp;
    if (f <= 1) return 1 * exp;
    if (f <= 2) return 2 * exp;
    if (f <= 5) return 5 * exp;
    return 10 * exp;
  }

  int _decimalsForStep(double step) {
    if (step <= 0) return 2;
    final d = (-math.log(step) / math.ln10).ceil();
    return d.clamp(0, 6);
  }

  String _fmt(double v, {required int decimals}) {
    final s = v.toStringAsFixed(decimals);
    return s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(child: Text('No cached history available.'));
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].rate));
    }

    final rawMin = points.map((e) => e.rate).reduce((a, b) => a < b ? a : b);
    final rawMax = points.map((e) => e.rate).reduce((a, b) => a > b ? a : b);
    final range = (rawMax - rawMin).abs();

    // Choose ~4-5 ticks with "nice" rounded numbers, so the axis looks like
    // ~1.23–1.33 instead of 1.236–1.324.
    final step = _niceStep(range == 0 ? 0.01 : (range / 4));
    final pad = step; // one tick of padding on each side
    final minY = ((rawMin - pad) / step).floorToDouble() * step;
    final maxY = ((rawMax + pad) / step).ceilToDouble() * step;
    final decimals = _decimalsForStep(step);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: step,
                  reservedSize: 44,
                  getTitlesWidget: (value, meta) => Text(
                    _fmt(value, decimals: decimals),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final i = value.round();
                    if (i < 0 || i >= points.length) {
                      return const SizedBox.shrink();
                    }
                    final d = points[i].date;
                    // show MM-DD
                    final label = d.length >= 10 ? d.substring(5) : d;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        ),
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
            Text(message ?? 'Failed to load historical rates.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.read<HistoricalBloc>().add(
                const HistoricalRefreshPressed(),
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
