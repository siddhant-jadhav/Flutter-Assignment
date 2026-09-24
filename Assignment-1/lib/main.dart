// Simple Library System

// Parent class
class Book {
  String title;
  String author;

  Book(this.title, this.author);

  void showBook() {
    print("Title: $title");
    print("Author: $author");
  }
}

// Child class
class EBook extends Book {
  double size;

  EBook(String title, String author, this.size) : super(title, author);

  void showEBook() {
    showBook();
    print("Size: $size MB");
  }
}

// Function to display all books
void showAllBooks(List<Book> books) {
  for (var book in books) {
    book.showBook();
  }
}

void main() {
  // Variables
  String libraryName = "My Simple Library";

  print(libraryName);

  // Creating objects
  Book book1 = Book("Harry Potter", "J.K. Rowling");
  Book book2 = Book("The Alchemist", "Paulo Coelho");

  EBook book3 = EBook("Dart Programming", "John Smith", 5.5);

  // List of books
  List<Book> books = [book1, book2, book3];

  // Loop
  showAllBooks(books);

  // Function call
  print("E-Book Details:");
  book3.showEBook();
}
