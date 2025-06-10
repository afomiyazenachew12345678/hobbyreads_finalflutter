import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/books/book_detail_screen.dart';
import 'package:hobby_reads_flutter/screens/shared/app_scaffold.dart';

class Book {
  final String title;
  final String author;
  final String description;
  final double rating;

  const Book({
    required this.title,
    required this.author,
    required this.description,
    required this.rating,
  });
}

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book> books = [
      const Book(
        title: 'The Midnight Library',
        author: 'Matt Haig',
        description: 'Between life and death there is a library, and within that library, the shelves go on forever.',
        rating: 4.3,
      ),
      const Book(
        title: 'The Night Fall',
        author: 'Matt Haig',
        description: 'Between life and death there is a library, and within that library, the shelves go on forever.',
        rating: 4.3,
      ),
      const Book(
        title: 'The Night Fall',
        author: 'Matt Haig',
        description: 'Between life and death there is a library, and within that library, the shelves go on forever.',
        rating: 4.3,
      ),
    ];

    return AppScaffold(
      title: 'Books',
      currentRoute: '/books',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Books',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Browse and manage your book collection.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/add-book'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Book'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SearchBar(
                  hintText: 'Search by title or author...',
                  leading: const Icon(Icons.search),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(
                          title: book.title,
                          author: book.author,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'by ${book.author}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                book.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    book.rating.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 