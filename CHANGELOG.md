# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3] - 2025-01-21

### 🔄 Changed
- **Updated dependencies to latest versions:**
  - `path`: 1.8.3 → 1.9.1
  - `args`: 2.4.2 → 2.7.0
  - `analyzer`: 6.2.0 → 9.0.0 (Major update)
  - `dart_style`: 2.3.3 → 3.1.3 (Major update)
  - `yaml`: 3.1.2 → 3.1.3
  - `flutter_lints`: 2.0.0 → 6.0.0 (Major update)

### 📚 Improved
- Enhanced documentation with comprehensive examples
- Added multilingual documentation:
  - English (README.md)
  - Persian/Farsi (Fa.md)
  - Arabic (Ar.md)
- Added cross-language links in all documentation files

### 🛠️ Technical
- Resolved compatibility issues with newer Dart SDK versions
- Improved support for modern Flutter development tools
- Better integration with latest analyzer and dart_style packages

---

## [0.0.2] - 2025-01-15

### 📝 Documentation
- Improved README with clearer examples
- Added more detailed API documentation
- Enhanced CLI command descriptions

---

## [0.0.1] - 2025-01-13

### ✨ Added - Initial Release!

**Revolutionary Features:**

#### Zero-Key Workflow
- Completely automated key generation
- Developers never need to manage translation keys
- Single source of truth: your code

#### Intelligent CLI Tools
A full suite of command-line tools to manage the localization workflow:

**`dart run toln extract`**
- Powerful AST-based extractor for finding all translatable strings
- Smart detection of display text in widgets
- Automatic key generation and mapping

**`dart run toln sync`**
- Automatically syncs all translation files with the base file
- Adds missing keys to language files
- Preserves existing translations

**`dart run toln auto-apply` - The Magic Command** ✨
- Automatically adds `.toLn()` to all display strings in supported widgets
- Automatically injects the `toln` import where needed
- Automatically configures the `main()` function with:
  - `async` keyword
  - `WidgetsFlutterBinding.ensureInitialized()`
  - `ToLn.init()` initialization
- Runs `extract` automatically after applying changes

#### Smart Assistant 🧠
- Integrated into the extract command
- Detects typos and similar strings
- Suggests reuse of existing translations
- Helps maintain translation consistency

#### Automatic UI Updates
- Uses `ValueNotifier` (`ToLn.localeNotifier`) for reactive updates
- Rebuilds UI instantly on locale change
- No manual `setState` calls needed
- Zero-boilerplate state management for i18n

#### Automatic Text Direction
- `ToLn.currentDirection` provides correct `TextDirection`
- Automatic switching between LTR and RTL
- Built-in support for: Arabic (ar), Persian (fa), Hebrew (he), Urdu (ur)
- Seamless layout adaptation

#### Dynamic Language Discovery
- `ToLn.getAvailableLocales()` scans project assets
- Automatically finds all available `.ln` files
- Returns language codes and display names
- Perfect for building language selection menus

#### Customizable Language Names
- Optional `ln_name` key in translation files
- User-friendly display names (e.g., "فارسی" instead of "FA")
- Smart fallback to capitalized language code
- Supports empty values with graceful degradation

---

## Documentation Languages

📖 **Read this in other languages:**
- [🇬🇧 English](README.md)
- [🇮🇷 فارسی (Persian)](Fa.md)
- [🇸🇦 العربية (Arabic)](Ar.md)