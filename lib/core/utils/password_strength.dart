/// Qualitative password strength buckets.
enum PasswordStrength { empty, weak, fair, good, strong }

/// Computes a [PasswordStrength] from simple heuristics: length plus the
/// variety of character classes present (lower, upper, digit, symbol).
abstract final class PasswordStrengthEvaluator {
  PasswordStrengthEvaluator._();

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return PasswordStrength.empty;

    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;

    if (score <= 1) return PasswordStrength.weak;
    if (score == 2) return PasswordStrength.fair;
    if (score == 3) return PasswordStrength.good;
    return PasswordStrength.strong;
  }
}
