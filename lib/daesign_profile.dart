import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'daesign_home.dart';
import 'daesign_login.dart';
import 'daesign_drawer.dart';
import 'daesign_edit_profile.dart';

class DaeSignProfilePage extends StatefulWidget {
  const DaeSignProfilePage({super.key});

  @override
  State<DaeSignProfilePage> createState() => _DaeSignProfilePageState();
}

class _DaeSignProfilePageState extends State<DaeSignProfilePage> {
  final authService = AuthService();
  late DaeSignDrawerItem _activeDrawerItem = DaeSignDrawerItem.home;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // User data is already loaded from Firebase Auth
    // This method can be used for additional data fetching if needed
    if (mounted) {
      setState(() {});
    }
  }

  void _handleDrawerItemTap(DaeSignDrawerItem item) {
    setState(() => _activeDrawerItem = item);

    if (item == DaeSignDrawerItem.home) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DaeSignHomePage()),
      );
    } else if (item == DaeSignDrawerItem.signOut) {
      _handleLogout();
    }
  }

  Future<void> _handleLogout() async {
    await authService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DaeSignLoginPage()),
      );
    }
  }

  void _handleBackPress() {
    // Pop back to previous page (usually home or where profile was accessed from)
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _handleBackPress,
          ),
          title: Text(
            'Profile',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      drawer: DaeSignDrawer(
        activeItem: _activeDrawerItem,
        onItemTap: _handleDrawerItemTap,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: user?.photoURL != null
                      ? ClipOval(
                          child: Image.network(
                            user!.photoURL!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('⚠️ Error loading profile image: ${user.photoURL}');
                              print('   Error: $error');
                              print('   StackTrace: $stackTrace');
                              return Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey.shade600,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.shade600,
                        ),
                ),
              ),
              const SizedBox(height: 32),

              // Username
              _ProfileSection(
                label: 'Username',
                value: user?.displayName ?? 'Not set',
              ),
              const SizedBox(height: 24),

              // Email
              _ProfileSection(
                label: 'Email',
                value: user?.email ?? 'Not available',
              ),
              const SizedBox(height: 24),

              // Auth Provider
              _ProfileSection(
                label: 'Auth Method',
                value: user?.providerData.isNotEmpty == true
                    ? user!.providerData.first.providerId
                        .replaceFirst('.com', '')
                        .toUpperCase()
                    : 'Email/Password',
              ),
              const SizedBox(height: 24),

              // Account Created
              _ProfileSection(
                label: 'Member Since',
                value: user?.metadata.creationTime != null
                    ? _formatDate(user!.metadata.creationTime!)
                    : 'Unknown',
              ),
              const SizedBox(height: 40),

              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaeSignEditProfilePage(),
                      ),
                    ).then((_) {
                      // Refresh profile data when returning from edit
                      setState(() {});
                    });
                  },
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _handleLogout,
                  child: Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _ProfileSection extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileSection({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
