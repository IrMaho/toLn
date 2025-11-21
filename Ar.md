<div dir="rtl">

<p align="center">
  <img src="https://raw.githubusercontent.com/IrMaho/toLn/main/assets/toln-logo.png" alt="شعار toLn" width="200"/>
</p>

<h1 align="center">toLn: ثورة في الترجمة المحلية لـ Flutter</h1>

<p align="center">
  <strong>بدون مفاتيح. بدون متاعب. فقط اكتب الكود.</strong>
</p>

<p align="center">
  <a href="https://pub.dev/packages/toln"><img src="https://img.shields.io/pub/v/toln.svg?style=for-the-badge&logo=dart" alt="إصدار Pub"></a>
  <a href="https://github.com/IrMaho/toLn/blob/main/LICENSE"><img src="https://img.shields.io/github/license/IrMaho/toLn.svg?style=for-the-badge" alt="الترخيص"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/platform-flutter-02569B.svg?style=for-the-badge&logo=flutter" alt="المنصة"></a>
  <a href="https://github.com/IrMaho/toLn/pulls"><img src="https://img.shields.io/badge/PRs-مرحب بها-brightgreen.svg?style=for-the-badge" alt="PRs مرحب بها"></a>
</p>

<p align="center">
  📖 <strong>اقرأ هذه الوثائق بلغات أخرى:</strong> 
  <a href="README.md">English</a> • 
  <a href="Fa.md">فارسی</a>
</p>

---

## 🌟 ما هو toLn؟

**toLn** ليس مجرد حزمة i18n عادية—إنه تحول كامل في نموذج الترجمة المحلية (Localization) لـ Flutter. نحن نزيل العملية المملة والمعرضة للأخطاء لإدارة مفاتيح الترجمة ومزامنة الملفات اليدوية. مع toLn، يصبح كود Dart الخاص بك هو المصدر الوحيد للحقيقة، والأتمتة الذكية تتولى كل شيء آخر.

### المشكلة التي نحلها

الترجمة المحلية التقليدية مؤلمة:
- 🔑 إنشاء وإدارة مئات مفاتيح الترجمة
- 📝 تحديث ملفات الترجمة المتعددة يدويًا
- 🔄 إعادة بناء واجهة المستخدم (UI) عند تغيير اللغة
- 🐛 البحث عن الأخطاء المطبعية في عشرات الملفات
- ⚡ إعادة هيكلة (Refactoring) المشاريع الموجودة لإضافة i18n

### حل toLn

```dart
// الطريقة التقليدية ❌
Text(AppLocalizations.of(context)!.welcomeMessage)

// طريقة toLn ✅
Text('مرحبًا بك في تطبيقنا!'.toLn())
```

هذا كل شيء! بدون مفاتيح، بدون context، بدون كود إضافي. **فقط اكتب النص الخاص بك.**

---

## 🚀 الميزات الرئيسية

| الميزة | الوصف |
|--------|-------|
| **🎯 سير عمل بدون مفاتيح** | لن تحتاج أبدًا إلى إنشاء أو إدارة مفاتيح الترجمة مرة أخرى. toLn ينشئها تلقائيًا. |
| **🪄 إعادة هيكلة تلقائية** | أمر `dart run toln auto-apply` يضيف الترجمة المحلية تلقائيًا إلى تطبيقك بالكامل. |
| **🧠 مساعد ذكي** | يكتشف الأخطاء المطبعية ويقترح إعادة استخدام الترجمات الموجودة. |
| **⚡ تحديث تلقائي لواجهة المستخدم** | يؤدي تغيير اللغة إلى إعادة بناء واجهة المستخدم تلقائيًا—بدون الحاجة إلى `setState`. |
| **🌍 RTL/LTR تلقائي** | تبديل اتجاه النص تلقائيًا للعربية والفارسية والعبرية إلخ. |
| **🔍 اكتشاف اللغات** | يكتشف تلقائيًا جميع اللغات المتاحة في مشروعك. |
| **🎨 أسماء مخصصة** | اعرض "Español" بدلاً من "ES" في منتقي اللغة. |
| **🔧 أدوات CLI** | أوامر قوية: `extract`، `sync`، `auto-apply` و `migrate`. |

---

## ⚡ البدء السريع

### ١. التثبيت

أضف toLn إلى `pubspec.yaml` الخاص بك:

```yaml
dependencies:
  toln: ^0.0.3
```

ثم قم بتشغيل:
```bash
flutter pub get
```

### ٢. الإعداد الأولي (المشاريع الجديدة)

في ملف `main.dart` الخاص بك:

```dart
import 'package:flutter/material.dart';
import 'package:toln/toln.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ToLn.init(baseLocale: 'en'); // لغة الكود المصدري الخاص بك
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
        title: Text('تطبيقي الرائع'.toLn()),
      ),
      body: Center(
        child: Text('مرحبًا بك في Flutter!'.toLn()),
      ),
    );
  }
}
```

### ٣. استخراج الترجمات

قم بتشغيل المستخرج (extractor) لإنشاء ملفات الترجمة:

```bash
dart run toln extract
```

ينشئ هذا الأمر ملفات `assets/locales/base.ln` و `assets/locales/key_map.ln`.

### ٤. إضافة المزيد من اللغات

انسخ `base.ln` لإنشاء ملفات لغة جديدة:

```bash
cp assets/locales/base.ln assets/locales/es.ln
cp assets/locales/base.ln assets/locales/ar.ln
```

قم بتحرير كل ملف بالترجمات:

```json
// assets/locales/ar.ln
{
  "ln_name": "العربية",
  "keLn1": "تطبيقي الرائع",
  "keLn2": "مرحبًا بك في Flutter!"
}
```

### ٥. تحديث pubspec.yaml

أضف ملفات اللغة الخاصة بك إلى الأصول (assets):

```yaml
flutter:
  assets:
    - assets/locales/
```

🎉 **تم!** تطبيقك الآن محلي بالكامل!

---

## 🛠️ الاستخدام المتقدم

### مبدل اللغة (Language Switcher)

قم ببناء منتقي لغة جميل بأقل جهد:

```dart
AppBar(
  title: Text('الإعدادات'.toLn()),
  actions: [
    FutureBuilder<List<LocaleInfo>>(
      future: ToLn.getAvailableLocales(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          tooltip: 'تغيير اللغة'.toLn(),
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

### السلاسل الديناميكية مع المتغيرات

يتعامل toLn تلقائيًا مع استيفاء السلسلة (string interpolation):

```dart
final username = "مريم";
final points = 1250;

Text('مرحبًا، $username!'.toLn())
Text('لديك $points نقطة'.toLn())
```

في ملفات الترجمة الخاصة بك، استخدم `$s` كعنصر نائب (placeholder):

```json
{
  "keLn1": "مرحبًا، $s!",
  "keLn2": "لديك $s نقطة"
}
```

الترجمة الإسبانية:

```json
{
  "keLn1": "¡Hola, $s!",
  "keLn2": "Tienes $s puntos"
}
```

### تجاوز المفتاح يدويًا (Manual Key Override)

للحالات النادرة التي تريد فيها نصوصًا مصدرية مختلفة تستخدم نفس الترجمة:

```dart
Text('موافق'.toLn(key: 'confirm'))
Text('تأكيد'.toLn(key: 'confirm'))
```

كلاهما سيستخدم نفس مفتاح الترجمة.

### التكامل مع الويدجتس الشائعة

يعمل toLn بسلاسة مع جميع ويدجتس Flutter:

```dart
// ويدجتس النصوص
Text('نص بسيط'.toLn())
Text('مرحبًا، $name!'.toLn())

// Tooltips
IconButton(
  icon: Icon(Icons.save),
  tooltip: 'حفظ التغييرات'.toLn(),
  onPressed: () {},
)

// SnackBars
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('تم حفظ العنصر بنجاح!'.toLn())),
);

// مربعات الحوار (Dialogs)
AlertDialog(
  title: Text('تأكيد الحذف'.toLn()),
  content: Text('هل أنت متأكد أنك تريد حذف هذا العنصر؟'.toLn()),
  actions: [
    TextButton(
      child: Text('إلغاء'.toLn()),
      onPressed: () => Navigator.pop(context),
    ),
    TextButton(
      child: Text('حذف'.toLn()),
      onPressed: () {},
    ),
  ],
)

// حقول الإدخال
TextField(
  decoration: InputDecoration(
    labelText: 'البريد الإلكتروني'.toLn(),
    hintText: 'أدخل بريدك الإلكتروني'.toLn(),
    helperText: 'لن نشارك بريدك الإلكتروني أبدًا'.toLn(),
  ),
)
```

---

## 🔧 أوامر CLI

### `auto-apply` - إعادة هيكلة تلقائية

قم بتحويل مشروع موجود لاستخدام toLn تلقائيًا:

```bash
dart run toln auto-apply
```

**ما يفعله:**
1. يمسح دليل `lib/` بالكامل.
2. يضيف `.toLn()` إلى النصوص في الويدجتس مثل `Text` و `InputDecoration` وغيرها.
3. يحقن `import 'package:toln/toln.dart';` كلما دعت الحاجة.
4. يهيئ دالة `main()` الخاصة بك مع التهيئة الأولية.
5. يشغل `extract` تلقائيًا.

**وضع التشغيل التجريبي (Dry run)** (رؤية التغييرات دون تعديل الملفات):
```bash
dart run toln auto-apply --dry-run
```

### `extract` - إنشاء ملفات الترجمة

قم بمسح الكود الخاص بك وإنشاء/تحديث ملفات الترجمة:

```bash
dart run toln extract
```

**الميزات:**
- يجد جميع استدعاءات `.toLn()` باستخدام التحليل الثابت.
- ينشئ `base.ln` مع جميع النصوص.
- ينشئ `key_map.ln` للتعيين الداخلي.
- **المساعد الذكي**: يكتشف الأخطاء المطبعية والسلاسل المشابهة، ويقترح إعادة استخدام المفتاح.

### `sync` - مزامنة ملفات الترجمة

أضف المفاتيح المفقودة إلى جميع ملفات اللغة:

```bash
dart run toln sync
```

**ما يفعله:**
- يقارن جميع ملفات `.ln` مع `base.ln`.
- يضيف المفاتيح المفقودة إلى كل ملف لغة.
- يحافظ على الترجمات الموجودة.
- مثالي للحفاظ على تحديث المترجمين.

### `migrate` - من intl/arb إلى toLn

هل لديك مشروع موجود يستخدم `intl` وملفات `.arb`؟ انتقل بسلاسة:

```bash
dart run toln migrate
```

**ما يفعله:**
1. يقرأ تكوين `l10n.yaml` الخاص بك.
2. يحول ملفات `.arb` إلى تنسيق `.ln`.
3. يعيد هيكلة جميع استدعاءات `AppLocalizations.of(context).key` إلى `.toLn()`.
4. يزيل مفوضي الترجمة (delegates) القديمة.
5. ينظف الملفات القديمة بعد النجاح.

---

## 📚 مرجع API

### فئة ToLn

#### `ToLn.init()`

تهيئة نظام الترجمة المحلية.

```dart
static Future<void> init({
  required String baseLocale,
  String? initialLocale,
})
```

**المعلمات:**
- `baseLocale` *(مطلوب)*: لغة الكود المصدري الخاص بك (مثل 'en'، 'ar').
- `initialLocale` *(اختياري)*: لغة البدء. الافتراضي هو لغة الجهاز أو `baseLocale`.

#### `ToLn.loadLocale()`

تغيير اللغة الحالية للتطبيق.

```dart
static Future<void> loadLocale(String newLocale)
```

**المعلمات:**
- `newLocale`: رمز اللغة للتبديل إليها (مثل 'es'، 'ar').

**التأثيرات:**
- يحمل ملف `.ln` المقابل.
- يحدث اتجاه النص.
- يطلق إعادة بناء تلقائية لواجهة المستخدم عبر `localeNotifier`.

#### `ToLn.getAvailableLocales()`

الحصول على جميع اللغات المتاحة في تطبيقك.

```dart
static Future<List<LocaleInfo>> getAvailableLocales()
```

**الإرجاع:** قائمة بسجلات `LocaleInfo`: `({String code, String name})`

**مثال:**
```dart
final locales = await ToLn.getAvailableLocales();
// Result: [(code: 'en', name: 'English'), (code: 'es', name: 'Español')]
```

#### `ToLn.currentDirection`

الحصول على اتجاه النص للغة الحالية.

```dart
static TextDirection get currentDirection
```

**الإرجاع:** `TextDirection.rtl` أو `TextDirection.ltr`

**لغات RTL:** ar, fa, he, ur (يتم اكتشافها تلقائيًا)

#### `ToLn.localeNotifier`

ValueNotifier لتحديثات واجهة المستخدم التفاعلية (Reactive).

```dart
static final ValueNotifier<Locale> localeNotifier
```

**الاستخدام:**
```dart
ValueListenableBuilder<Locale>(
  valueListenable: ToLn.localeNotifier,
  builder: (context, locale, child) {
    return MaterialApp(locale: locale, ...);
  },
)
```

### طرق الامتداد (Extension Methods)

#### `.toLn()`

ترجمة سلسلة نصية.

```dart
extension ToLnExtension on String {
  String toLn({String? key})
}
```

**المعلمات:**
- `key` *(اختياري)*: تجاوز مفتاح الترجمة يدويًا.

**أمثلة:**
```dart
'Hello World'.toLn()                    // مفتاح تلقائي
'Goodbye'.toLn(key: 'farewell')        // مفتاح يدوي
'Welcome, $username!'.toLn()            // مع متغيرات
```

---

## ⚠️ المزالق الشائعة

### مشكلة `const`

**المشكلة:** تتغير اللغة ولكن واجهة المستخدم لا تتحدث.

**السبب:** تخبر الكلمة الأساسية `const` إطار عمل Flutter أن هذا الويدجت لا يعاد بناؤه أبدًا.

**❌ غير صحيح:**
```dart
home: const HomePage(),  // هذا لن يتم تحديثه!
```

**✅ صحيح:**
```dart
home: HomePage(),  // الآن يمكن إعادة بنائه
```

**القاعدة:** قم بإزالة `const` من أي ويدجت يحتوي على نص قابل للترجمة أو أسلافه.

### نسيان إضافة الأصول (Assets)

**المشكلة:** يتعطل التطبيق مع خطأ "Unable to load asset".

**الحل:** أضف ملفات اللغة إلى `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/locales/
```

---

## 🎯 أمثلة من العالم الحقيقي

### بطاقة منتج في متجر إلكتروني

```dart
class ProductCard extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(product.imageUrl),
          Text(product.name),  // موجود بالفعل في قاعدة البيانات الخاصة بك
          Text('${product.price} ريال'),
          ElevatedButton(
            onPressed: () {},
            child: Text('إضافة إلى السلة'.toLn()),
          ),
          Text('شحن مجاني للطلبات التي تزيد عن 500 ريال!'.toLn()),
        ],
      ),
    );
  }
}
```

### التحقق من صحة النموذج

```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'البريد الإلكتروني مطلوب'.toLn();
  }
  if (!value.contains('@')) {
    return 'يرجى إدخال بريد إلكتروني صحيح'.toLn();
  }
  return null;
}

TextField(
  decoration: InputDecoration(
    labelText: 'البريد الإلكتروني'.toLn(),
    errorText: validateEmail(email),
  ),
)
```

### شاشة الإعدادات مع منتقي اللغة

```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text('اللغة'.toLn()),
          subtitle: FutureBuilder<List<LocaleInfo>>(
            future: ToLn.getAvailableLocales(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('جاري التحميل...'.toLn());
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
        title: Text('اختر اللغة'.toLn()),
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

## 🤝 المساهمة

نرحب بالمساهمات! إليك كيف يمكنك المساعدة:

1. **الإبلاغ عن الأخطاء**: [افتح مشكلة](https://github.com/IrMaho/toLn/issues)
2. **اقتراح الميزات**: شارك أفكارك
3. **إرسال PRs**: إصلاح الأخطاء أو إضافة ميزات
4. **تحسين الوثائق**: ساعدنا في جعل الوثائق أفضل
5. **النشر**: ضع نجمة على المستودع ⭐

### إعداد بيئة التطوير

```bash
git clone https://github.com/IrMaho/toLn.git
cd toLn
flutter pub get
dart test
```

---

## 📄 الترخيص

هذا المشروع مرخص بموجب ترخيص MIT - راجع ملف [LICENSE](LICENSE) للحصول على التفاصيل.

---

## 🙏 شكر وتقدير

تم البناء بـ ❤️ بواسطة [شق شهادت](https://github.com/IrMaho)

شكر خاص لـ:
- فريق Flutter على إطار عمل رائع
- فريق Dart analyzer على أدوات AST القوية
- جميع المساهمين والمستخدمين لدينا

---

## 📞 الدعم

- 📧 البريد الإلكتروني: support@example.com
- 💬 مشكلات GitHub: [الإبلاغ عن مشكلة](https://github.com/IrMaho/toLn/issues)
- 📖 الوثائق: [الوثائق الكاملة](https://github.com/IrMaho/toLn/wiki)

---

<p align="center">
  <strong>صُنع بـ ❤️ لمجتمع Flutter</strong>
</p>

<p align="center">
  <a href="https://github.com/IrMaho/toLn">⭐ ضع نجمة على GitHub</a> •
  <a href="https://pub.dev/packages/toln">📦 عرض على pub.dev</a>
</p>

</div>
