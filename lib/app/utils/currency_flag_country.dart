import 'iso_country_codes.dart';

sealed class CurrencyFlagCountry {
  /// Returns an ISO 3166-1 alpha-2 country code (e.g. "US") for a currency code (e.g. "USD"),
  /// or null if unknown / ambiguous.
  static String? fromCurrencyCode(String currencyCode) {
    final c = currencyCode.trim().toUpperCase();

    // NOTE: currency->flag is inherently ambiguous for many currencies (e.g. XOF, USD, EUR).
    // We map common ones for a nicer UI and fall back to no flag.
    final override = switch (c) {
      'USD' => 'US',
      'EUR' => 'EU',
      'GBP' => 'GB',
      'JPY' => 'JP',
      'AUD' => 'AU',
      'CAD' => 'CA',
      'CHF' => 'CH',
      'CNY' => 'CN',
      'HKD' => 'HK',
      'SGD' => 'SG',
      'INR' => 'IN',
      'KRW' => 'KR',
      'SEK' => 'SE',
      'NOK' => 'NO',
      'DKK' => 'DK',
      'NZD' => 'NZ',
      'MXN' => 'MX',
      'BRL' => 'BR',
      'ZAR' => 'ZA',
      'TRY' => 'TR',
      'RUB' => 'RU',
      'PLN' => 'PL',
      'CZK' => 'CZ',
      'HUF' => 'HU',
      'ILS' => 'IL',
      'SAR' => 'SA',
      'AED' => 'AE',
      'QAR' => 'QA',
      'KWD' => 'KW',
      'EGP' => 'EG',
      'NGN' => 'NG',
      'PKR' => 'PK',
      'BDT' => 'BD',
      'IDR' => 'ID',
      'MYR' => 'MY',
      'THB' => 'TH',
      'VND' => 'VN',
      'PHP' => 'PH',
      'TWD' => 'TW',
      'UAH' => 'UA',
      'RON' => 'RO',
      'BGN' => 'BG',
      'HRK' => 'HR',
      'ZMW' => 'ZM',
      'KES' => 'KE',
      'UGX' => 'UG',
      'TZS' => 'TZ',
      'RWF' => 'RW',
      'BIF' => 'BI',
      'CDF' => 'CD',
      'GNF' => 'GN',
      'GHS' => 'GH',
      'ETB' => 'ET',
      'LKR' => 'LK',
      'MUR' => 'MU',
      'SCR' => 'SC',
      'MVR' => 'MV',
      'MNT' => 'MN',
      'MMK' => 'MM',
      'LAK' => 'LA',
      'KHR' => 'KH',
      _ => null,
    };

    if (override != null) return override;

    // Heuristic for broad coverage:
    // Many ISO-4217 currency codes start with the ISO-3166 country code (e.g. KES->KE, BRL->BR).
    // If the first 2 letters match a real ISO country code, use it.
    if (c.length >= 2) {
      final candidate = c.substring(0, 2);
      if (kIsoCountryCodes.contains(candidate)) return candidate;
    }
    return null;
  }
}
