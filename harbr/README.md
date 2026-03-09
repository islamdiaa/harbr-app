<p align="center">
  <img width="120px" src="./assets/icon/icon.png" alt="Harbr">
</p>

<h1 align="center">Harbr</h1>

<p align="center">
  The Flutter project for the Harbr app.
</p>

---

## Project Structure

```
lib/
  api/          # API clients (Radarr, Sonarr, Readarr, Tautulli, etc.)
  database/     # Hive local database layer
  modules/      # Feature modules (one per service + settings, dashboard)
  router/       # GoRouter route definitions
  system/       # Platform services (filesystem, network, cache)
  widgets/      # Shared UI components (HarbrBlock, HarbrScaffold, etc.)
  main.dart     # App entry point
```

## Development

```bash
flutter pub get
flutter run
```

### Analyze

```bash
flutter analyze
```

### Test

```bash
flutter test
```

### Build

```bash
flutter build apk          # Android
flutter build ios           # iOS
flutter build linux         # Linux
flutter build macos         # macOS
flutter build windows       # Windows
flutter build web           # Web
```

## Architecture

- **State management**: `ChangeNotifier` + `Provider`
- **Routing**: `go_router`
- **Local storage**: `hive`
- **API layer**: `dio` + `retrofit` (generated clients)
- **Serialization**: `json_serializable` + `freezed`

## License

Licensed under the [GNU General Public License v2.0](../LICENSE.md).
