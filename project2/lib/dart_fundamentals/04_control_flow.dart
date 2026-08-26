void main() {
  int score = 85;
  String grade;
  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else if (score >= 70) {
    grade = 'C';
  } else {
    grade = 'F';
  }
  print("Score: $score => Grade: $grade");

  Object shape = (10, 20);
  switch (shape) {
    case (int w, int h):
      print('Rectangle $w x $h');
    default:
      print('Unknown shape');
  }

  List<String> items = ['A', 'B', 'C'];
  for (int i = 0; i < items.length; i++) {
    print("Standard for index $i: ${items[i]}");
  }

  for (var item in items) {
    print("For-in item: $item");
  }

  int whileCount = 1;
  while (whileCount <= 3) {
    print("While loop count: $whileCount");
    whileCount++;
  }

  int doCount = 1;
  do {
    print("Do-while executed with count: $doCount");
    doCount++;
  } while (doCount <= 1);

  for (int i = 1; i <= 10; i++) {
    if (i == 5) {
      continue;
    }
    if (i == 8) {
      break;
    }
    print("Loop number: $i");
  }

  int speed = 50;
  assert(speed <= 100, "Speed limit exceeded");
  print("Assert verified: speed ($speed) <= 100");
}
