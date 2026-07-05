import 'package:flutter_test/flutter_test.dart';
import 'package:pet_app/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('password requires minimum length', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('longenough'), isNull);
    });

    test('phone accepts E.164-ish numbers', () {
      expect(Validators.phone('+966501234567'), isNull);
      expect(Validators.phone('abc'), isNotNull);
    });
  });
}
