import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemberProfilesAccountPage extends StatefulWidget {
  const MemberProfilesAccountPage({Key? key}) : super(key: key);

  @override
  _MemberProfilesAccountPageState createState() =>
      _MemberProfilesAccountPageState();
}

class _MemberProfilesAccountPageState extends State<MemberProfilesAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserProfilePage(userEmail: userCredential.user!.email!),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = "Geçersiz e-posta adresi.";
          break;
        case 'user-disabled':
          errorMessage = "Kullanıcı devre dışı bırakılmış.";
          break;
        case 'user-not-found':
          errorMessage = "Kullanıcı bulunamadı.";
          break;
        case 'wrong-password':
          errorMessage = "Şifre hatalı.";
          break;
        default:
          errorMessage = e.message ?? "Bir hata oluştu.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üye Profilleri - Hesap Bilgileri'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Giriş Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final String userEmail;

  const UserProfilePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoş geldiniz, $userEmail',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Turnuva Geçmişi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('Turnuva 1 - 2024'),
                    subtitle: Text('Durum: Katıldı'),
                  ),
                  ListTile(
                    title: Text('Turnuva 2 - 2023'),
                    subtitle: Text('Durum: Kazandı'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kullanıcı Logları:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('Giriş Yapıldı - 08.02.2025'),
                  ),
                  ListTile(
                    title: Text('Şifre Değiştirildi - 05.02.2025'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
