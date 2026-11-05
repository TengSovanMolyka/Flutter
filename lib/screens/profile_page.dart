import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/app_state.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    AppState.instance.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_onAppStateChanged);

    super.dispose();
  }

  // ================= STATE LISTENER =================

  void _onAppStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ================= OPEN LOGIN =================

  void _openLogin() {
    context.push('/login');
  }

  // ================= OPEN SIGNUP =================

  void _openSignUp() {
    context.push('/signup');
  }

  // ================= LOGOUT =================

  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),

          content: const Text(
            'Are you sure you want to logout?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                AppState.instance.logout();
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    final User? user = appState.currentUser;

    debugPrint('PROFILE USER: ${user?.email}');

    return Scaffold(
      backgroundColor: const Color(0xFFFFE5E5),

      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,

        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: user == null
          ? _buildGuestProfile()
          : _buildLoggedInProfile(user),
    );
  }

  // ================= GUEST PROFILE =================

  Widget _buildGuestProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          const SizedBox(height: 35),

          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 65,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Welcome to E SHOP',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Login to access your profile, orders and favorites.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          // LOGIN BUTTON

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _openLogin,

              icon: const Icon(Icons.login),

              label: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 5),

          TextButton(
            onPressed: _openSignUp,
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGGED-IN PROFILE =================

  Widget _buildLoggedInProfile(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          const SizedBox(height: 20),

          // PROFILE AVATAR

          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 65,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 18),

          // USER NAME

          Text(
            user.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          // USER EMAIL

          Text(
            user.email,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 25),

          // USER INFORMATION

          _profileInfoCard(
            icon: Icons.person_outline,
            title: 'Full Name',
            value: user.name,
          ),

          const SizedBox(height: 12),

          _profileInfoCard(
            icon: Icons.email_outlined,
            title: 'Email',
            value: user.email,
          ),

          if (user.phone.isNotEmpty) ...[
            const SizedBox(height: 12),

            _profileInfoCard(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: user.phone,
            ),
          ],

          const SizedBox(height: 25),

          // PROFILE OPTIONS

          _profileOption(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            onTap: () {},
          ),

          _profileOption(
            icon: Icons.favorite_border,
            title: 'My Favorites',
            onTap: () {},
          ),

          _profileOption(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
          ),

          const SizedBox(height: 15),

          // LOGOUT BUTTON

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _logout,

              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),

              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.red,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= PROFILE INFO CARD =================

  Widget _profileInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: Colors.red,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= PROFILE OPTION =================

  Widget _profileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.red,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),

        onTap: onTap,
      ),
    );
  }
}
