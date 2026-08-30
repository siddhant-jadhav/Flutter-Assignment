Future<String?> fetchUserData(int id) async {
  print("Fetching data from server...");
  await Future.delayed(Duration(seconds: 2));

  if (id == 1) {
    return "User: siddhant jadhav, Email: siddhant@example.com";
  } else if (id == 2) {
    return null;
  } else {
    throw Exception("Server connection failed!");
  }
}

Future<void> displayUserData(int id) async {
  try {
    print("Starting request for ID: $id");
    String? userData = await fetchUserData(id);

    if (userData == null) {
      print("Result: No data found for this ID!");
    } else {
      print("Result: $userData");
    }
  } catch (error) {
    print("Error: $error");
  } finally {
    print("Done checking for ID: $id\n");
  }
}

Future<void> main() async {
  print("Fetching user 1...");
  await displayUserData(1);

  print("Fetching user 2...");
  await displayUserData(2);

  print("Fetching user 3...");
  await displayUserData(3);
}
