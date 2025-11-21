<p align="center">
  <img src="https://raw.githubusercontent.com/IrMaho/toLn/main/assets/toln-logo.png" alt="toLn Logo" width="200"/>
</p>

<h1 align="center">toL: Revolutionary Flutter Localization</h1>

<p align="center">
  <strong>Zero keys. Zero hassle. Just code.</strong>
</p>

<p align="center">
  <a href="https://pub.dev/packages/toln"><img src="https://img.shields.io/pub/v/toln.svg?style=for-the-badge&logo=dart" alt="Pub Version"></a>
  <a href="https://github.com/IrMaho/toLn/blob/main/LICENSE"><img src="https://img.shields.io/github/license/IrMaho/toLn.svg?style=for-the-badge" alt="License"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/platform-flutter-02569B.svg?style=for-the-badge&logo=flutter" alt="Platform"></a>
  <a href="https://github.com/IrMaho/toLn/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge" alt="PRs Welcome"></a>
</p>

<p align="center">
  📖 <strong>Read in other languages:</strong> 
  <a href="Fa.md">فارسی</a> • 
  <a href="Ar.md">العربية</a>
</p>

---

## 🌟 What is toLn?

**toLn** is not just another i18n package—it's a complete paradigm shift in Flutter localization. We eliminate the tedious, error-prone workflow of managing translation keys and manual file synchronization. With toLn, your Dart code becomes the single source of truth, and intelligent automation handles everything else.

### The Problem We Solve

Traditional localization is painful:
- 🔑 Inventing and managing hundreds of translation keys
- 📝 Manually updating multiple translation files
- 🔄 Rebuilding UI when language changes
- 🐛 Hunting down typos across dozens of files
- ⚡ Refactoring existing projects to add i18n

### The toLn Solution

```dart
// Traditional way❌
Text(AppLocalizations.of(context)!.welcomeMessage)

// The toLn way ✅
Text('Welcome to our app!'.toLn())
```

That's it. No keys, no context, no boilerplate. **Just write your text.**

---

## 🚀 Key Features

| Feature | Description |
|---------|-------------|
| **🎯 Zero-Key Workflow** | Never invent or manage translation keys again. toLn generates them automatically. |
| **🪄 Auto-Refactor** | `dart run toln auto-apply` automatically adds localization to your entire app. |
| **🧠 Smart Assistant** | Detects typos and suggests reusing existing translations. |
| **⚡ Auto UI Update** | Language changes trigger automatic UI rebuilds—no `setState` needed. |
| **🌍 RTL/LTR Auto** | Automatic text direction switching for Arabic, Persian, Hebrew, etc. |
| **🔍 Language Discovery** | Auto-detects all available languages in your project. |
| **🎨 Custom Names** | Display "Español" instead of "ES" in language pickers. |
| **🔧 CLI Tools** | Powerful commands: `extract`, `sync`, `auto-apply`, and `migrate`. |

---

## ⚡ Quick Start

### 1. Installation

Add toLn to your `pubspec.yaml`:

```yaml
dependencies:
  toln: ^0.0.3
```

Then run:
```bash
flutter pub get
```

### 2. Initial Setup (New Projects)

In your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:toln/toln.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ToLn.init(baseLocale: 'en'); // Your code's language
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: ToLn.localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          locale: locale,
          builder: (context, child) {
            return Directionality(
              textDirection: ToLn.currentDirection,
              child: child!,
            );
          },
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Awesome App'.toLn()),
      ),
      body: Center(
        child: Text('Welcome to Flutter!'.toLn()),
      ),
    );
  }
}
```

### 3. Extract Translations

Run the extractor to generate translation files:

```bash
dart run toln extract
```

This creates `assets/locales/base.ln` and `assets/locales/key_map.ln`.

### 4. Add More Languages

Copy `base.ln` to create new language files:

```bash
cp assets/locales/base.ln assets/locales/es.ln
cp assets/locales/base.ln assets/locales/fa.ln
```

Edit each file with translations:

```json
// assets/locales/es.ln
{
  "ln_name": "Español",
  "keLn1": "Mi Aplicación Increíble",
  "keLn2": "¡Bienvenido a Flutter!"
}
```

### 5. Update pubspec.yaml

Add your locale files to assets:

```yaml
flutter:
  assets:
    - assets/locales/
```

🎉 **Done!** Your app is now fully localized!

---

## 🛠️ Advanced Usage

### Language Switcher

Build a beautiful language picker with zero effort:

```dart
AppBar(
  title: Text('Settings'.toLn()),
  actions: [
    FutureBuilder<List<LocaleInfo>>(
      future: ToLn.getAvailableLocales(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          tooltip: 'Change Language'.toLn(),
          onSelected: (locale) => ToLn.loadLocale(locale),
          itemBuilder: (context) => snapshot.data!.map((locale) {
            return PopupMenuItem(
              value: locale.code,
              child: Text(locale.name),
            );
          }).toList(),
        );
      },
    ),
  ],
)
```

### Dynamic Strings with Variables

toLn automatically handles string interpolation:

```dart
final username = "Maria";
final points = 1250;

Text('Hello, $username!'.toLn())
Text('You have $points points'.toLn())
```

In your translation files, use `$s` as a placeholder:

```json
{
  "keLn1": "Hello, $s!",
  "keLn2": "You have $s points"
}
```

Spanish translation:

```json
{
  "keLn1": "¡Hola, $s!",
  "keLn2": "Tienes $s puntos"
}
```

### Manual Key Override

For rare cases where you want different source texts to use the same translation:

```dart
Text('OK'.toLn(key: 'confirm'))
Text('Confirm'.toLn(key: 'confirm'))
```

Both will use the same translation key.

### Integration with Common Widgets

toLn works seamlessly with all Flutter widgets:

```dart
// Text widgets
Text('Simple text'.toLn())
Text('Hello, $name!'.toLn())

// Tooltips
IconButton(
  icon: Icon(Icons.save),
  tooltip: 'Save changes'.toLn(),
  onPressed: () {},
)

// SnackBars
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Item saved successfully!'.toLn())),
);

// Dialogs
AlertDialog(
  title: Text('Confirm Delete'.toLn()),
  content: Text('Are you sure you want to delete this item?'.toLn()),
  actions: [
    TextButton(
      child: Text('Cancel'.toLn()),
      onPressed: () => Navigator.pop(context),
    ),
    TextButton(
      child: Text('Delete'.toLn()),
      onPressed: () {},
    ),
  ],
)

// Input Fields
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address'.toLn(),
    hintText: 'Enter your email'.toLn(),
    helperText: 'We will never share your email'.toLn(),
  ),
)
```

---

## 🔧 CLI Commands

### `auto-apply` - Automatic Refactoring

Transform an existing project to use toLn automatically:

```bash
dart run toln auto-apply
```

**What it does:**
1. Scans your entire `lib/` directory
2. Adds `.toLn()` to text in widgets like `Text`, `InputDecoration`, etc.
3. Injects `import 'package:toln/toln.dart';` where needed
4. Configures your `main()` function with initialization
5. Runs `extract` automatically

**Dry run mode** (see changes without modifying files):
```bash
dart run toln auto-apply --dry-run
```

### `extract` - Generate Translation Files

Scan your code and create/update translation files:

```bash
dart run toln extract
```

**Features:**
- Finds all `.toLn()` calls using static analysis
- Generates `base.ln` with all texts
- Creates `key_map.ln` for internal mapping
- **Smart Assistant**: Detects typos and similar strings, suggests key reuse

### `sync` - Synchronize Translation Files

Add missing keys to all language files:

```bash
dart run toln sync
```

**What it does:**
- Compares all `.ln` files with `base.ln`
- Adds missing keys to each language file
- Preserves existing translations
- Perfect for keeping translators up-to-date

### `migrate` - From intl/arb to toLn

Got an existing project using `intl` and `.arb` files? Migrate seamlessly:

```bash
dart run toln migrate
```

**What it does:**
1. Reads your `l10n.yaml` configuration
2. Converts `.arb` files to `.ln` format
3. Refactors all `AppLocalizations.of(context).key` calls to `.toLn()`
4. Removes old localization delegates
5. Cleans up old files after success

---

## 📚 API Reference

### ToLn Class

#### `ToLn.init()`

Initialize the localization system.

```dart
static Future<void> init({
  required String baseLocale,
  String? initialLocale,
})
```

**Parameters:**
- `baseLocale` *(required)*: Language of your source code (e.g., 'en', 'fa')
- `initialLocale` *(optional)*: Starting language. Defaults to device language or `baseLocale`

#### `ToLn.loadLocale()`

Change the app's current language.

```dart
static Future<void> loadLocale(String newLocale)
```

**Parameters:**
- `newLocale`: Language code to switch to (e.g., 'es', 'ar')

**Effects:**
- Loads the corresponding `.ln` file
- Updates text direction
- Triggers automatic UI rebuild via `localeNotifier`

#### `ToLn.getAvailableLocales()`

Get all available languages in your app.

```dart
static Future<List<LocaleInfo>> getAvailableLocales()
```

**Returns:** List of `LocaleInfo` records: `({String code, String name})`

**Example:**
```dart
final locales = await ToLn.getAvailableLocales();
// Result: [(code: 'en', name: 'English'), (code: 'es', name: 'Español')]
```

#### `ToLn.currentDirection`

Get the text direction for the current language.

```dart
static TextDirection get currentDirection
```

**Returns:** `TextDirection.rtl` or `TextDirection.ltr`

**RTL Languages:** ar, fa, he, ur (auto-detected)

#### `ToLn.localeNotifier`

ValueNotifier for reactive UI updates.

```dart
static final ValueNotifier<Locale> localeNotifier
```

**Usage:**
```dart
ValueListenableBuilder<Locale>(
  valueListenable: ToLn.localeNotifier,
  builder: (context, locale, child) {
    return MaterialApp(locale: locale, ...);
  },
)
```

### Extension Methods

#### `.toLn()`

Translate a string.

```dart
extension ToLnExtension on String {
  String toLn({String? key})
}
```

**Parameters:**
- `key` *(optional)*: Manual translation key override

**Examples:**
```dart
'Hello World'.toLn()                    // Automatic key
'Goodbye'.toLn(key: 'farewell')        // Manual key
'Welcome, $username!'.toLn()            // With variables
```

---

## ⚠️ Common Pitfalls

### The `const` Problem

**Problem:** Language changes but UI doesn't update.

**Cause:** The `const` keyword tells Flutter the widget never rebuilds.

**❌ Incorrect:**
```dart
home: const HomePage(),  // This won't update!
```

**✅ Correct:**
```dart
home: HomePage(),  // Now it can rebuild
```

**Rule:** Remove `const` from any widget containing translatable text or its ancestors.

### Forgot to Add Assets

**Problem:** App crashes with "Unable to load asset".

**Solution:** Add locale files to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/locales/
```

---

## 🎯 Real-World Examples

### E-commerce App

```dart
class ProductCard extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(product.imageUrl),
          Text(product.name),  // Already in your database
          Text('${product.price} USD'),
          ElevatedButton(
            onPressed: () {},
            child: Text('Add to Cart'.toLn()),
          ),
          Text('Free shipping on orders over $50!'.toLn()),
        ],
      ),
    );
  }
}
```

### Form Validation

```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required'.toLn();
  }
  if (!value.contains('@')) {
    return 'Please enter a valid email'.toLn();
  }
  return null;
}

TextField(
  decoration: InputDecoration(
    labelText: 'Email'.toLn(),
    errorText: validateEmail(email),
  ),
)
```

### Settings Screen with Language Picker

```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text('Language'.toLn()),
          subtitle: FutureBuilder<List<LocaleInfo>>(
            future: ToLn.getAvailableLocales(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading...'.toLn());
              final current = snapshot.data!.firstWhere(
                (l) => l.code == ToLn.localeNotifier.value.languageCode,
              );
              return Text(current.name);
            },
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => _showLanguagePicker(context),
        ),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context) async {
    final locales = await ToLn.getAvailableLocales();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'.toLn()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: locales.map((locale) {
            return RadioListTile<String>(
              title: Text(locale.name),
              value: locale.code,
              groupValue: ToLn.localeNotifier.value.languageCode,
              onChanged: (value) {
                if (value != null) {
                  ToLn.loadLocale(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Report Bugs**: [Open an issue](https://github.com/IrMaho/toLn/issues)
2. **Suggest Features**: Share your ideas
3. **Submit PRs**: Fix bugs or add features
4. **Improve Docs**: Help us make documentation better
5. **Spread the Word**: Star the repo ⭐

### Development Setup

```bash
git clone https://github.com/IrMaho/toLn.git
cd toLn
flutter pub get
dart test
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Built with ❤️ by [Shogh Shahadat](https://github.com/IrMaho)

Special thanks to:
- The Flutter team for an amazing framework
- The Dart analyzer team for powerful AST tools
- All our contributors and users

---

## 📞 Support

- 📧 Email: support@example.com
- 💬 GitHub Issues: [Report a problem](https://github.com/IrMaho/toLn/issues)
- 📖 Documentation: [Full docs](https://github.com/IrMaho/toLn/wiki)

---

<p align="center">
  <strong>Made with ❤️ for the Flutter community</strong>
</p>

<p align="center">
  <a href="https://github.com/IrMaho/toLn">⭐ Star us on GitHub</a> •
  <a href="https://pub.dev/packages/toln">📦 View on pub.dev</a>
</p>
