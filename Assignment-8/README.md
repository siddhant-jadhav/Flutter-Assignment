# Flutter REST API & Cache App

A Flutter app that fetches posts from the **JSONPlaceholder REST API**, displays them using `FutureBuilder`, and stores data locally with `SharedPreferences` for offline access.

## Features

* Fetch posts from REST API
* Local caching with SharedPreferences
* Offline mode with cache fallback
* Search posts by title or body
* Filter posts by user
* Pull-to-refresh and force refresh
* Clear cached data
* Loading, error, empty, and success states
* View complete post details in a bottom sheet

## Concepts Used

* REST API & HTTP GET
* JSON parsing and serialization
* `FutureBuilder`
* `async` / `await`
* `SharedPreferences`
* Repository/Service layer
* `StatefulWidget` and `setState()`
* Search and filtering
* Error handling and offline fallback

## Dependencies

```yaml
http
shared_preferences
```

## How to Run

```bash
flutter pub get
flutter run
```

## Author

**Siddhant Jadhav**
