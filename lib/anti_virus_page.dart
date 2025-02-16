import 'package:flutter/material.dart';

class AntiVirusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anti-Virüs Programları'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 165, 0, 1.0), // Turuncu
              Color.fromRGBO(0, 0, 255, 1.0), // Mavi
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  shadowColor: Colors.black54,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset('assets/images/icon_logo.png'),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Ekonometri ve E-Spor Topluluğu bu anti virüs programlarını öneriyor. Kaynağını bilmediğiniz APK dosyalarını yüklemeyin.',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Projenin GitHub linki:\nhttps://github.com/NefAnyo71/ekos',
                          style: TextStyle(fontSize: 16.0, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Yakında Google Play Store\'da yer alacağız!',
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAntivirusCard(
                  'assets/images/avast.png',
                  'Avast Free Antivirus',
                  'En iyi ücretsiz anti virüs programı.',
                ),
                const SizedBox(height: 20),
                _buildAntivirusCard(
                  'assets/images/avg.png',
                  'AVG Antivirus Free',
                  'Güçlü bir koruma sağlar.',
                ),
                const SizedBox(height: 20),
                _buildAntivirusCard(
                  'assets/images/kaspersky.png',
                  'Kaspersky Security Cloud Free',
                  'Çeşitli güvenlik özellikleri sunar.',
                ),
                const SizedBox(height: 20),
                _buildAntivirusCard(
                  'assets/images/bit.png',
                  'Bitdefender Antivirus Free Edition',
                  'Kullanıcı dostu ve etkili koruma sağlar.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAntivirusCard(
      String? imagePath, String title, String description) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: Colors.black54,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(imagePath),
              ),
            const SizedBox(height: 20.0),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
