import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TeamsPlayersPage extends StatefulWidget {
  const TeamsPlayersPage({super.key});

  @override
  _TeamsPlayersPageState createState() => _TeamsPlayersPageState();
}

class _TeamsPlayersPageState extends State<TeamsPlayersPage> {
  final DatabaseReference _playersRef =
      FirebaseDatabase.instance.ref('players');
  List<Map<dynamic, dynamic>> players = [];
  final int maxTeamSize = 5; // Takımın maksimum üye sayısı
  String? selectedPlayerContact; // Seçilen oyuncunun iletişim bilgileri
  String? previousPlayer; // Önceki tıklanan oyuncu

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  // Firebase'den oyuncuları alıyoruz
  Future<void> _fetchPlayers() async {
    _playersRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          // Veriyi Map olarak dönüştürüp 'values' getter'ı ile listeyi alıyoruz
          players = List<Map<dynamic, dynamic>>.from((data as Map).values);
        });
      } else {
        // Verinin boş olduğunu kontrol edelim
        setState(() {
          players = [];
        });
      }
    });
  }

  // Mevcut oyuncu sayısına göre başvurabilecek kişi sayısını hesapla
  String getTeamMemberMessage(int currentMemberCount) {
    int remainingSpots = maxTeamSize - currentMemberCount;
    if (remainingSpots > 0) {
      return '$remainingSpots kişi daha başvurabilir';
    } else {
      return 'Takım tamamlandı!';
    }
  }

  // Kart tıklandığında iletişim bilgilerini göster
  void _togglePlayerContact(String contactInfo, String playerName) {
    setState(() {
      // Eğer aynı oyuncuya tıklanırsa iletişim bilgilerini kapat
      if (previousPlayer == playerName) {
        selectedPlayerContact = null;
        previousPlayer = null;
      } else {
        selectedPlayerContact = contactInfo;
        previousPlayer = playerName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takım ve Oyuncular'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2196F3), // Mavi
              Color(0xFF4CAF50), // Yeşil
              Color(0xFFFF5722), // Turuncu
            ],
            stops: [0.0, 0.5, 1.0], // Renk geçişi noktaları
          ),
        ),
        child: players.isEmpty
            ? const Center(child: Text('No players available'))
            : ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final currentMemberCount = player['teamSize'] ??
                      0; // Firebase'den gelen teamSize değerini kullan
                  final remainingSpots = maxTeamSize -
                      currentMemberCount; // remainingSpots hesaplama
                  final teamMessage = getTeamMemberMessage(currentMemberCount);
                  final contactInfo =
                      player['contactInfo'] ?? 'İletişim bilgisi mevcut değil';
                  final playerName = player['name'] ?? 'No Name';

                  return GestureDetector(
                    onTap: remainingSpots > 0
                        ? () {
                            _togglePlayerContact(contactInfo, playerName);
                          }
                        : null, // Takım tamamlanmışsa tıklanmasını engelle
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      elevation: 6.0, // Kartın gölgesi
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            16.0), // Daha yuvarlak köşeler
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipOval(
                                child: Image.network(
                                  player['photoUrl'] ?? '',
                                  fit: BoxFit.cover,
                                  width: 60.0,
                                  height: 60.0,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      size: 60.0,
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                player['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Team Members: $currentMemberCount / $maxTeamSize',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            if (remainingSpots > 0) ...[
                              Text(
                                teamMessage,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              // Başvurmak için tıklanabilir yazı
                              GestureDetector(
                                onTap: () {
                                  // Başvuru yapma işlemi buraya eklenebilir
                                  print('Başvuru yapıldı');
                                },
                                child: Text(
                                  'Başvuru için tıklayınız',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            if (selectedPlayerContact != null &&
                                selectedPlayerContact == contactInfo) ...[
                              const SizedBox(height: 10),
                              Text(
                                'İletişim Bilgileri: $selectedPlayerContact',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
