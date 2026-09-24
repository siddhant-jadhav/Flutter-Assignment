# Simple Library System

A basic **Library Management System in Dart** that demonstrates important Object-Oriented Programming (OOP) concepts such as **classes, inheritance, constructors, objects, lists, loops, and functions**.

## Features

* Create and store book details.
* Display book title and author.
* Create E-Books with additional file-size information.
* Demonstrate inheritance using `EBook extends Book`.
* Store different types of books in a single `List<Book>`.
* Display all books using a function and loop.

## OOP Concepts Used

### 1. Class

The `Book` class represents a book in the library.

```dart
class Book {
  String title;
  String author;
}
```

### 2. Constructor

The constructor is used to initialize the book's title and author.

```dart
Book(this.title, this.author);
```

### 3. Inheritance

The `EBook` class inherits properties and methods from the `Book` class.

```dart
class EBook extends Book
```

This allows `EBook` to use the `showBook()` method from the parent class.

### 4. `super` Keyword

The `super` keyword calls the constructor of the parent `Book` class.

```dart
EBook(String title, String author, this.size)
    : super(title, author);
```

### 5. Objects

Objects are created from the `Book` and `EBook` classes.

```dart
Book book1 = Book("Harry Potter", "J.K. Rowling");
Book book2 = Book("The Alchemist", "Paulo Coelho");

EBook book3 = EBook("Dart Programming", "John Smith", 5.5);
```

### 6. List

Different book objects are stored together using a `List<Book>`.

```dart
List<Book> books = [book1, book2, book3];
```

Since `EBook` is a child of `Book`, an `EBook` object can also be stored in this list.

### 7. Functions

The `showAllBooks()` function displays information about every book.

```dart
void showAllBooks(List<Book> books) {
  for (var book in books) {
    book.showBook();
  }
}
```

## Project Structure

```text
simple_library/
│
├── main.dart
└── README.md
```

## Requirements

* Dart SDK
* Any Dart-compatible IDE such as:

  * Visual Studio Code
  * Android Studio
  * IntelliJ IDEA

## How to Run

1. Install the Dart SDK.
2. Create a Dart project.
3. Save the code in `main.dart`.
4. Open the terminal in the project directory.
5. Run:

```bash
dart run
```

## Expected Output

```text
My Simple Library
Title: Harry Potter
Author: J.K. Rowling
Title: The Alchemist
Author: Paulo Coelho
Title: Dart Programming
Author: John Smith
E-Book Details:
Title: Dart Programming
Author: John Smith
Size: 5.5 MB
```

## Classes

### Book

The `Book` class contains:

| Property/Method | Description               |
| --------------- | ------------------------- |
| `title`         | Stores the book title     |
| `author`        | Stores the author's name  |
| `showBook()`    | Displays book information |

### EBook

The `EBook` class extends `Book` and adds:

| Property/Method | Description                    |
| --------------- | ------------------------------ |
| `size`          | Stores the E-Book size in MB   |
| `showEBook()`   | Displays book details and size |

## Learning Outcomes

After completing this program, you can understand:

* How to create classes and objects in Dart.
* How constructors work.
* How inheritance is implemented.
* How the `super` keyword is used.
* How lists can store objects.
* How functions and loops work with objects.
* Basic Object-Oriented Programming concepts in Dart.

## Author

**Siddhant Jadhav**

## License

This project is created for educational and learning purposes.
