# Dart Asynchronous User Data Fetching

A simple Dart program that demonstrates **asynchronous programming** using `Future`, `async`, `await`, `Future.delayed()`, null safety, and exception handling.

The program simulates fetching user data from a server and handles three different situations:

* User data is successfully found.
* No user data is available.
* A server connection error occurs.

## Features

* Simulates an API/server request.
* Uses `Future` for asynchronous operations.
* Uses `async` and `await` to handle asynchronous code.
* Demonstrates nullable return values using `String?`.
* Handles exceptions using `try-catch`.
* Uses `finally` to execute code after every request.
* Demonstrates different results based on the user ID.

## Concepts Used

### 1. Future

`Future` represents a value that will be available at some point in the future.

```dart
Future<String?> fetchUserData(int id)
```

The function returns a `Future` that will eventually contain either a `String` or `null`.

### 2. async

The `async` keyword allows a function to perform asynchronous operations.

```dart
Future<String?> fetchUserData(int id) async {
```

The `main()` function is also asynchronous:

```dart
Future<void> main() async {
```

### 3. await

The `await` keyword waits for an asynchronous operation to complete before continuing.

```dart
String? userData = await fetchUserData(id);
```

This makes the asynchronous code easier to read because it executes in a sequential-looking manner.

### 4. Future.delayed()

The program uses `Future.delayed()` to simulate a server response that takes two seconds.

```dart
await Future.delayed(Duration(seconds: 2));
```

This is useful for simulating API calls, database operations, or other tasks that take time.

### 5. Null Safety

The return type is:

```dart
Future<String?>
```

The `?` means that the returned `String` can be `null`.

For example, when `id == 2`:

```dart
return null;
```

The program checks for this condition:

```dart
if (userData == null) {
  print("Result: No data found for this ID!");
}
```

### 6. Exception Handling

If the ID is not `1` or `2`, the function throws an exception:

```dart
throw Exception("Server connection failed!");
```

The exception is handled using `try-catch`:

```dart
try {
  // Code that may cause an error
} catch (error) {
  print("Error: $error");
}
```

### 7. finally

The `finally` block runs whether the request succeeds or fails.

```dart
finally {
  print("Done checking for ID: $id\n");
}
```

This can be useful for cleanup operations or displaying the completion status of an operation.

## Program Flow

The program checks three user IDs:

| User ID | Result                    |
| ------- | ------------------------- |
| `1`     | User data is returned     |
| `2`     | No data is found (`null`) |
| `3`     | Server connection error   |

### ID 1

The function returns:

```text
User: siddhant jadhav, Email: siddhant@example.com
```

### ID 2

The function returns `null`, so the program displays:

```text
Result: No data found for this ID!
```

### ID 3

The function throws an exception:

```text
Server connection failed!
```

The error is caught and displayed.

## Expected Output

```text
Fetching user 1...
Starting request for ID: 1
Fetching data from server...
Result: User: siddhant jadhav, Email: siddhant@example.com
Done checking for ID: 1

Fetching user 2...
Starting request for ID: 2
Fetching data from server...
Result: No data found for this ID!
Done checking for ID: 2

Fetching user 3...
Starting request for ID: 3
Fetching data from server...
Error: Exception: Server connection failed!
Done checking for ID: 3
```

> Each request takes approximately 2 seconds because of the simulated server delay.

## Functions

### `fetchUserData()`

```dart
Future<String?> fetchUserData(int id)
```

This function simulates fetching user information from a server.

It can:

* Return user data.
* Return `null`.
* Throw an exception.

### `displayUserData()`

```dart
Future<void> displayUserData(int id)
```

This function calls `fetchUserData()` and handles its result using `try-catch-finally`.

### `main()`

```dart
Future<void> main() async
```

The `main()` function calls `displayUserData()` for IDs `1`, `2`, and `3`.

## Project Structure

```text
dart_async_demo/
│
├── main.dart
└── README.md
```

## Requirements

* Dart SDK
* Visual Studio Code, Android Studio, or another Dart-compatible IDE

## How to Run

1. Install the Dart SDK.
2. Create a Dart project.
3. Save the program as `main.dart`.
4. Open the terminal in the project directory.
5. Run:

```bash
dart run
```

## Learning Outcomes

After completing this program, you will understand:

* How asynchronous programming works in Dart.
* How to use `Future`.
* How to use `async` and `await`.
* How to simulate delayed operations.
* How nullable values are handled.
* How to throw and catch exceptions.
* How `finally` works.
* How asynchronous functions can be called sequentially.

## Author

**Siddhant Jadhav**

## License

This project is created for educational and learning purposes.
