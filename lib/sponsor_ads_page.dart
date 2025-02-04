// sponsor_ads_page.dart
import 'package:flutter/material.dart';

class SponsorAdsPage extends StatelessWidget {
  const SponsorAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sponsor Reklamları',
          style: TextStyle(color: Colors.white), // Başlık yazısı beyaz
        ),
        backgroundColor: Colors.black, // Başlık çubuğu siyah
        iconTheme:
            const IconThemeData(color: Colors.white), // Geri butonu beyaz
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.business,
                  size: 80, color: Colors.white), // Sponsor reklamları simgesi
              const SizedBox(height: 20),
              const Text(
                'Şu anda sponsor reklamlarımız yayınlanmamaktadır.\n'
                'Reklam anlaşmaları için bizimle iletişime geçin!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Mail gönderme fonksiyonu burada da eklenebilir
                },
                icon: const Icon(Icons.email, color: Colors.black),
                label: const Text(
                  'Reklam için iletişime geç',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Dikkat çeken renk
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
