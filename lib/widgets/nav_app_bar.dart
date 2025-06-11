import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_reads_flutter/providers/auth_providers.dart';

class NavAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String currentRoute;

  const NavAppBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 8,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                color: Theme.of(context).primaryColor,
                size: 22,
              ),
              const SizedBox(width: 18),
              _NavLink(
                title: 'Dashboard',
                isSelected: currentRoute == '/home',
                onTap: () {
                  if (currentRoute != '/home') {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              ),
              const SizedBox(width: 18),
              _NavLink(
                title: 'Books',
                isSelected: currentRoute.startsWith('/books') || currentRoute == '/add-book',
                onTap: () {
                  if (currentRoute != '/books') {
                    Navigator.pushReplacementNamed(context, '/books');
                  }
                },
              ),
              const SizedBox(width: 18),
              _NavLink(
                title: 'Connections',
                isSelected: currentRoute == '/connections',
                onTap: () {
                  if (currentRoute != '/connections') {
                    Navigator.pushReplacementNamed(context, '/connections');
                  }
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: CircleAvatar(
              backgroundColor: user != null 
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Colors.grey[200],
              radius: 16,
              backgroundImage: user?.profilePicture != null && user!.profilePicture!.isNotEmpty
                  ? NetworkImage(user.profilePicture!) as ImageProvider
                  : null,
              child: user?.profilePicture == null || user!.profilePicture!.isEmpty
                  ? Text(
                      user != null && user.name.isNotEmpty 
                          ? user.name[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        color: user != null 
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavLink extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavLink({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.black54,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
} 