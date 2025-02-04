import 'package:flutter/material.dart';
import 'member_profiles_account.dart'; // Yeni sayfa için import

class MemberProfilesPage extends StatefulWidget {
  const MemberProfilesPage({super.key});

  @override
  _MemberProfilesPageState createState() => _MemberProfilesPageState();
}

class _MemberProfilesPageState extends State<MemberProfilesPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _fetchUserData() async {
    setState(() {
      _loading = true;
    });

    try {
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate a network call

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MemberProfilesAccountPage(), // Yeni sayfaya yönlendirme
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    if (_identifierController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen email adresinizi girin!')),
      );
      return;
    }

    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate a password reset call

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama bağlantısı gönderildi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama hatası meydana geldi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üye Profilleri'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _identifierController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _fetchUserData,
              icon: const Icon(Icons.login),
              label: const Text('Giriş Yap'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _resetPassword,
              child: const Text('Şifremi Unuttum'),
            ),
            const SizedBox(height: 20),
            _loading ? const CircularProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }
}
