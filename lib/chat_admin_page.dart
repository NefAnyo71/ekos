import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatAdminPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mesajları Firestore'dan çekme fonksiyonu
  Stream<List<Map<String, dynamic>>> _getMessages() {
    return _firestore
        .collection('messages') // 'messages' koleksiyonundaki veriler
        .orderBy('timestamp', descending: true) // Zaman damgasına göre sıralama
        .snapshots() // Firestore'dan veri akışını alır
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => {
                  'id': doc.id, // Mesajın ID'sini alıyoruz
                  'message': doc['message'],
                  'sender': doc['sender'],
                  'timestamp': doc['timestamp'],
                })
            .toList());
  }

  // Mesajı silme fonksiyonu
  Future<void> _deleteMessage(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).delete();
    } catch (e) {
      print("Hata: $e");
    }
  }

  // Kullanıcıyı engelleme fonksiyonu
  Future<void> _blockUser(String username) async {
    try {
      await _firestore.collection('blocked_users').doc(username).set({
        'blocked': true,
      });
      // Engellenen kullanıcının mesajlarını sil
      var snapshot = await _firestore
          .collection('messages')
          .where('sender', isEqualTo: username)
          .get();
      for (var doc in snapshot.docs) {
        await _deleteMessage(doc.id);
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  // Kullanıcıyı engelleme onaylama fonksiyonu
  void _showBlockUserDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Kullanıcıyı Engelle',
          style: TextStyle(color: Colors.black), // Başlık siyah
        ),
        content: Text(
          '$username kullanıcısını engellemek istediğinizden emin misiniz?',
          style: TextStyle(color: Colors.black), // İçerik siyah
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dialog'u kapat
            },
            child: Text('Hayır',
                style: TextStyle(color: Colors.black)), // 'Hayır' yazısı siyah
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Dialog'u kapat
              await _blockUser(username); // Kullanıcıyı engelle
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        '$username kullanıcısı engellendi ve mesajları silindi.')),
              );
            },
            child: Text('Evet',
                style: TextStyle(color: Colors.black)), // 'Evet' yazısı siyah
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sohbet Yönetimi'),
        backgroundColor: Colors.blueAccent,
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
            // Firestore'dan mesajları listeleme
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Mesajın içeriği
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['sender'],
                                        style: TextStyle(
                                          color: Colors.black, // Siyah renk
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        message['message'],
                                        style: TextStyle(
                                          color: Colors.black, // Siyah renk
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Mesajı silme ve engelleme butonu
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteMessage(message['id']);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.block,
                                          color: Colors.orange),
                                      onPressed: () {
                                        _showBlockUserDialog(
                                            context, message['sender']);
                                      },
                                    ),
                                  ],
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
          ],
        ),
      ),
    );
  }
}
