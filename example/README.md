# ToLn Example App

This example demonstrates the power and simplicity of the `toLn` package for Flutter localization.

## Features Demonstrated

- **Zero-Boilerplate Localization**: No `AppLocalizations.of(context)` calls.
- **Dynamic Language Switching**: Change language instantly without app restart.
- **RTL Support**: Automatic layout mirroring for Arabic and Persian.
- **Dynamic Strings**: String interpolation with translation support.
- **Manual Key Overrides**: Using specific keys for shared text.

## Getting Started

1.  **Initialize**:
    The app initializes `ToLn` in `main()`:
    ```dart
    await ToLn.init(baseLocale: 'en');
    ```

2.  **Run**:
    ```bash
    flutter run
    ```

3.  **Explore**:
    - Tap the language icon in the AppBar to switch languages.
    - Observe how the UI updates instantly.
    - Notice the directionality change for RTL languages.

## Project Structure

- `lib/main.dart`: The main application code.
- `assets/locales/`: Contains the translation files (`.ln`).
    - `base.ln`: The source of truth (English).
    - `fa.ln`: Persian translations.
    - `ar.ln`: Arabic translations.
    - `key_map.ln`: Internal mapping file.

## Learn More

For full documentation, visit the [toLn package page](https://pub.dev/packages/toln).
