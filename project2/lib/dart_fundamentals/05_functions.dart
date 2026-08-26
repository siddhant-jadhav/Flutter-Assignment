void buildUser(String id, {required String username, String role = "guest"}) {
  print('ID: $id, User: $username, Role: $role');
}

int square(int n) => n * n;

void executeAction(Function action) {
  action();
}

Function makeAdder(int addBy) {
  return (int i) => i + addBy;
}

void main() {
  buildUser("U101", username: "alice");
  buildUser("U102", username: "bob", role: "admin");

  print("Square of 6: ${square(6)}");

  executeAction(() => print("Executing..."));

  var add5 = makeAdder(5);
  int result = add5(10);
  print("add5(10) result: $result");
}
