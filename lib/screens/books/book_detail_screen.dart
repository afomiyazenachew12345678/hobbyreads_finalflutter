import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/shared/app_scaffold.dart';

class BookDetailScreen extends StatefulWidget {
  final String title;
  final String author;
  
  const BookDetailScreen({
    super.key,
    required this.title,
    required this.author,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  double _userRating = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.title,
      currentRoute: '/books/detail',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${widget.author}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ...List.generate(5, (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < 4 ? Colors.amber : Colors.grey[300],
                        )),
                        const SizedBox(width: 8),
                        Text(
                          '4.3',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your rating',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _userRating = index + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          size: 32,
                          color: index < _userRating ? Colors.amber : Colors.grey[300],
                        ),
                      )),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your review (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Share your thoughts about this book...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _userRating = 0;
                              _reviewController.clear();
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _userRating > 0 ? () {
                            // TODO: Implement review submission
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Submit Review'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Example reviews
                    _ReviewItem(
                      username: 'Jhon Smith',
                      handle: '@jhonsmith',
                      rating: 5,
                      review: 'Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived.',
                    ),
                    const SizedBox(height: 16),
                    _ReviewItem(
                      username: 'Jhon Smith',
                      handle: '@jhonsmith',
                      rating: 5,
                      review: 'Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String username;
  final String handle;
  final int rating;
  final String review;

  const _ReviewItem({
    required this.username,
    required this.handle,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Text(
                username[0],
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  handle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) => Icon(
            Icons.star,
            size: 16,
            color: index < rating ? Colors.amber : Colors.grey[300],
          )),
        ),
        const SizedBox(height: 8),
        Text(
          review,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
} 