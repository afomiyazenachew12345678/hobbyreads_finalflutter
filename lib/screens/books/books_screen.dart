import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_reads_flutter/data/model/book_model.dart';
import 'package:hobby_reads_flutter/providers/auth_providers.dart';
import 'package:hobby_reads_flutter/providers/book_providers.dart';
import 'package:hobby_reads_flutter/providers/trade_providers.dart';
import 'package:hobby_reads_flutter/screens/books/add_book_screen.dart';
import 'package:hobby_reads_flutter/screens/books/book_detail_screen.dart';
import 'package:hobby_reads_flutter/screens/shared/app_scaffold.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load books when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(booksProvider.notifier).loadBooks(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      ref.read(booksProvider.notifier).loadBooks(refresh: true);
    } else {
      ref.read(booksProvider.notifier).searchBooks(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    // Listen for trade request feedback
    ref.listen<TradeRequestsState>(pendingTradeRequestsProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: Colors.green),
        );
        ref.read(pendingTradeRequestsProvider.notifier).clearMessages();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
        ref.read(pendingTradeRequestsProvider.notifier).clearMessages();
      }
    });

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
                const Text(
                  'Books',
                  style: TextStyle(
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
                  controller: _searchController,
                  hintText: 'Search by title or author...',
                  leading: const Icon(Icons.search),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: _onSearch,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildBooksList(booksState),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksList(BooksState booksState) {
    if (booksState.isLoading && booksState.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (booksState.error != null && booksState.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Error loading books', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(booksState.error!, style: TextStyle(fontSize: 14, color: Colors.grey[500]), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(booksProvider.notifier).loadBooks(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (booksState.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No books found', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Try adjusting your search or add some books', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.read(booksProvider.notifier).loadBooks(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: booksState.books.length,
        itemBuilder: (context, index) {
          final book = booksState.books[index];
          final user = ref.watch(userProvider);
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailScreen(
                        bookId: book.id ?? 0,
                        book: book,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image: book.coverImage != null
                              ? DecorationImage(image: NetworkImage(book.coverImage!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: book.coverImage == null
                            ? Center(child: Icon(Icons.book, size: 48, color: Colors.grey[400]))
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.displayTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('by ${book.displayAuthor}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            if (book.description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(book.description, style: const TextStyle(fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (book.genre != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(book.displayGenre, style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
                                  ),
                                  const Spacer(),
                                ],
                                if (book.ownerName != null) ...[
                                  Text('by ${book.ownerName}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                ] else if (book.createdAt != null) ...[
                                  Text('Added ${book.createdAt!.year}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Trade Request Button Section
                if (_shouldShowTradeButton(book, user))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: _buildTradeRequestButton(book, user),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _shouldShowTradeButton(dynamic book, dynamic user) {
    // Don't show if user is not authenticated
    if (user == null) return false;
    
    // Don't show if this is the user's own book
    if (book.ownerId != null && book.ownerId.toString() == user.id) return false;
    
    // Only show for books available for trade
    return book.status == BookModel.statusAvailableForTrade;
  }

  Widget _buildTradeRequestButton(dynamic book, dynamic user) {
    final tradeState = ref.watch(pendingTradeRequestsProvider);
    final isCreatingRequest = tradeState.isLoading;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isCreatingRequest ? null : () => _showTradeRequestDialog(book),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
          side: BorderSide(color: Theme.of(context).primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: isCreatingRequest 
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : const Icon(Icons.swap_horiz, size: 18),
        label: Text(
          isCreatingRequest ? 'Sending...' : 'Request Trade',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  void _showTradeRequestDialog(dynamic book) {
    final messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Trade Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  const TextSpan(text: 'Send a trade request for '),
                  TextSpan(
                    text: '"${book.displayTitle}"',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' to ${book.ownerName ?? "the owner"}?'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a message (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendTradeRequest(book, messageController.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _sendTradeRequest(dynamic book, String message) {
    if (book.id != null) {
      ref.read(pendingTradeRequestsProvider.notifier).createTradeRequest(
        bookId: book.id.toString(),
        message: message.isNotEmpty ? message : null,
      );
    }
  }
} 