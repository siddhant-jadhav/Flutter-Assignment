class UserProfile {
  late String bio;

  void initBio() {
    bio = "Developer from NYC";
  }
}

Never throwFatalError(String msg) {
  throw Exception("Fatal Error: $msg");
}

void main() {
  UserProfile user = UserProfile();
  user.initBio();
  print("User Bio (late initialized): ${user.bio}");

  int nonNullable = 10;
  int? nullableVal;
  print("nonNullable: $nonNullable, nullableVal: $nullableVal");

  int result = nullableVal ?? 0;
  print("Result using ?? operator: $result");
  nullableVal ??= 5;
  print("nullableVal after ??= operator: $nullableVal");

  String? text;
  print("Null-aware access (?.) when text is null: ${text?.length}");

  text = "Dart";
  print("Bang operator (!) on text: ${text.length}");

  Object data = "Smart Cast";
  if (data is String) {
    print("Promoted String: ${data.toUpperCase()}");
  }
}
