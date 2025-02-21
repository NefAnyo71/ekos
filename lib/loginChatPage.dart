import 'package:flutter/material.dart';
import 'CommunityChatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _errorMessage = '';
  bool _isAccountCreated =
      false; // Hesap oluşturulup oluşturulmadığını kontrol eder

  // Hesap oluşturma simülasyonu
  void _createAccount() {
    setState(() {
      _errorMessage = ''; // Hata mesajını sıfırla
    });

    // Burada Firebase veya başka bir backend kullanmıyoruz, direkt olarak "hesap oluşturma" işlemini simüle ediyoruz
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isAccountCreated = true; // Hesap oluşturulduktan sonra ad soyad iste
      });
    } else {
      setState(() {
        _errorMessage = 'E-posta ve şifre boş olamaz!';
      });
    }
  }

  // Ad soyad bilgisini kaydedip CommunityChatPage'e geçiş
  Future<void> _saveFullNameAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ad soyad bilgisini SharedPreferences'te sakla
    await prefs.setString('fullName', _nameController.text);

    // CommunityChatPage'e yönlendir
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityChatPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAccountCreated ? 'Ad Soyad Gir' : 'Hesap Oluştur'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hata mesajı
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            // E-posta ve şifre ile hesap oluşturma için form
            if (!_isAccountCreated) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'E-posta'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Şifre'),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAccount, // Hesap oluştur simülasyonu
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Hesap Oluştur',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            // Hesap oluşturulduktan sonra kullanıcıdan ad soyad alacağız
            if (_isAccountCreated) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Ad Soyad'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _saveFullNameAndNavigate, // Ad soyad bilgisini kaydet ve CommunityChatPage'e yönlendir
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text(
                  'Kaydet ve Devam Et',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
