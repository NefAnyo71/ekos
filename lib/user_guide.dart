import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                _buildGuideCard(
                  context,
                  'assets/images/guide2.png',
                  'Topluluğa nasıl üye olacağınız görselde detaylıca anlatılmıştır.',
                ),
                const SizedBox(height: 20),
                _buildGuideCard(
                  context,
                  'assets/images/guide1.png',
                  'Uygulamayı güncellemek için öncelikle güncelleme butonuna tıklayıp güncel sürümünüzü öğrenin. Eğer yeni sürüm var ise uygulamanızı güncellemeniz gerekmektedir.',
                ),
                const SizedBox(height: 20),
                _buildGuideCard(
                  context,
                  'assets/images/communitychat.png',
                  'Topluluk sayfasını nasıl kullanacağınızı bu görselde detaylıca inceleyebilirsiniz.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(
      BuildContext context, String imagePath, String description) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: Colors.black54,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(imagePath),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen,
                        size: 30, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImagePage(imagePath: imagePath),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImagePage extends StatefulWidget {
  final String imagePath;
  const FullScreenImagePage({super.key, required this.imagePath});

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: InteractiveViewer(
            child: Image.asset(widget.imagePath),
          ),
        ),
      ),
    );
  }
}
