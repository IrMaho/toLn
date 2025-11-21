import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:toln/toln.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const baseLocale = 'en';
  const faLocale = 'fa';

  final mockBaseTranslations = {
    'keLn1': 'Hello',
    'keLn2': 'Welcome, \$s!',
    'confirm': 'Confirm',
  };

  final mockFaTranslations = {
    'keLn1': 'سلام',
    'keLn2': 'خوش آمدید، \$s!',
    'confirm': 'تایید',
  };

  final mockKeyMap = {
    'Hello': 'keLn1',
    'Welcome, \$s!': 'keLn2',
  };

  setUp(() async {
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
      return null;
    });

    await ToLn.init(baseLocale: baseLocale);
  });

  test('toLn() translates simple string', () async {
    await ToLn.loadLocale(faLocale);
    expect('Hello'.toLn(), 'سلام');
  });

  test('toLn() handles dynamic strings', () async {
    await ToLn.loadLocale(faLocale);
    expect('Welcome, Ali!'.toLn(), 'خوش آمدید، Ali!');
  });

  test('toLn() supports manual key override', () async {
    await ToLn.loadLocale(faLocale);
    expect('Any Text'.toLn(key: 'confirm'), 'تایید');
  });

  test('toLn() returns original text if no translation found', () async {
    await ToLn.loadLocale(faLocale);
    expect('Unknown Text'.toLn(), 'Unknown Text');
  });
}
