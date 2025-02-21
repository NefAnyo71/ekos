import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'loginChatPage.dart'; // LoginPage'e gitmek için gerekli import
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Timer için gerekli import

class CommunityChatPage extends StatefulWidget {
  @override
  _CommunityChatPageState createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userFullName = '';
  bool _showWelcomeMessage =
      true; // Hoşgeldiniz mesajının görünürlüğü için değişken

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _hideWelcomeMessage(); // Hoşgeldiniz mesajını gizleyecek fonksiyonu çağır
  }

  // Kullanıcı adını SharedPreferences'ten alıyoruz
  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userFullName = prefs.getString('fullName') ?? 'Misafir';
    });
  }

  // Hoşgeldiniz mesajını gizleme fonksiyonu
  void _hideWelcomeMessage() {
    Timer(Duration(seconds: 5), () {
      setState(() {
        _showWelcomeMessage = false;
      });
    });
  }

  // Mesajı Firestore'a gönderme fonksiyonu
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore.collection('messages').add({
        'message': _messageController.text,
        'sender': _userFullName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  // Firestore'dan mesajları almak için StreamBuilder
  Stream<List<Map<String, dynamic>>> _getMessages() {
    return _firestore
        .collection('messages') // Koleksiyon adı 'messages' olarak güncelledik
        .orderBy('timestamp', descending: true) // Zaman damgasına göre sıralama
        .snapshots() // Firestore'dan veri akışını alır
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => {
                  'message': doc['message'],
                  'sender': doc['sender'],
                  'timestamp': doc['timestamp'],
                })
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topluluk Sohbeti'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // LoginPage'e yönlendirme işlemi
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Kullanıcıyı karşılama mesajı
            if (_showWelcomeMessage)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hoşgeldiniz, $_userFullName!',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            // Mesajları görüntüleyen StreamBuilder
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Henüz mesaj yok.'));
                  }

                  return ListView.builder(
                    reverse: true, // En son mesaj üstte görünsün
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: message['sender'] == _userFullName
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: message['sender'] == _userFullName
                                  ? Colors.blueAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['sender'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: message['sender'] == _userFullName
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  message['message'],
                                  style: TextStyle(
                                      color: message['sender'] == _userFullName
                                          ? Colors.white
                                          : Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Mesaj gönderme kısmı
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Mesajınızı yazın...',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor:
                            Colors.black.withOpacity(0.8), // Siyah arka plan
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
