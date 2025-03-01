import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // TapGestureRecognizer için gerekli import
import 'package:url_launcher/url_launcher.dart'; // URL açmak için gerekli import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ders İçerikleri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EconometricsCourseContentsPage(),
    );
  }
}

class EconometricsCourseContentsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // URL açma fonksiyonu
  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Error launching URL: $e");
    }
  }

  TextSpan getContentText(String content) {
    final regex = RegExp(r'(https?://[^\s]+)');
    final matches = regex.allMatches(content);

    if (matches.isEmpty) {
      return TextSpan(
        text: content,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      );
    } else {
      List<TextSpan> textSpans = [];
      int lastIndex = 0;

      for (var match in matches) {
        // Önceki kısmı ekle
        if (match.start > lastIndex) {
          textSpans.add(TextSpan(
            text: content.substring(lastIndex, match.start),
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ));
        }

        textSpans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(
            fontSize: 16.0,
            color: Color.fromARGB(255, 0, 0, 0),
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _launchURL(match.group(0)!);
            },
        ));

        lastIndex = match.end;
      }

      // Sonraki kısmı ekle
      if (lastIndex < content.length) {
        textSpans.add(TextSpan(
          text: content.substring(lastIndex),
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ));
      }

      return TextSpan(children: textSpans);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ders İçerikleri',
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
        child: FutureBuilder<QuerySnapshot>(
          future: _firestore.collection('ekonometri').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No content available.'));
            } else {
              final courses = snapshot.data!.docs;

              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final String title = course['title'];
                  final String content = course['content'];

                  return Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C4DFF), Color(0xFF18FFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 8.0,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        RichText(
                          text: getContentText(content),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
