import 'package:flutter/material.dart';
import 'chat_admin_page.dart';
import 'cleander_admin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Paneli',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminPanelPage(),
    );
  }
}

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  // Giriş Kontrolü
  void _showLoginDialog(BuildContext context, Widget destinationPage) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    final String _correctUsername = 'your_username';
    final String _correctPassword = 'your_password';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Giriş Yap'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  filled: true,
                  fillColor: Color(0xFF4A90E2), // Mavi arka plan
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFFFA500)), // Turuncu kenarlık
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFFFD700)), // Altın Sarısı kenarlık
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text == _correctUsername &&
                    _passwordController.text == _correctPassword) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => destinationPage),
                  );
                } else {
                  // Hata mesajı göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Yanlış kullanıcı adı veya şifre')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Buton rengi
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Giriş Yap',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2), // Mavi
              Color(0xFFFFA500), // Turuncu
              Color(0xFFFFD700), // Altın Sarısı
              Color(0xFFFF0000), // Kırmızı
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            _buildAdminButton(
              context,
              'Topluluk Sohbet Yönetimi',
              Icons.chat,
              ChatAdminPage(),
            ),
            _buildAdminButton(
              context,
              'Etkinlik Yönetimi',
              Icons.article,
              const NewsAdminPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context, String label, IconData icon,
      Widget destinationPage) {
    return GestureDetector(
      onTap: () {
        _showLoginDialog(context, destinationPage); // Giriş penceresini göster
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.blue, // Buton rengi
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30.0,
              color: Colors.white,
            ),
            const SizedBox(width: 10.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
