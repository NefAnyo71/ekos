import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EventsCalendarPage extends StatefulWidget {
  const EventsCalendarPage({super.key});

  @override
  EventsCalendarPageState createState() => EventsCalendarPageState();
}

class EventsCalendarPageState extends State<EventsCalendarPage> {
  final DatabaseReference _eventsRef =
      FirebaseDatabase.instance.ref("calendarnews");
  List<Map<String, String>> _eventsList = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    _eventsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, String>> tempList = [];
        data.forEach((key, value) {
          tempList.add({
            "title": value["title"],
            "date": value["date"],
            "details": value["details"],
          });
        });
        setState(() {
          _eventsList = tempList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Etkinlik Takvimi',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 6.0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _eventsList.isEmpty
            ? const Center(
                child: CircularProgressIndicator()) // Yükleniyor göstergesi
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _eventsList.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(
                    context,
                    _eventsList[index]["title"] ?? "",
                    _eventsList[index]["date"] ?? "",
                    _eventsList[index]["details"] ?? "",
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEventCard(
      BuildContext context, String title, String date, String details) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(
              title: title,
              date: date,
              details: details,
            ),
          ),
        );
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Kartın köşelerini yuvarlatma
        ),
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                details,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final String title;
  final String date;
  final String details;

  const EventDetailsPage(
      {Key? key,
      required this.title,
      required this.date,
      required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Etkinlik Detayları',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                details,
                style: const TextStyle(fontSize: 20, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
