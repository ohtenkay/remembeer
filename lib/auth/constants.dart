import 'package:diacritic/diacritic.dart';

const minPasswordLength = 8;

bool isPasswordValid(String password) {
  final normalized = removeDiacritics(password);
  return password.length >= minPasswordLength &&
      normalized.contains(RegExp('[A-Z]')) &&
      normalized.contains(RegExp('[a-z]')) &&
      normalized.contains(RegExp('[0-9]'));
}
