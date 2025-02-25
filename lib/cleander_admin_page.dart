import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewsAdminPage extends StatefulWidget {
  const NewsAdminPage({Key? key}) : super(key: key);

  @override
  NewsAdminPageState createState() => NewsAdminPageState();
}

class NewsAdminPageState extends State<NewsAdminPage> {
  final DatabaseReference _newsRef =
      FirebaseDatabase.instance.ref("calendarnews");
  List<Map<String, String>> _newsList = [];
  bool _isFirstOpen = true; // İlk açılış kontrolü

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    _newsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, String>> tempList = [];
        data.forEach((key, value) {
          tempList.add({
            "key": key,
            "title": value["title"],
            "date": value["date"],
            "details": value["details"],
          });
        });
        setState(() {
          _newsList = tempList;
        });
      }
    });
  }

  void _deleteNews(String key) {
    _newsRef.child(key).remove();
  }

  // İlk açılışta uyarı gösterme
  void _showFirstOpenAlert() {
    if (_isFirstOpen) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Dikkat'),
            content: const Text(
              'Veriler Realtime Database ile yönetilmektedir. Bu panel üzerinden yalnızca eskiyen haberler silinebilir. '
              'Veri eklemek veya değiştirmek için sunucu üzerinden işlem yapılması gerekmektedir. '
              'Eğer haber sayfası veritabanı ile entegre olsaydı, veriyi hem okuyup hem de yazabilirdiniz. '
              'Bu güvenlik amacıyla tasarlanmış bir sistemdir.',
              style: TextStyle(color: Colors.black), // Yazı rengi siyah
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isFirstOpen = false;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _showFirstOpenAlert(); // İlk açılışta uyarıyı göster

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Takvimi Yönetimi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _newsList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(_newsList[index]["title"] ?? ""),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_newsList[index]["date"] ?? ""),
                          Text(_newsList[index]["details"] ?? ""),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteNews(_newsList[index]["key"] ?? ""),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
