import 'package:flutter/material.dart';
import '../widgets/stats_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              
              // Name
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              
              // Email
              Text(
                'john.doe@example.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  StatsCard(title: 'Buku Dibaca', value: '27'),
                  StatsCard(title: 'Ulasan', value: '15'),
                  StatsCard(title: 'Favorit', value: '8'),
                ],
              ),
              const SizedBox(height: 24),
              
              // Settings section
              _buildSettingsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final settingsItems = [
      {'icon': Icons.person_outline, 'title': 'Edit Profil'},
      {'icon': Icons.notifications_none, 'title': 'Notifikasi'},
      {'icon': Icons.security, 'title': 'Keamanan'},
      {'icon': Icons.help_outline, 'title': 'Bantuan'},
      {'icon': Icons.logout, 'title': 'Keluar'},
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
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          );
        }).toList(),
      ),
    );
  }
}

