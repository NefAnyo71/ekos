import 'package:flutter/material.dart';

class CommunityManagersPage extends StatelessWidget {
  const CommunityManagersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Topluluk Yöneticileri',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 6.0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2),
              Color(0xFFFFA500),
              Color(0xFFFFD700),
              Color(0xFFFF0000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              _buildManagerCard(
                'Arif Özdemir',
                'Topluluk Lideri',
                'İletişim: arifkerem71@gmail.com',
                'Görev: Topluluk Lideri, Web ve Mobil Uygulama Geliştiriciliği',
                'assets/images/leader.png',
              ),
              _buildManagerCard(
                'Tufan Ayhan',
                'Yardımcı Lider',
                'İletişim: caelux1453@gmail.com',
                'Görev: Topluluk Yardımcı Lideri, Etkinlik Koordinatörü',
                'assets/images/tufanexe.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagerCard(String name, String title, String contact,
      String role, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          // Görsel
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              imagePath,
              height: 160.0, // Yükseklik artırıldı (önceki: 120.0)
              width: 100.0, // Genişlik değişmedi
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          // Yönetici Bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  contact,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
