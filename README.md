# Currency Converter (Flutter)

Currency Converter app built with **Clean Architecture** (data/domain/presentation), **BLoC**, **get_it + injectable**, **Drift (SQLite)** caching, and an **offline-first** UX.

## APIs

- **Rates API**: `exchangerate-api.com` v6 (base URL configurable)
- **Flags**: `flagcdn.com` (country flags by ISO code)

## Setup

### 1) Create env file

This workspace blocks dotfiles, so we use `env` (asset) instead of `.env`.

- Copy `env.example` → `env`
- Fill `API_KEY` if your plan requires it

### 2) Run the app

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Architecture (Clean + SOLID)

Feature-first layout with strict boundaries:

- **presentation**: Widgets + BLoC only (no business logic)
- **domain**: Entities + repositories contracts + usecases
- **data**: DTOs, datasources, repository implementations

Cross-cutting code lives in `lib/core/` (Result/Failure, error mapping, DB, network helpers).

## Offline-first behavior

- App always renders from **local Drift cache** first.
- When offline, an **Offline mode banner** is shown and the app keeps working from cache.
- If cached data is stale (**> 12 hours**), the app performs a **background refresh** when online.

## Database (Drift / SQLite) justification

Drift gives:
- **Typed, compile-time safe queries**
- **Reactive streams** (`watch*`) used by BLoCs for live UI updates
- Great fit for offline-first caching (currencies, favorites, latest + historical rates)

## Flags / Image loader justification

Flags are loaded from `flagcdn.com` using `cached_network_image`:
- Caches images on device automatically
- Provides placeholders + error fallbacks for flaky networks

## Testing

Included:
- **Unit tests** for usecases
- **bloc_test** for BLoC transitions
- **Widget tests** for key screens
- **Integration test** (`integration_test/app_flow_test.dart`) for basic navigation flow

Run tests:

```bash
flutter test
```

## CI

GitHub Actions workflow (`.github/workflows/ci.yml`) runs:
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`

