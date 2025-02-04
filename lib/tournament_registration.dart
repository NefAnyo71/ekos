import 'package:flutter/material.dart';
import 'firebase_service.dart'; // Import Firebase service

class TournamentRegistrationPage extends StatefulWidget {
  const TournamentRegistrationPage({super.key});

  @override
  State<TournamentRegistrationPage> createState() =>
      _TournamentRegistrationPageState();
}

class _TournamentRegistrationPageState
    extends State<TournamentRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Email controller
  final TextEditingController _teamController =
      TextEditingController(); // Team controller
  final TextEditingController _studentNumberController =
      TextEditingController(); // Student number controller
  final TextEditingController _teamMembersController =
      TextEditingController(); // Team members controller
  final FirebaseService _firebaseService =
      FirebaseService(); // Initialize Firebase service
  bool _loading = false;

  void _submitRegistration() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final team = _teamController.text;
    final studentNumber = _studentNumberController.text;
    final teamMembers = _teamMembersController.text;

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        team.isNotEmpty &&
        studentNumber.isNotEmpty &&
        teamMembers.isNotEmpty) {
      setState(() {
        _loading = true;
      });

      try {
        await _firebaseService.insertTournamentRegistration({
          'name': name,
          'email': email,
          'team': team,
          'studentNumber': studentNumber,
          'teamMembers': teamMembers,
        });

        if (!mounted) return; // Check if the widget is still mounted

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Turnuva kaydınız için teşekkür ederiz! Size mail üzerinden dönüş yapılacaktır.')),
        );

        _nameController.clear();
        _emailController.clear();
        _teamController.clear();
        _studentNumberController.clear();
        _teamMembersController.clear();
      } catch (e) {
        if (!mounted) return; // Check if the widget is still mounted

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt gönderilirken bir hata oluştu: $e')),
        );
      } finally {
        setState(() {
          _loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnuva Başvuru Kayıt'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Adınız',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-posta adresiniz',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _studentNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Öğrenci Numaranız',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _teamController,
              decoration: InputDecoration(
                labelText: 'Takımınız',
                prefixIcon: const Icon(Icons.group),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _teamMembersController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Takım Üyelerinin Bilgileri',
                prefixIcon: const Icon(Icons.people),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _submitRegistration,
              icon: const Icon(Icons.send),
              label: const Text('Başvuru Gönder'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _loading ? const CircularProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }
}
