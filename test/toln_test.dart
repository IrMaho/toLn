import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toln/toln.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const baseLocale = 'en';
  const faLocale = 'fa';

  final mockBaseTranslations = {
    'ln_name': 'English',
    'keLn1': 'Hello',
    'keLn2': 'Welcome, \$s!',
  };

  final mockFaTranslations = {
    'ln_name': 'فارسی',
    'keLn1': 'سلام',
    'keLn2': 'خوش آمدید، \$s!',
  };

  final mockKeyMap = {
    'Hello': 'keLn1',
    'Welcome, \$s!': 'keLn2',
  };

  setUp(() {
    // Clear any previous interactions
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);

    // Mock asset loading
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final String path = utf8.decode(message!.buffer.asUint8List());

      if (path == 'assets/locales/key_map.ln') {
        return ByteData.view(
            Uint8List.fromList(utf8.encode(json.encode(mockKeyMap))).buffer);
      }
      if (path == 'assets/locales/base.ln') {
        return ByteData.view(
            Uint8List.fromList(utf8.encode(json.encode(mockBaseTranslations)))
                .buffer);
      }
      if (path == 'assets/locales/fa.ln') {
        return ByteData.view(
            Uint8List.fromList(utf8.encode(json.encode(mockFaTranslations)))
                .buffer);
      }
      if (path == 'AssetManifest.json') {
        final manifest = {
          'assets/locales/base.ln': ['assets/locales/base.ln'],
          'assets/locales/fa.ln': ['assets/locales/fa.ln'],
          'assets/locales/key_map.ln': ['assets/locales/key_map.ln'],
        };
        return ByteData.view(
            Uint8List.fromList(utf8.encode(json.encode(manifest))).buffer);
      }
      // Return null for other assets (like AssetManifest.bin) to trigger fallback
      return null;
    });
  });

  test('ToLn initialization loads base locale correctly', () async {
    await ToLn.init(baseLocale: baseLocale);
    expect(ToLn.localeNotifier.value.languageCode, baseLocale);
    expect(ToLn.currentDirection, TextDirection.ltr);
  });

  test('ToLn loads new locale correctly', () async {
    await ToLn.init(baseLocale: baseLocale);
    await ToLn.loadLocale(faLocale);

    expect(ToLn.localeNotifier.value.languageCode, faLocale);
    expect(ToLn.currentDirection, TextDirection.rtl);
  });

  test('ToLn.getAvailableLocales returns correct list', () async {
    await ToLn.init(baseLocale: baseLocale);
    final locales = await ToLn.getAvailableLocales();

    expect(locales.length, 2);
    expect(locales.any((l) => l.code == 'en' && l.name == 'English'), isTrue);
    expect(locales.any((l) => l.code == 'fa' && l.name == 'فارسی'), isTrue);
  });
}
