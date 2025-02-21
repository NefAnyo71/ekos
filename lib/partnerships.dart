import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlat
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Partnerships',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PartnershipsPage(),
    );
  }
}

class PartnershipsPage extends StatefulWidget {
  const PartnershipsPage({Key? key}) : super(key: key);

  @override
  _PartnershipsPageState createState() => _PartnershipsPageState();
}

class _PartnershipsPageState extends State<PartnershipsPage> {
  // Firebase Realtime Database'den veri çekme
  Future<Map<dynamic, dynamic>> getPartnershipData() async {
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final snapshot = await database.child('partnerships').get();
    if (snapshot.exists) {
      return snapshot.value
          as Map<dynamic, dynamic>; // Veriyi Map olarak döndürüyoruz
    } else {
      throw Exception("No data available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'İşbirliklerimiz',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 6.0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2),
              Color(0xFFFFA500),
              Color(0xFFFFD700),
              Color(0xFFFF0000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<Map<dynamic, dynamic>>(
          future: getPartnershipData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available.'));
            }

            var partnerships = snapshot.data!;

            return ListView.builder(
              itemCount: partnerships.length,
              itemBuilder: (context, index) {
                var partnership = partnerships.values.elementAt(index);
                String title = partnership['title'];
                String description = partnership['description'];
                String imageUrl = partnership['imageUrl'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PartnershipDetailPage(
                          title: title,
                          description: description,
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 8.0,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        // Görsel kısmı
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover, // Kare görünüm
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Başlık ve açıklama kısmı
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Açıklama kısmında, uzun metinlerin tamamı gösterilecek
                                Text(
                                  description.length > 100
                                      ? description.substring(0, 100) + '...'
                                      : description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 3, // Açıklama için 3 satır
                                  overflow: TextOverflow
                                      .ellipsis, // Satır sonu fazla metin için
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PartnershipDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const PartnershipDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0, // Daha düz bir görünüm için
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2),
              Color(0xFFFFA500),
              Color(0xFFFFD700),
              Color(0xFFFF0000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Görsel kısmı
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          imageUrl,
                          width: double.infinity, // Ekranın tam genişliği
                          height: MediaQuery.of(context).size.height *
                              0.4, // Yüksekliği ekranın %40'ı kadar ayarla
                          fit: BoxFit
                              .cover, // Görseli kapsayacak şekilde yerleştir
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                description,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black, // Siyah metin
                                  height: 1.6, // Satır yüksekliği
                                ),
                                textAlign:
                                    TextAlign.justify, // Metni iki yana yasla
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
