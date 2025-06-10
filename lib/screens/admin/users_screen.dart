import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/admin/admin_scaffold.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {
        'username': '@janedoe',
        'name': 'Jane Doe',
        'email': 'jane@.com',
        'role': 'Admin',
        'joined': '1/15/2023',
      },
      {
        'username': '@johnsmith',
        'name': 'Jon Smith',
        'email': 'jon@.com',
        'role': 'User',
        'joined': '2/20/2023',
      },
      {
        'username': '@alexj',
        'name': 'Alex John',
        'email': 'alex@.com',
        'role': 'User',
        'joined': '3/10/2023',
      },
      {
        'username': '@maxaelc',
        'name': 'Max Chen',
        'email': 'max@.com',
        'role': 'User',
        'joined': '4/5/2023',
      },
      {
        'username': '@jekichun',
        'name': 'Jack Tim',
        'email': 'tim@.com',
        'role': 'User',
        'joined': '9/7/2023',
      },
      {
        'username': '@markfin',
        'name': 'Mark Lim',
        'email': 'mrk@.com',
        'role': 'User',
        'joined': '5/9/2023',
      },
    ];

    return AdminScaffold(
      currentRoute: '/admin/users',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'View and manage user accounts',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage user accounts and permissions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users by name, username, email...',
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
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Role',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Joined',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: users.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(Text(user['username'])),
                        DataCell(Text(user['name'])),
                        DataCell(Text(user['email'])),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: user['role'] == 'Admin'
                                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user['role'],
                              style: TextStyle(
                                color: user['role'] == 'Admin'
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(user['joined'])),
                        DataCell(
                          PopupMenuButton<String>(
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 