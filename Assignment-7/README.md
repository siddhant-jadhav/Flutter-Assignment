# Flutter 3-Screen Registration App

A Flutter app demonstrating **named-route navigation, form validation, data passing between screens, and session-based profile display**.

## Features

* 3-screen navigation: Home → Registration → Details
* Named routes with `Navigator.pushNamed()`
* Registration form with validation
* Email, phone, password, and confirm-password validation
* Role selection and Terms & Conditions checkbox
* Passes user data using route arguments
* Displays registered user profile details
* Reset and navigation controls
* Uses `SessionStore` to retain the last registered user

## Concepts Used

* `StatelessWidget` & `StatefulWidget`
* `MaterialApp` named routes
* `Navigator.pushNamed()` / `popUntil()`
* `Form` and `GlobalKey<FormState>`
* `TextEditingController`
* Form validation & Regex
* `setState()`
* `ModalRoute.of(context)` arguments

## How to Run

```bash
flutter pub get
flutter run
```

## Author

**Siddhant Jadhav**
