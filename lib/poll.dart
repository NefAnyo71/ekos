import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();

  // Anket soruları ve cevaplarını saklamak için
  String? _appRating;
  String? _communityFeedback;
  String? _appImprovements;
  String? _eventFeedback;

  Future<void> _submitSurvey() async {
    try {
      await FirebaseFirestore.instance.collection('surveys').add({
        'appRating': _appRating,
        'communityFeedback': _communityFeedback,
        'appImprovements': _appImprovements,
        'eventFeedback': _eventFeedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anketiniz kaydedildi. Teşekkür ederiz!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anket kaydedilirken bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anket Sayfası'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                color: Colors.deepPurple.shade50,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anketler anonimdir. Yaptığınız anketlerin sonuçları sadece yöneticiler ile paylaşılmaktadır. Kırıkkale Üniversitesi Ekonometri ve E-Spor Topluluğu',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Mobil Uygulama Hakkında',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Uygulamayı nasıl değerlendiriyorsunuz?',
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Çok İyi',
                                  groupValue: _appRating,
                                  onChanged: (value) {
                                    setState(() {
                                      _appRating = value;
                                    });
                                  },
                                ),
                                Text('Çok İyi',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'İyi',
                                  groupValue: _appRating,
                                  onChanged: (value) {
                                    setState(() {
                                      _appRating = value;
                                    });
                                  },
                                ),
                                Text('İyi',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Orta',
                                  groupValue: _appRating,
                                  onChanged: (value) {
                                    setState(() {
                                      _appRating = value;
                                    });
                                  },
                                ),
                                Text('Orta',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Kötü',
                                  groupValue: _appRating,
                                  onChanged: (value) {
                                    setState(() {
                                      _appRating = value;
                                    });
                                  },
                                ),
                                Text('Kötü',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Topluluk Hakkında',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Topluluk hakkında geri bildiriminiz nedir?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: 'Görüşlerinizi buraya yazınız...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _communityFeedback = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Uygulamanın geliştirilmesi için önerileriniz nelerdir?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: 'Önerilerinizi buraya yazınız...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _appImprovements = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Son katıldığınız etkinlik hakkında geri bildiriminiz nedir?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: 'Geri bildiriminizi buraya yazınız...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _eventFeedback = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              _submitSurvey();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text('Anketi Kaydet'),
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
    );
  }
}
