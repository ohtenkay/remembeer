const minPasswordLength = 8;

bool isPasswordValid(String password) {
  return password.length >= minPasswordLength &&
      password.contains(RegExp('[A-Z]')) &&
      password.contains(RegExp('[a-z]')) &&
      password.contains(RegExp('[0-9]'));
}
