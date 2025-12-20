class LatestRateQuote {
  const LatestRateQuote({
    required this.from,
    required this.to,
    required this.rate,
    required this.fetchedAtUtc,
  });

  final String from;
  final String to;
  final double rate;
  final DateTime fetchedAtUtc;
}
