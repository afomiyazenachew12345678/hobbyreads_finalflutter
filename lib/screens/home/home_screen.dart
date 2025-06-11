import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_reads_flutter/screens/shared/app_scaffold.dart';
import 'package:hobby_reads_flutter/providers/auth_providers.dart';
import 'package:hobby_reads_flutter/providers/book_providers.dart';
import 'package:hobby_reads_flutter/providers/connection_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(booksProvider.notifier).loadBooks(refresh: true);
      // Load connections if user is authenticated
      if (ref.read(isAuthenticatedProvider)) {
        ref.read(myConnectionsProvider.notifier).loadConnections();
      }
    });
  }

  // Refresh data when screen comes back into focus
  void _refreshData() {
    ref.read(booksProvider.notifier).loadBooks(refresh: true);
    if (ref.read(isAuthenticatedProvider)) {
      ref.read(myConnectionsProvider.notifier).loadConnections();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final booksState = ref.watch(booksProvider);
    final connectionsCount = ref.watch(connectionsCountProvider);
    final connectionsState = ref.watch(myConnectionsProvider);

    return AppScaffold(
      title: 'Dashboard',
      currentRoute: '/home',
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${user?.name ?? 'Reader'}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Here\'s what\'s happening with your reading community.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // All Books Card
                    _DashboardCard(
                      title: 'Available Books',
                      count: booksState.books.length.toString(),
                      subtitle: 'books in the community',
                      icon: Icons.menu_book,
                      onActionPressed: () => Navigator.pushNamed(context, '/books'),
                      actionLabel: 'View All',
                      isLoading: booksState.isLoading,
                    ),
                    const SizedBox(height: 16),
                    
                    // Recommended Books Card (showing available books count for now)
                    _DashboardCard(
                      title: 'Recommended',
                      count: booksState.books.isEmpty ? '0' : '${(booksState.books.length * 0.3).round()}',
                      subtitle: 'books for you',
                      icon: Icons.recommend,
                      onActionPressed: () => Navigator.pushNamed(context, '/books'),
                      actionLabel: 'Explore',
                      isLoading: booksState.isLoading,
                    ),
                    const SizedBox(height: 16),
                    
                    // Connections Card
                    _DashboardCard(
                      title: 'Connections',
                      count: connectionsState.error != null ? '0' : connectionsCount.toString(),
                      icon: Icons.people_outline,
                      onActionPressed: () => Navigator.pushNamed(context, '/connections'),
                      actionLabel: 'View All',
                      isLoading: connectionsState.isLoading,
                      error: connectionsState.error,
                    ),
                    const SizedBox(height: 16),
                    
                    // Trade Requests Card
                    _DashboardCard(
                      title: 'Trade Requests',
                      count: '0',
                      subtitle: 'pending requests',
                      icon: Icons.swap_horiz_outlined,
                      onActionPressed: () => Navigator.pushNamed(context, '/trades'),
                      actionLabel: 'Respond',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String count;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onActionPressed;
  final String actionLabel;
  final bool isLoading;
  final String? error;

  const _DashboardCard({
    required this.title,
    required this.count,
    this.subtitle,
    required this.icon,
    required this.onActionPressed,
    required this.actionLabel,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                icon,
                size: 24,
                color: error != null ? Colors.red : Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          isLoading
              ? const SizedBox(
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  count,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: error != null ? Colors.red : null,
                  ),
                ),
          if (subtitle != null && error == null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[600],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: TextButton(
              onPressed: onActionPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
} 