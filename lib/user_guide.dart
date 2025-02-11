import 'package:flutter/material.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanım Kılavuzu'),
        backgroundColor: const Color(0xFF7C4DFF),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 165, 0, 1.0), // Turuncu
              Color.fromRGBO(0, 0, 255, 1.0), // Mavi
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InteractiveViewer(
                          child: Image.asset('assets/images/guide1.png'),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Uygulamayı güncellemek için öncelikle güncelleme butonuna tıklayıp güncel sürümünüzü öğrenin. Eğer yeni sürüm var ise uygulamanızı güncellemeniz gerekmektedir.',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Fotoğrafa daha detaylı bakabilmek için yakınlaştırabilirsiniz.',
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 100.0, // Boş kartın yüksekliği
                      child: Center(
                        child: Text(
                          'Boş Kart 1',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 100.0, // İkinci boş kartın yüksekliği
                      child: Center(
                        child: Text(
                          'Boş Kart 2',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      ),
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
