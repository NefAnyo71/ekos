import 'package:flutter/material.dart';

class CommunityManagersPage extends StatelessWidget {
  const CommunityManagersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluk Yöneticileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mavi hat çizgisi - Başlangıç
            Container(
              height: 4.0,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(height: 16.0), // Hat ile içerik arasında boşluk
            // Arif Özdemir - Topluluk Başkanı yani ben
            Row(
              children: [
                // Görsel
                Image.asset(
                  'assets/images/leader.png',
                  height: 200.0, // Görselin boyutunu kontrol et
                  width: 120.0, // Görselin genişliği
                  fit: BoxFit.cover, // Görseli uygun şekilde sığdır
                ),
                const SizedBox(width: 16.0),
                // Yönetici Bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Arif Özdemir',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black, // Yazı rengini siyah yapmamız şart arka plan beyaz olduğundan dolayı
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Topluluk Lideri',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'İletişim: arifkerem71@gmail.com',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors
                              .black, // Yazı rengini siyah yapmamız şart arka plan beyaz olduğundan dolayı
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Görev: Topluluk Lideri, Web ve Mobil Uygulama Geliştiriciliği',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors
                              .black, // Yazı rengini siyah yapmamız şart arka plan beyaz olduğundan dolayı
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 16.0), // Yöneticilerin arasına boşluk ekleyelim.

            // Mavi hat çizgisi
            Container(
              height: 4.0,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(height: 16.0), // Hat ile içerik arasında boşluk

            // Tufan Ayhan - İnsan Kaynakları
            Row(
              children: [
                // Görsel
                Image.asset(
                  'assets/images/tufanexe.png',
                  height: 200.0, // Görselin boyutunu kontrol et
                  width: 120.0, // Görselin genişliği
                  fit: BoxFit.cover, // Görseli uygun şekilde sığdır
                ),
                const SizedBox(width: 16.0),
                // Yönetici Bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tufan Ayhan',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Yardımcı Lider',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'İletişim: caelux1453@gmail.com',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Görev: Topluluk Yardımcı Lideri, Etkinlik Koordinatörü',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 16.0), // Yöneticilerin arasına boşluk ekleyelim.

            // Mavi hat çizgisi bunu sakın unutma
            Container(
              height: 4.0,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
