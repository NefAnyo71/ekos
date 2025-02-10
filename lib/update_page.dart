import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For copy operation

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, String>> _updates = [];
  final String _currentVersion = "^1.3.1";

  @override
  void initState() {
    super.initState();
    _loadUpdates();
  }

  void _loadUpdates() {
    _database.child('upgrade').onValue.listen((event) {
      final upgradeData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (upgradeData != null) {
        List<Map<String, String>> loadedUpdates = [];

        upgradeData.forEach((key, value) {
          final title = value['title'];
          final description = value['description'];

          if (title != null && description != null) {
            loadedUpdates.add({
              'title': title,
              'description': description,
            });
          }
        });

        setState(() {
          _updates = loadedUpdates;
        });
      }
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kopyalandı!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Güncellemeler',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.red,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Güncel Sürümünüz: $_currentVersion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                _updates.isEmpty
                    ? Text(
                        'Güncellemeler yükleniyor...',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _updates.length,
                          itemBuilder: (ctx, index) {
                            final description = _updates[index]['description']!;
                            final hasURL = description.contains('https://');
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              elevation: 8,
                              color: Colors.white,
                              shadowColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _updates[index]['title']!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            description,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              decoration: hasURL
                                                  ? TextDecoration.underline
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                        if (hasURL)
                                          IconButton(
                                            icon: Icon(Icons.copy,
                                                color: Colors.blueAccent),
                                            onPressed: () {
                                              _copyToClipboard(description);
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
