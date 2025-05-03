import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/stats_card.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); // Hapus userId dari SharedPreferences

    // Navigasi ke layar login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Profile picture
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://www.shadcnblocks.com/images/block/avatar-1.webp',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.person, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name and Email using FutureBuilder
                FutureBuilder<Map<String, String?>>(
                  future: _getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final userData = snapshot.data ?? {'name': null, 'email': null};

                    return Column(
                      children: [
                        // Name
                        Text(
                          userData['name'] ?? 'Nama tidak tersedia',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Email
                        Text(
                          userData['email'] ?? 'Email tidak tersedia',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Stats row
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: const [
                //     StatsCard(title: 'Buku Dibaca', value: '27'),
                //     StatsCard(title: 'Ulasan', value: '15'),
                //     StatsCard(title: 'Favorit', value: '8'),
                //   ],
                // ),
                // const SizedBox(height: 24),

                // Settings section
                _buildSettingsSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final settingsItems = [
      // {'icon': Icons.person_outline, 'title': 'Edit Profil', 'onTap': () {}},
      // {'icon': Icons.notifications_none, 'title': 'Notifikasi', 'onTap': () {}},
      // {'icon': Icons.security, 'title': 'Keamanan', 'onTap': () {}},
      // {'icon': Icons.help_outline, 'title': 'Bantuan', 'onTap': () {}},
      {
        'icon': Icons.logout,
        'title': 'Keluar',
        'onTap': () => _logout(context), // Panggil fungsi logout
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: settingsItems.map((item) {
          return ListTile(
            leading: Icon(item['icon'] as IconData, color: Colors.black),
            title: Text(item['title'] as String),
            // trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: item['onTap'] as void Function()?,
          );
        }).toList(),
      ),
    );
  }
}
