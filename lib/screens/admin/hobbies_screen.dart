import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/admin/admin_scaffold.dart';

class AdminHobbiesScreen extends StatelessWidget {
  const AdminHobbiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hobbies = [
      {'id': 1, 'name': 'Science Fiction'},
      {'id': 2, 'name': 'Fantasy'},
      {'id': 3, 'name': 'Historical Fiction'},
      {'id': 4, 'name': 'Astronomy'},
      {'id': 5, 'name': 'Classics'},
      {'id': 6, 'name': 'Poetry'},
      {'id': 7, 'name': 'Mystery'},
      {'id': 8, 'name': 'Thriller'},
      {'id': 9, 'name': 'Romance'},
      {'id': 10, 'name': 'Biography'},
      {'id': 11, 'name': 'History'},
      {'id': 12, 'name': 'Self-Help'},
      {'id': 13, 'name': 'Comics'},
      {'id': 14, 'name': 'Art'},
      {'id': 15, 'name': 'Book Clubs'},
    ];

    return AdminScaffold(
      currentRoute: '/admin/hobbies',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hobby Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View and manage hobbies',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin/hobbies/add');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Hobby'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hobbies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search hobbies...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
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
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(50), // ID column
                    1: FlexColumnWidth(4), // Name column
                    2: FixedColumnWidth(50), // Actions column
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'ID',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Actions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...hobbies.map((hobby) {
                      return TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              hobby['id'].toString(),
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              hobby['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey[600],
                              ),
                              onSelected: (value) {
                                // Handle menu item selection
                                switch (value) {
                                  case 'edit':
                                    // TODO: Implement edit functionality
                                    break;
                                  case 'delete':
                                    // TODO: Implement delete functionality
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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