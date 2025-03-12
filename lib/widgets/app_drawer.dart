import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.network(
                  AppConstants.logoUrl,
                  width: 40,
                  height: 40,
                  color: Colors.white,
                  placeholderBuilder: (context) => const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bookwise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Jelajahi Dunia dengan Setiap Halaman',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.home, 'Beranda'),
          _buildDrawerItem(context, Icons.book, 'Koleksi Buku'),
          _buildDrawerItem(context, Icons.favorite, 'Favorit'),
          _buildDrawerItem(context, Icons.history, 'Riwayat Bacaan'),
          const Divider(),
          _buildDrawerItem(context, Icons.settings, 'Pengaturan'),
          _buildDrawerItem(context, Icons.help, 'Bantuan'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

