import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TournamentsResultsPage extends StatefulWidget {
  const TournamentsResultsPage({super.key});

  @override
  _TournamentsResultsPageState createState() => _TournamentsResultsPageState();
}

class _TournamentsResultsPageState extends State<TournamentsResultsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _tournaments = [];

  @override
  void initState() {
    super.initState();
    _fetchTournamentResults();
  }

  void _fetchTournamentResults() {
    _database.child('tournaments').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Map<String, dynamic>> tournamentsList = [];

        data.forEach((key, value) {
          tournamentsList.add({
            'name': value['name'] ?? 'Bilinmeyen Turnuva',
            'winner': value['winner'] ?? 'Bilinmeyen Kazanan',
            'date': value['date'] ?? 'Tarih Belirtilmemiş',
          });
        });

        setState(() {
          _tournaments = tournamentsList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Turnuva Sonuçları',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 5,
      ),
      backgroundColor: Colors.grey[200],
      body: _tournaments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tournaments.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final tournament = _tournaments[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.emoji_events,
                        color: Colors.amber, size: 32),
                    title: Text(
                      tournament['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '🏆 Kazanan: ${tournament['winner']}\n📅 Tarih: ${tournament['date']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
