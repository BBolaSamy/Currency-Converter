import 'package:flutter/material.dart';

import '../../../../app/di/injection.dart';
import '../../../../app/utils/currency_flag_country.dart';
import '../../../../app/widgets/flag_avatar.dart';
import '../../../currencies/domain/usecases/watch_currencies.dart';

class CurrencyPickerSheet extends StatefulWidget {
  const CurrencyPickerSheet({
    super.key,
    required this.title,
    required this.onSelected,
  });

  final String title;
  final ValueChanged<String> onSelected;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CurrencyPickerSheet(title: title, onSelected: onSelected),
    );
  }

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final watchCurrencies = getIt<WatchCurrencies>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search currency',
                ),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: watchCurrencies(),
                builder: (context, snapshot) {
                  final items = snapshot.data ?? const [];
                  final q = _q.trim().toLowerCase();
                  final filtered = q.isEmpty
                      ? items
                      : items
                            .where((e) {
                              final code = e.currency.code.toLowerCase();
                              final name = e.currency.name.toLowerCase();
                              return code.contains(q) || name.contains(q);
                            })
                            .toList(growable: false);

                  if (filtered.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No matches')),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      final code = item.currency.code;
                      final name = item.currency.name;
                      return Card(
                        child: ListTile(
                          leading: FlagAvatar(
                            countryCode: CurrencyFlagCountry.fromCurrencyCode(
                              code,
                            ),
                            fallbackText: code.substring(0, 1),
                          ),
                          title: Text(code),
                          subtitle: Text(name),
                          onTap: () {
                            widget.onSelected(code);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
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
