import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/shared/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dashboard',
      currentRoute: '/home',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back, janedoe!',
                    style: TextStyle(
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
                  
                  // My Books Card
                  _DashboardCard(
                    title: 'My Books',
                    count: '12',
                    subtitle: 'available for trade',
                    icon: Icons.menu_book,
                    onActionPressed: () => Navigator.pushNamed(context, '/books'),
                    actionLabel: 'View All',
                  ),
                  const SizedBox(height: 16),
                  
                  // Connections Card
                  _DashboardCard(
                    title: 'Connections',
                    count: '8',
                    icon: Icons.people_outline,
                    onActionPressed: () => Navigator.pushNamed(context, '/connections'),
                    actionLabel: 'View All',
                  ),
                  const SizedBox(height: 16),
                  
                  // Trade Requests Card
                  _DashboardCard(
                    title: 'Trade Requests',
                    count: '3',
                    subtitle: 'available for trade',
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

  const _DashboardCard({
    required this.title,
    required this.count,
    this.subtitle,
    required this.icon,
    required this.onActionPressed,
    required this.actionLabel,
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
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
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