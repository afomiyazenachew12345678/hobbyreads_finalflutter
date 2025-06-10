import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/admin/admin_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      currentRoute: '/admin',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monitor and manage your HobbyReads platform',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _StatCard(
                    title: 'Total Users',
                    count: 125,
                    newCount: 18,
                    icon: Icons.people_outline,
                  ),
                  const SizedBox(height: 16),
                  _StatCard(
                    title: 'Total Hobbies',
                    count: 10,
                    newCount: 5,
                    icon: Icons.category_outlined,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final int newCount;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.count,
    required this.newCount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: Colors.green[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$newCount new this month',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              size: 48,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
} 