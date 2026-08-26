void main() {
  var cityName = "Tokyo";
  print("City: $cityName, Type: ${cityName.runtimeType}");

  Object objVal = 42;
  print("objVal: $objVal");

  dynamic dynVal = "Hello";
  dynVal = 100;
  try {
    dynVal.toUpperCase();
  } catch (e) {
    print("Caught runtime error when calling .toUpperCase() on dynamic int: $e");
  }

  final DateTime currentDateTime = DateTime.now();
  print("Current DateTime (final): $currentDateTime");

  const double pi = 3.14159;
  print("Pi (const): $pi");

  int age = 25;
  double temperature = 98.6;
  double divisionResult = temperature / age;
  print("Division (temperature / age): $divisionResult");

  String firstName = "Ada";
  String lastName = "Lovelace";
  String fullName = "$firstName $lastName";
  String userMessage = "User: $fullName (Length: ${fullName.length})";
  print(userMessage);

  bool isLoggedIn = false;
  isLoggedIn = !isLoggedIn;
  print("isLoggedIn toggled: $isLoggedIn");

  String emoji = '🎯';
  print("Emoji: $emoji");
  print("Code units (UTF-16): ${emoji.codeUnits}");
  print("Runes (UTF-32): ${emoji.runes.toList()}");
}
