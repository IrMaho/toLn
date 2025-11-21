<div dir="rtl">

<p align="center">
  <img src="https://raw.githubusercontent.com/IrMaho/toLn/main/assets/toln-logo.png" alt="لوگوی toLn" width="200"/>
</p>

<h1 align="center">toLn: انقلاب در بومی‌سازی فلاتر</h1>

<p align="center">
  <strong>بدون کلید. بدون دردسر. فقط کد بنویسید.</strong>
</p>

<p align="center">
  <a href="https://pub.dev/packages/toln"><img src="https://img.shields.io/pub/v/toln.svg?style=for-the-badge&logo=dart" alt="نسخه Pub"></a>
  <a href="https://github.com/IrMaho/toLn/blob/main/LICENSE"><img src="https://img.shields.io/github/license/IrMaho/toLn.svg?style=for-the-badge" alt="مجوز"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/platform-flutter-02569B.svg?style=for-the-badge&logo=flutter" alt="پلتفرم"></a>
  <a href="https://github.com/IrMaho/toLn/pulls"><img src="https://img.shields.io/badge/PRs-خوش‌آمدید-brightgreen.svg?style=for-the-badge" alt="PRها خوش‌آمدید"></a>
</p>

<p align="center">
  📖 <strong>این مستندات را به زبان‌های دیگر بخوانید:</strong> 
  <a href="README.md">English</a> • 
  <a href="Ar.md">العربية</a>
</p>

---

## 🌟 toLn چیست؟

**toLn** فقط یک پکیج i18n معمولی نیست—این یک تغییر کامل پارادایم در بومی‌سازی (Localization) فلاتر است. ما فرآیند خسته‌کننده و مستعد خطای مدیریت کلیدهای ترجمه و همگام‌سازی دستی فایل‌ها را حذف می‌کنیم. با toLn، کد Dart شما تنها منبع حقیقت می‌شود و اتوماسیون هوشمند بقیه کارها را انجام می‌دهد.

### مشکلی که حل می‌کنیم

بومی‌سازی سنتی دردناک است:
- 🔑 ایجاد و مدیریت صدها کلید ترجمه
- 📝 به‌روزرسانی دستی چندین فایل ترجمه
- 🔄 بازسازی رابط کاربری (UI) هنگام تغییر زبان
- 🐛 شکار اشتباهات تایپی در ده‌ها فایل
- ⚡ بازنویسی (Refactoring) پروژه‌های موجود برای افزودن i18n

### راه‌حل toLn

```dart
// روش سنتی ❌
Text(AppLocalizations.of(context)!.welcomeMessage)

// روش toLn ✅
Text('به اپلیکیشن ما خوش آمدید!'.toLn())
```

همین! بدون کلید، بدون context، بدون کد اضافی. **فقط متن خود را بنویسید.**

---

## 🚀 ویژگی‌های کلیدی

| ویژگی | توضیحات |
|-------|---------|
| **🎯 گردش کار بدون کلید** | دیگر هرگز نیازی به ایجاد یا مدیریت کلیدهای ترجمه ندارید. toLn آنها را به صورت خودکار تولید می‌کند. |
| **🪄 بازنویسی خودکار** | دستور `dart run toln auto-apply` به طور خودکار بومی‌سازی را به کل اپ شما اضافه می‌کند. |
| **🧠 دستیار هوشمند** | اشتباهات تایپی را تشخیص می‌دهد و استفاده مجدد از ترجمه‌های موجود را پیشنهاد می‌کند. |
| **⚡ به‌روزرسانی خودکار UI** | تغییر زبان باعث بازسازی خودکار رابط کاربری می‌شود—بدون نیاز به `setState`. |
| **🌍 RTL/LTR خودکار** | تغییر خودکار جهت متن برای عربی، فارسی، عبری و غیره. |
| **🔍 کشف زبان‌ها** | تمام زبان‌های موجود در پروژه شما را به طور خودکار تشخیص می‌دهد. |
| **🎨 نام‌های سفارشی** | به جای "ES" عبارت "Español" را در انتخاب‌گر زبان نمایش دهید. |
| **🔧 ابزارهای CLI** | دستورات قدرتمند: `extract`، `sync`، `auto-apply` و `migrate`. |

---

## ⚡ شروع سریع

### ۱. نصب

toLn را به `pubspec.yaml` خود اضافه کنید:

```yaml
dependencies:
  toln: ^0.0.3
```

سپس اجرا کنید:
```bash
flutter pub get
```

### ۲. راه‌اندازی اولیه (پروژه‌های جدید)

در فایل `main.dart` خود:

```dart
import 'package:flutter/material.dart';
import 'package:toln/toln.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ToLn.init(baseLocale: 'en'); // زبان کد منبع شما
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
        title: Text('اپلیکیشن فوق‌العاده من'.toLn()),
      ),
      body: Center(
        child: Text('به فلاتر خوش آمدید!'.toLn()),
      ),
    );
  }
}
```

### ۳. استخراج ترجمه‌ها

استخراج‌کننده (extractor) را اجرا کنید تا فایل‌های ترجمه ایجاد شوند:

```bash
dart run toln extract
```

این دستور فایل‌های `assets/locales/base.ln` و `assets/locales/key_map.ln` را ایجاد می‌کند.

### ۴. افزودن زبان‌های بیشتر

`base.ln` را کپی کنید تا فایل‌های زبان جدید ایجاد کنید:

```bash
cp assets/locales/base.ln assets/locales/es.ln
cp assets/locales/base.ln assets/locales/fa.ln
```

هر فایل را با ترجمه‌ها ویرایش کنید:

```json
// assets/locales/fa.ln
{
  "ln_name": "فارسی",
  "keLn1": "اپلیکیشن فوق‌العاده من",
  "keLn2": "به فلاتر خوش آمدید!"
}
```

### ۵. به‌روزرسانی pubspec.yaml

فایل‌های locale خود را به assets اضافه کنید:

```yaml
flutter:
  assets:
    - assets/locales/
```

🎉 **تمام!** اپلیکیشن شما اکنون کاملاً بومی‌سازی شده است!

---

## 🛠️ استفاده پیشرفته

### انتخاب‌گر زبان (Language Switcher)

یک انتخاب‌گر زبان زیبا با کمترین تلاش بسازید:

```dart
AppBar(
  title: Text('تنظیمات'.toLn()),
  actions: [
    FutureBuilder<List<LocaleInfo>>(
      future: ToLn.getAvailableLocales(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          tooltip: 'تغییر زبان'.toLn(),
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

### رشته‌های پویا با متغیرها

toLn به طور خودکار درون‌ریزی رشته (string interpolation) را مدیریت می‌کند:

```dart
final username = "مریم";
final points = 1250;

Text('سلام، $username!'.toLn())
Text('شما $points امتیاز دارید'.toLn())
```

در فایل‌های ترجمه خود، از `$s` به عنوان جای‌نگهدار (placeholder) استفاده کنید:

```json
{
  "keLn1": "سلام، $s!",
  "keLn2": "شما $s امتیاز دارید"
}
```

ترجمه اسپانیایی:

```json
{
  "keLn1": "¡Hola, $s!",
  "keLn2": "Tienes $s puntos"
}
```

### نادیده گرفتن دستی کلید (Manual Key Override)

برای موارد نادری که می‌خواهید متن‌های مختلف از یک ترجمه یکسان استفاده کنند:

```dart
Text('تایید'.toLn(key: 'confirm'))
Text('قبول'.toLn(key: 'confirm'))
```

هر دو از یک کلید ترجمه استفاده خواهند کرد.

### ادغام با ویجت‌های رایج

toLn به طور یکپارچه با تمام ویجت‌های فلاتر کار می‌کند:

```dart
// ویجت‌های متنی
Text('متن ساده'.toLn())
Text('سلام، $name!'.toLn())

// Tooltipها
IconButton(
  icon: Icon(Icons.save),
  tooltip: 'ذخیره تغییرات'.toLn(),
  onPressed: () {},
)

// SnackBarها
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('آیتم با موفقیت ذخیره شد!'.toLn())),
);

// دیالوگ‌ها
AlertDialog(
  title: Text('تایید حذف'.toLn()),
  content: Text('آیا مطمئن هستید که می‌خواهید این آیتم را حذف کنید؟'.toLn()),
  actions: [
    TextButton(
      child: Text('انصراف'.toLn()),
      onPressed: () => Navigator.pop(context),
    ),
    TextButton(
      child: Text('حذف'.toLn()),
      onPressed: () {},
    ),
  ],
)

// فیلدهای ورودی
TextField(
  decoration: InputDecoration(
    labelText: 'آدرس ایمیل'.toLn(),
    hintText: 'ایمیل خود را وارد کنید'.toLn(),
    helperText: 'ما هرگز ایمیل شما را به اشتراک نمی‌گذاریم'.toLn(),
  ),
)
```

---

## 🔧 دستورات CLI

### `auto-apply` - بازنویسی خودکار

یک پروژه موجود را به طور خودکار برای استفاده از toLn تبدیل کنید:

```bash
dart run toln auto-apply
```

**کارهایی که انجام می‌دهد:**
1. کل دایرکتوری `lib/` را اسکن می‌کند.
2. `.toLn()` را به متن‌های موجود در ویجت‌هایی مانند `Text`، `InputDecoration` و غیره اضافه می‌کند.
3. `import 'package:toln/toln.dart';` را جایی که نیاز باشد تزریق می‌کند.
4. تابع `main()` شما را با مقداردهی اولیه پیکربندی می‌کند.
5. به طور خودکار `extract` را اجرا می‌کند.

**حالت آزمایشی (Dry run)** (مشاهده تغییرات بدون اصلاح فایل‌ها):
```bash
dart run toln auto-apply --dry-run
```

### `extract` - تولید فایل‌های ترجمه

کد خود را اسکن کنید و فایل‌های ترجمه را ایجاد/به‌روزرسانی کنید:

```bash
dart run toln extract
```

**ویژگی‌ها:**
- تمام فراخوانی‌های `.toLn()` را با استفاده از تحلیل استاتیک پیدا می‌کند.
- `base.ln` را با تمام متن‌ها تولید می‌کند.
- `key_map.ln` را برای نگاشت داخلی ایجاد می‌کند.
- **دستیار هوشمند**: اشتباهات تایپی و رشته‌های مشابه را تشخیص می‌دهد و استفاده مجدد از کلید را پیشنهاد می‌دهد.

### `sync` - همگام‌سازی فایل‌های ترجمه

کلیدهای گمشده را به تمام فایل‌های زبان اضافه کنید:

```bash
dart run toln sync
```

**کارهایی که انجام می‌دهد:**
- تمام فایل‌های `.ln` را با `base.ln` مقایسه می‌کند.
- کلیدهای گمشده را به هر فایل زبان اضافه می‌کند.
- ترجمه‌های موجود را حفظ می‌کند.
- برای به‌روز نگه داشتن مترجم‌ها عالی است.

### `migrate` - مهاجرت از intl/arb به toLn

پروژه‌ای دارید که از `intl` و فایل‌های `.arb` استفاده می‌کند؟ به راحتی مهاجرت کنید:

```bash
dart run toln migrate
```

**کارهایی که انجام می‌دهد:**
1. پیکربندی `l10n.yaml` شما را می‌خواند.
2. فایل‌های `.arb` را به فرمت `.ln` تبدیل می‌کند.
3. تمام فراخوانی‌های `AppLocalizations.of(context).key` را به `.toLn()` بازنویسی می‌کند.
4. delegateهای قدیمی بومی‌سازی را حذف می‌کند.
5. پس از موفقیت، فایل‌های قدیمی را پاک می‌کند.

---

## 📚 مرجع API

### کلاس ToLn

#### `ToLn.init()`

سیستم بومی‌سازی را مقداردهی اولیه کنید.

```dart
static Future<void> init({
  required String baseLocale,
  String? initialLocale,
})
```

**پارامترها:**
- `baseLocale` *(الزامی)*: زبان کد منبع شما (مثلاً 'en'، 'fa').
- `initialLocale` *(اختیاری)*: زبان شروع. پیش‌فرض زبان دستگاه یا `baseLocale`.

#### `ToLn.loadLocale()`

زبان فعلی اپلیکیشن را تغییر دهید.

```dart
static Future<void> loadLocale(String newLocale)
```

**پارامترها:**
- `newLocale`: کد زبانی که می‌خواهید به آن تغییر دهید (مثلاً 'es'، 'ar').

**تأثیرات:**
- فایل `.ln` مربوطه را بارگذاری می‌کند.
- جهت متن را به‌روزرسانی می‌کند.
- بازسازی خودکار UI را از طریق `localeNotifier` فعال می‌کند.

#### `ToLn.getAvailableLocales()`

دریافت تمام زبان‌های موجود در اپلیکیشن.

```dart
static Future<List<LocaleInfo>> getAvailableLocales()
```

**خروجی:** لیستی از رکوردهای `LocaleInfo`: `({String code, String name})`

**مثال:**
```dart
final locales = await ToLn.getAvailableLocales();
// Result: [(code: 'en', name: 'English'), (code: 'es', name: 'Español')]
```

#### `ToLn.currentDirection`

دریافت جهت متن برای زبان فعلی.

```dart
static TextDirection get currentDirection
```

**خروجی:** `TextDirection.rtl` یا `TextDirection.ltr`

**زبان‌های راست‌چین (RTL):** ar, fa, he, ur (تشخیص خودکار)

#### `ToLn.localeNotifier`

ValueNotifier برای به‌روزرسانی‌های واکنش‌گرا (Reactive) رابط کاربری.

```dart
static final ValueNotifier<Locale> localeNotifier
```

**نحوه استفاده:**
```dart
ValueListenableBuilder<Locale>(
  valueListenable: ToLn.localeNotifier,
  builder: (context, locale, child) {
    return MaterialApp(locale: locale, ...);
  },
)
```

### متدهای افزونه (Extension Methods)

#### `.toLn()`

ترجمه یک رشته.

```dart
extension ToLnExtension on String {
  String toLn({String? key})
}
```

**پارامترها:**
- `key` *(اختیاری)*: نادیده گرفتن دستی کلید ترجمه.

**مثال‌ها:**
```dart
'Hello World'.toLn()                    // کلید خودکار
'Goodbye'.toLn(key: 'farewell')        // کلید دستی
'Welcome, $username!'.toLn()            // با متغیرها
```

---

## ⚠️ مشکلات رایج

### مشکل `const`

**مشکل:** زبان تغییر می‌کند اما UI به‌روزرسانی نمی‌شود.

**علت:** کلمه کلیدی `const` به Flutter می‌گوید که این ویجت هرگز بازسازی نمی‌شود.

**❌ نادرست:**
```dart
home: const HomePage(),  // این به‌روزرسانی نمی‌شود!
```

**✅ درست:**
```dart
home: HomePage(),  // حالا می‌تواند بازسازی شود
```

**قانون:** `const` را از هر ویجتی که حاوی متن قابل ترجمه است یا والدین آن حذف کنید.

### فراموشی افزودن Assets

**مشکل:** اپلیکیشن با خطای "Unable to load asset" کرش می‌کند.

**راه‌حل:** فایل‌های locale خود را به `pubspec.yaml` اضافه کنید:

```yaml
flutter:
  assets:
    - assets/locales/
```

---

## 🎯 مثال‌های واقعی

### کارت محصول در فروشگاه

```dart
class ProductCard extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(product.imageUrl),
          Text(product.name),  // در پایگاه داده شما از قبل موجود است
          Text('${product.price} تومان'),
          ElevatedButton(
            onPressed: () {},
            child: Text('افزودن به سبد خرید'.toLn()),
          ),
          Text('ارسال رایگان برای سفارش‌های بالای ۵۰۰ هزار تومان!'.toLn()),
        ],
      ),
    );
  }
}
```

### اعتبارسنجی فرم

```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'ایمیل الزامی است'.toLn();
  }
  if (!value.contains('@')) {
    return 'لطفاً یک ایمیل معتبر وارد کنید'.toLn();
  }
  return null;
}

TextField(
  decoration: InputDecoration(
    labelText: 'ایمیل'.toLn(),
    errorText: validateEmail(email),
  ),
)
```

### صفحه تنظیمات با انتخاب‌گر زبان

```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text('زبان'.toLn()),
          subtitle: FutureBuilder<List<LocaleInfo>>(
            future: ToLn.getAvailableLocales(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('در حال بارگذاری...'.toLn());
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
        title: Text('انتخاب زبان'.toLn()),
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

## 🤝 مشارکت

ما از مشارکت استقبال می‌کنیم! در اینجا نحوه کمک به ما آمده است:

1. **گزارش باگ‌ها**: [یک issue باز کنید](https://github.com/IrMaho/toLn/issues)
2. **پیشنهاد ویژگی‌ها**: ایده‌های خود را به اشتراک بگذارید
3. **ارسال PR**: باگ‌ها را رفع کنید یا ویژگی‌های جدید اضافه کنید
4. **بهبود مستندات**: به ما کمک کنید مستندات را بهتر کنیم
5. **انتشار**: به مخزن (repo) ستاره بدهید ⭐

### راه‌اندازی محیط توسعه

```bash
git clone https://github.com/IrMaho/toLn.git
cd toLn
flutter pub get
dart test
```

---

## 📄 مجوز

این پروژه تحت مجوز MIT منتشر شده است - برای جزئیات فایل [LICENSE](LICENSE) را ببینید.

---

## 🙏 قدردانی‌ها

ساخته شده با ❤️ توسط [شق شهادت](https://github.com/IrMaho)

تشکر ویژه از:
- تیم Flutter برای یک فریم‌ورک شگفت‌انگیز
- تیم Dart analyzer برای ابزارهای قدرتمند AST
- تمام مشارکت‌کنندگان و کاربران ما

---

## 📞 پشتیبانی

- 📧 ایمیل: support@example.com
- 💬 GitHub Issues: [گزارش مشکل](https://github.com/IrMaho/toLn/issues)
- 📖 مستندات: [مستندات کامل](https://github.com/IrMaho/toLn/wiki)

---

<p align="center">
  <strong>ساخته شده با ❤️ برای جامعه Flutter</strong>
</p>

<p align="center">
  <a href="https://github.com/IrMaho/toLn">⭐ در GitHub ستاره بدهید</a> •
  <a href="https://pub.dev/packages/toln">📦 مشاهده در pub.dev</a>
</p>

</div>
