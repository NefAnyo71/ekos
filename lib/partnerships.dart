import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlat
  runApp(MyApp());
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
      home: PartnershipsPage(),
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
        title: Text('İşbirliklerimiz',
            style: TextStyle(
                color: Colors
                    .white)), // Burada 'Ortaklıklar' yerine 'İşbirliklerimiz' yazdım
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: FutureBuilder<Map<dynamic, dynamic>>(
        future: getPartnershipData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Yükleniyor animasyonu
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available.'));
          }

          var partnerships = snapshot.data!;

          return ListView.builder(
            itemCount: partnerships.length,
            itemBuilder: (context, index) {
              var partnership = partnerships.values.elementAt(index);
              String title = partnership['title'];
              String description = partnership['description'];
              String imageUrl = partnership['imageUrl'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.black.withOpacity(0.3),
                color: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      // Görsel kısmı (Kare görsel ve yazının solunda)
                      Row(
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
                          SizedBox(width: 10),
                          // Başlık ve kısa açıklama kısmı
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    description.length > 100
                                        ? description.substring(0, 100) + '...'
                                        : description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
