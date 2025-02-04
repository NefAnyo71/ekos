import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CommunityNewsPage extends StatefulWidget {
  const CommunityNewsPage({super.key});

  @override
  CommunityNewsPageState createState() => CommunityNewsPageState();
}

class CommunityNewsPageState extends State<CommunityNewsPage> {
  final DatabaseReference _communityNewsRef = FirebaseDatabase.instance
      .ref("community_news/news1"); // Tek bir haber için ref güncellendi
  Map<String, String> _communityNews = {};

  @override
  void initState() {
    super.initState();
    _fetchCommunityNews();
  }

  void _fetchCommunityNews() {
    _communityNewsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _communityNews = {
            "title": data["title"] ?? "Başlık yok",
            "content": data["content"] ?? "İçerik yok",
            "date": data["date"] ?? "Tarih yok"
          };
        });
        print(_communityNews); // Log basarak verileri kontrol edin
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluk Haberleri'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _communityNews.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Yükleniyor göstergesi
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCommunityNewsCard(
                context,
                _communityNews["title"] ?? "",
                _communityNews["content"] ?? "",
                _communityNews["date"] ?? "",
              ),
            ),
    );
  }

  Widget _buildCommunityNewsCard(
      BuildContext context, String title, String content, String date) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityNewsDetailPage(
                  title: title, content: content, date: date),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Kartın boyutunu içeriğe göre ayarlar
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityNewsDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  const CommunityNewsDetailPage(
      {super.key,
      required this.title,
      required this.content,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haber Detayları'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              content,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
