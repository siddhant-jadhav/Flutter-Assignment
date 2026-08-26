class Student {
  String name = '';
  int score = 0;
  void display() => print('$name scored $score');
}

void main() {
  int modResult = 17 % 4;
  int intDivResult = 17 ~/ 4;
  print("Modulus (17 % 4): $modResult");
  print("Integer Division (17 ~/ 4): $intDivResult");

  bool isGreaterOrEqual = 10 >= 10;
  print("Comparison (10 >= 10): $isGreaterOrEqual");

  dynamic val = "Dart Language";
  if (val is String) {
    print("Type Test: val is a String");
  }
  if (val is! int) {
    print("Type Test: val is! int");
  }

  String castedString = val as String;
  print("String length after casting: ${castedString.length}");

  bool hasTicket = true;
  bool hasId = false;
  bool canEnter = hasTicket && hasId;
  print("Logical AND (hasTicket && hasId): $canEnter");

  String status = hasTicket ? "Allowed" : "Denied";
  print("Ternary status: $status");

  Student()
    ..name = 'John'
    ..score = 95
    ..display();

  Student? nullableStudent;
  nullableStudent
    ?..name = 'Jane'
    ..score = 88
    ..display();
  print("Executed null-aware cascade on null object safely.");
}
