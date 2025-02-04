import 'package:flutter/material.dart';

class AdvisorsPage extends StatelessWidget {
  const AdvisorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danışmanlar'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            AdvisorCard(
              imagePath: 'assets/images/academic advisor of the community.png',
              name: 'Dekan Yardımcısı Dr. Öğr. Üyesi Suat Serhat YILMAZ',
              bio:
                  'Balıkesir doğumlu Dr. Yılmaz, 2010 yılında Bülent Ecevit Üniversitesi İktisadi ve İdari Bilimler Fakültesi İktisat Bölümü’nden mezun olmuştur. 2015 yılında Kırıkkale Üniversitesi İktisadi ve İdari Bilimler Fakültesi Ekonometri Bölümü’nde Araştırma Görevlisi olarak göreve başlamış ve aynı yıl Ekonometri Anabilim Dalı’nda yüksek lisans eğitimine adım atmıştır. 2017 yılında yüksek lisansını başarıyla tamamlayan Dr. Yılmaz, aynı yıl Kırıkkale Üniversitesi İktisat Anabilim Dalı’nda doktora programına başlamış ve 2022 yılında doktorasını tamamlamıştır. 2023 yılında Kırıkkale Üniversitesi İktisadi ve İdari Bilimler Fakültesi Ekonometri Bölümü’ne Dr. Öğretim Üyesi olarak atanmıştır. Dr. Yılmaz, bu tarihten itibaren Kırıkkale Üniversitesi Ekonometri Bölümü’nde akademik çalışmalarını sürdürmektedir.',
            ),
          ],
        ),
      ),
    );
  }
}

class AdvisorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String bio;

  const AdvisorCard({
    required this.imagePath,
    required this.name,
    required this.bio,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 228, 157, 4),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              bio,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
