import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemberRegistrationPage extends StatelessWidget {
  const MemberRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekos Hesabınızı Oluşturun'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MemberRegistrationForm(),
          ),
        ),
      ),
    );
  }
}

class MemberRegistrationForm extends StatefulWidget {
  @override
  _MemberRegistrationFormState createState() => _MemberRegistrationFormState();
}

class _MemberRegistrationFormState extends State<MemberRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _firstName;
  String? _lastName;
  String? _studentId;
  String? _email;
  String? _password;

  Widget _buildTextField(String label, IconData icon, Function(String) onSave,
      {bool obscureText = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.deepPurple),
            border: InputBorder.none,
          ),
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen $label giriniz';
            }
            onSave(value);
            return null;
          },
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Kullanıcı başarıyla oluşturuldu: ${userCredential.user!.email}'),
          ),
        );

        // Kullanıcıyı başka bir sayfaya yönlendirebilir veya ek bilgiler kaydedebilirsiniz.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Kayıt Başarılı"),
            content: Text(
                "Ad: $_firstName\nSoyad: $_lastName\nÖğrenci Numarası: $_studentId\nE-posta: $_email"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Tamam"),
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Hesap oluşturulamadı!";
        if (e.code == 'email-already-in-use') {
          errorMessage = "Bu e-posta adresi zaten kullanımda.";
        } else if (e.code == 'weak-password') {
          errorMessage = "Şifre çok zayıf.";
        } else {
          errorMessage = e.message ?? "Bir hata oluştu.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildTextField('Ad', Icons.person, (value) => _firstName = value),
          const SizedBox(height: 10.0),
          _buildTextField(
              'Soyad', Icons.person_outline, (value) => _lastName = value),
          const SizedBox(height: 10.0),
          _buildTextField(
              'Öğrenci Numarası', Icons.school, (value) => _studentId = value),
          const SizedBox(height: 10.0),
          _buildTextField('E-posta Adresi', Icons.email, (value) {
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Geçerli bir e-posta adresi giriniz';
            }
            _email = value;
          }),
          const SizedBox(height: 10.0),
          _buildTextField('Şifre', Icons.lock, (value) => _password = value,
              obscureText: true),
          const SizedBox(height: 20.0),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Üye Ol',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
