void main() {
  List<int> numbers = [10, 20, 30];
  numbers.add(40);
  numbers.remove(10);
  print("Updated List: $numbers");
  print("Second item (index 1): ${numbers[1]}");

  Set<String> fruits = {"apple", "banana", "apple"};
  print("Unique Set elements: $fruits");

  Map<String, dynamic> student = {'name': 'Alex', 'grade': 'A'};
  student['age'] = 20;
  print("Student Map: $student");

  int parsedInt = int.parse("123");
  print("Parsed Integer: $parsedInt (Type: ${parsedInt.runtimeType})");

  double decimalNumber = 45.67;
  String formattedString = decimalNumber.toStringAsFixed(1);
  print("Formatted String (1 decimal): $formattedString");
}
