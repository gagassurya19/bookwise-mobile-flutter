import '../models/book.dart';
// import 'constants.dart';

class DummyData {
  static List<Book> getBooks() {
    return [
      Book(
        id: '1',
        title: 'Atomic Habits',
        author: 'James Clear',
        coverUrl: 'https://m.media-amazon.com/images/I/81wgcld4wxL._AC_UF1000,1000_QL80_.jpg',
        rating: 4.8,
      ),
      Book(
        id: '2',
        title: 'Sapiens: A Brief History of Humankind',
        author: 'Yuval Noah Harari',
        coverUrl: 'https://m.media-amazon.com/images/I/713jIoMO3UL._AC_UF1000,1000_QL80_.jpg',
        rating: 4.7,
      ),
      Book(
        id: '3',
        title: 'The Psychology of Money',
        author: 'Morgan Housel',
        coverUrl: 'https://m.media-amazon.com/images/I/71J3+5lrCDL._AC_UF1000,1000_QL80_.jpg',
        rating: 4.6,
      ),
      Book(
        id: '4',
        title: 'Educated: A Memoir',
        author: 'Tara Westover',
        coverUrl: 'https://m.media-amazon.com/images/I/81NwOj14S6L._AC_UF1000,1000_QL80_.jpg',
        rating: 4.7,
      ),
      Book(
        id: '5',
        title: 'The Alchemist',
        author: 'Paulo Coelho',
        coverUrl: 'https://m.media-amazon.com/images/I/51Z0nLAfLmL.jpg',
        rating: 4.7,
      ),
      Book(
        id: '6',
        title: 'Thinking, Fast and Slow',
        author: 'Daniel Kahneman',
        coverUrl: 'https://m.media-amazon.com/images/I/61fdrEuPJwL._AC_UF1000,1000_QL80_.jpg',
        rating: 4.6,
      ),
    ];
  }

  static List<Book> getCurrentlyReadingBooks() {
    return [
      Book(
        id: '1',
        title: 'Atomic Habits',
        author: 'James Clear',
        coverUrl: 'https://m.media-amazon.com/images/I/81wgcld4wxL._AC_UF1000,1000_QL80_.jpg',
        rating: 4.8,
        progress: 65,
      ),
      Book(
        id: '3',
        title: 'The Psychology of Money',
        author: 'Morgan Housel',
        coverUrl: 'https://m.media-amazon.com/images/I/71J3+5lrCDL._AC_UF1000,1000_QL80_.jpg',
        rating: 4.6,
        progress: 30,
      ),
    ];
  }

  static List<Book> getFinishedBooks() {
    return [
      Book(
        id: '2',
        title: 'Sapiens: A Brief History of Humankind',
        author: 'Yuval Noah Harari',
        coverUrl: 'https://m.media-amazon.com/images/I/713jIoMO3UL._AC_UF1000,1000_QL80_.jpg',
        rating: 4.7,
        progress: 100,
      ),
      Book(
        id: '5',
        title: 'The Alchemist',
        author: 'Paulo Coelho',
        coverUrl: 'https://m.media-amazon.com/images/I/51Z0nLAfLmL.jpg',
        rating: 4.7,
        progress: 100,
      ),
    ];
  }
}

