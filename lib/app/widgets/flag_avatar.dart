import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FlagAvatar extends StatelessWidget {
  const FlagAvatar({
    super.key,
    required this.countryCode,
    required this.fallbackText,
  });

  final String? countryCode; // ISO 3166-1 alpha-2, or "EU"
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final cc = countryCode?.trim().toLowerCase();
    final scheme = Theme.of(context).colorScheme;

    if (cc == null || cc.isEmpty) {
      return CircleAvatar(
        backgroundColor: scheme.surfaceContainerHighest,
        child: Text(
          fallbackText,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      );
    }

    // flagcdn expects lower-case country code. EU is also supported.
    // Per CDN docs: fixed-size PNGs are available at /{width}x{height}/{code}.png
    // See: https://flagpedia.net/download/api
    final url = 'https://flagcdn.com/40x30/$cc.png';

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 40,
        height: 30,
        fit: BoxFit.cover,
        errorWidget: (context, _, __) => CircleAvatar(
          backgroundColor: scheme.surfaceContainerHighest,
          child: Text(
            fallbackText,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        placeholder: (context, _) => Container(
          width: 40,
          height: 30,
          color: scheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}
