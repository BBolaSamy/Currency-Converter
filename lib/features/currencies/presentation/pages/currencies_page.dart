import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/di/injection.dart';
import '../../../../app/utils/currency_flag_country.dart';
import '../../../../app/widgets/flag_avatar.dart';
import '../bloc/currencies_bloc.dart';
import '../../domain/entities/currency.dart';

class CurrenciesPage extends StatelessWidget {
  const CurrenciesPage({super.key, this.bloc});

  final CurrenciesBloc? bloc;

  @override
  Widget build(BuildContext context) {
    final provided = bloc;
    if (provided != null) {
      return BlocProvider.value(
        value: provided,
        child: const _CurrenciesView(),
      );
    }
    return BlocProvider(
      create: (_) => getIt<CurrenciesBloc>()..add(const CurrenciesStarted()),
      child: const _CurrenciesView(),
    );
  }
}

class _CurrenciesView extends StatelessWidget {
  const _CurrenciesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currencies'),
        actions: [
          BlocBuilder<CurrenciesBloc, CurrenciesState>(
            buildWhen: (p, n) => p.showFavoritesOnly != n.showFavoritesOnly,
            builder: (context, state) {
              return IconButton(
                tooltip: state.showFavoritesOnly
                    ? 'Show all'
                    : 'Show favorites',
                onPressed: () => context.read<CurrenciesBloc>().add(
                  CurrenciesFavoritesFilterChanged(!state.showFavoritesOnly),
                ),
                icon: Icon(
                  state.showFavoritesOnly ? Icons.star : Icons.star_border,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by code or name',
              ),
              onChanged: (v) => context.read<CurrenciesBloc>().add(
                CurrenciesSearchChanged(v),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: BlocBuilder<CurrenciesBloc, CurrenciesState>(
                buildWhen: (p, n) => p.showFavoritesOnly != n.showFavoritesOnly,
                builder: (context, state) {
                  return FilterChip(
                    selected: state.showFavoritesOnly,
                    label: const Text('Favorites'),
                    avatar: Icon(
                      state.showFavoritesOnly ? Icons.star : Icons.star_border,
                      size: 18,
                    ),
                    onSelected: (selected) => context
                        .read<CurrenciesBloc>()
                        .add(CurrenciesFavoritesFilterChanged(selected)),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CurrenciesBloc, CurrenciesState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: switch (state.status) {
                    CurrenciesStatus.loading => const _CurrenciesSkeleton(),
                    CurrenciesStatus.error => _ErrorState(
                      message: state.errorMessage,
                    ),
                    _ => AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: _CurrenciesList(items: state.filteredItems),
                      ),
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrenciesList extends StatelessWidget {
  const _CurrenciesList({required this.items});
  final List<CurrencyItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No currencies found.'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final item = items[i];
        final code = item.currency.code;
        final name = item.currency.name;
        final isFav = item.isFavorite;

        return Card(
          child: ListTile(
            leading: FlagAvatar(
              countryCode: CurrencyFlagCountry.fromCurrencyCode(code),
              fallbackText: code.substring(0, 1),
            ),
            title: Text(
              code,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(name),
            trailing: IconButton(
              tooltip: isFav ? 'Unfavorite' : 'Favorite',
              onPressed: () => context.read<CurrenciesBloc>().add(
                CurrenciesFavoriteToggled(
                  currencyCode: code,
                  isFavorite: !isFav,
                ),
              ),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  key: ValueKey(isFav),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CurrenciesSkeleton extends StatelessWidget {
  const _CurrenciesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withValues(alpha: 0.08),
      highlightColor: Colors.black.withValues(alpha: 0.02),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: 10,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          return const Card(
            child: ListTile(
              title: _SkeletonBox(width: 80, height: 14),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: _SkeletonBox(width: 220, height: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
            Text(message ?? 'Failed to load currencies.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.read<CurrenciesBloc>().add(
                const CurrenciesRetryPressed(),
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
