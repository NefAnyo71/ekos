import 'package:flutter/material.dart';

void main() {
  runApp(const EkonometriApp());
}

class EkonometriApp extends StatelessWidget {
  const EkonometriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EkonometriPage(),
    );
  }
}

class EkonometriPage extends StatelessWidget {
  const EkonometriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ekonometri Ders Notları',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF7C4DFF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildClassButton(context, '1. Sınıf Ders Notları', 1),
            const SizedBox(height: 16),
            _buildClassButton(context, '2. Sınıf Ders Notları', 2),
            const SizedBox(height: 16),
            _buildClassButton(context, '3. Sınıf Ders Notları', 3),
            const SizedBox(height: 16),
            _buildClassButton(context, '4. Sınıf Ders Notları', 4),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildClassButton(
      BuildContext context, String title, int classYear) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C4DFF),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(title),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SemesterSelectionPage(classYear: classYear),
          ),
        );
      },
    );
  }
}

class SemesterSelectionPage extends StatelessWidget {
  final int classYear;

  const SemesterSelectionPage({super.key, required this.classYear});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$classYear. Sınıf Seçimi',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF7C4DFF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSemesterButton(context, 'Güz Dönemi', true),
          _buildSemesterButton(context, 'Bahar Dönemi', false),
        ],
      ),
    );
  }

  ElevatedButton _buildSemesterButton(
      BuildContext context, String title, bool isFall) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C4DFF),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: Text(title),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NotesPage(classYear: classYear, isFall: isFall),
          ),
        );
      },
    );
  }
}

class NotesPage extends StatelessWidget {
  final int classYear;
  final bool isFall;

  const NotesPage({super.key, required this.classYear, required this.isFall});

  @override
  Widget build(BuildContext context) {
    final semester = isFall ? 'Güz Dönemi' : 'Bahar Dönemi';
    final notes = _getNotesForClassAndSemester(classYear, isFall);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$classYear. Sınıf $semester Ders Notları',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF7C4DFF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(note, style: const TextStyle(color: Colors.black)),
              trailing: IconButton(
                icon: const Icon(Icons.download, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$note indiriliyor...')),
                  );
                  // Add your PDF download logic here
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _getNotesForClassAndSemester(int classYear, bool isFall) {
    final notes = {
      1: {
        true: [
          'Matematik I',
          'İstatistik I',
          'İktisada Giriş I',
          'Bilgi Teknolojileri'
        ],
        false: [
          'Matematik II',
          'İstatistik II',
          'İktisada Giriş II',
          'Genel Muhasebe'
        ],
      },
      2: {
        true: [
          'Ekonometri I',
          'Mikroiktisat',
          'Araştırma Yöntemleri',
          'Mesleki İngilizce'
        ],
        false: ['Ekonometri II', 'Makroiktisat', 'Finansal Matematik'],
      },
      3: {
        true: [
          'Zaman Serileri Analizi',
          'Kamu Maliyesi',
          'Ekonomik Kalkınma',
          'Türk Vergi Sistemi'
        ],
        false: [
          'Panel Veri Analizi',
          'Para Politikası',
          'Uluslararası İktisat',
          'Uygulamalı İstatistik'
        ],
      },
      4: {
        true: [
          'Proje Yönetimi',
          'Ekonomik Modeller',
          'Enerji Ekonomisi',
          'Finansal Ekonometri'
        ],
        false: [
          'Uygulamalı Ekonometri',
          'İleri Ekonomi Teorisi',
          'Çevre Ekonomisi',
          'Bitirme Projesi'
        ],
      },
    };

    return notes[classYear]?[isFall] ?? [];
  }
}
