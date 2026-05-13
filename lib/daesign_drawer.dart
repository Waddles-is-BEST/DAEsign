import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';

enum DaeSignDrawerItem {
  home,
  profile,
  createPost,
  search,
  notifications,
  signOut,
}

class DaeSignDrawer extends StatelessWidget {
  const DaeSignDrawer({
    super.key,
    required this.activeItem,
    this.onItemTap,
  });

  final DaeSignDrawerItem activeItem;
  final ValueChanged<DaeSignDrawerItem>? onItemTap;
  
  static final authService = AuthService();

  void _handleTap(BuildContext context, DaeSignDrawerItem item) {
    Navigator.pop(context);
    if (onItemTap != null) {
      onItemTap!(item);
      return;
    }

    // Front-end fallback behavior
    final String label;
    switch (item) {
      case DaeSignDrawerItem.home:
        label = 'Home tapped';
        break;
      case DaeSignDrawerItem.profile:
        label = 'Profile tapped';
        break;
      case DaeSignDrawerItem.createPost:
        label = 'Create Post tapped';
        break;
      case DaeSignDrawerItem.search:
        label = 'Search tapped';
        break;
      case DaeSignDrawerItem.notifications:
        label = 'Notifications tapped';
        break;
      case DaeSignDrawerItem.signOut:
        label = 'Sign Out tapped';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.72,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '𝔻Æ𝕤𝕚𝕘𝕟',
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 34, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DaeSignDrawer.authService.currentUser?.displayName ?? 'User',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black26),
            const SizedBox(height: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    _DrawerItem(
                      icon: Icons.home,
                      label: 'Home',
                      selected: activeItem == DaeSignDrawerItem.home,
                      onTap: () => _handleTap(context, DaeSignDrawerItem.home),
                    ),
                    const SizedBox(height: 14),
                    _DrawerItem(
                      icon: Icons.person,
                      label: 'Profile',
                      selected: activeItem == DaeSignDrawerItem.profile,
                      onTap: () => _handleTap(context, DaeSignDrawerItem.profile),
                    ),
                    const SizedBox(height: 14),
                    _DrawerItem(
                      icon: Icons.add,
                      label: 'Create Post',
                      selected: activeItem == DaeSignDrawerItem.createPost,
                      onTap: () => _handleTap(context, DaeSignDrawerItem.createPost),
                    ),
                    const SizedBox(height: 14),
                    _DrawerItem(
                      icon: Icons.search,
                      label: 'Search',
                      selected: activeItem == DaeSignDrawerItem.search,
                      onTap: () => _handleTap(context, DaeSignDrawerItem.search),
                    ),
                    const SizedBox(height: 14),
                    _DrawerItem(
                      icon: Icons.notifications_none,
                      label: 'Notifications',
                      selected: activeItem == DaeSignDrawerItem.notifications,
                      onTap: () => _handleTap(context, DaeSignDrawerItem.notifications),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
              child: _DrawerItem(
                icon: Icons.logout,
                label: 'Sign Out',
                selected: false,
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                onTap: () => _handleTap(context, DaeSignDrawerItem.signOut),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Color effectiveIconColor = iconColor ?? Colors.black;
    final Color effectiveTextColor = textColor ?? Colors.black;

    return Material(
      color: selected ? const Color(0xFF2F2F2F) : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 36, color: selected ? Colors.white : effectiveIconColor),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.titilliumWeb(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : effectiveTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
