import 'package:flutter_test/flutter_test.dart';
import 'package:pet_app/core/utils/validators.dart';

void main() {
  test('password validator enforces minimum length', () {
    expect(Validators.password('short'), isNotNull);
    expect(Validators.password('longenough'), isNull);
  });
}
