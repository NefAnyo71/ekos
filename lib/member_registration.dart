import 'package:flutter/material.dart';

class MemberRegistrationPage extends StatelessWidget {
  const MemberRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluğa Üye Olma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MemberRegistrationForm(),
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

  String? _firstName;
  String? _lastName;
  String? _studentId;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ad',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen adınızı giriniz';
              }
              _firstName = value;
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Soyad',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen soyadınızı giriniz';
              }
              _lastName = value;
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Öğrenci Numarası',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen öğrenci numaranızı giriniz';
              }
              _studentId = value;
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'E-posta Adresi',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen e-posta adresinizi giriniz';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Lütfen geçerli bir e-posta adresi giriniz';
              }
              _email = value;
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Ad: $_firstName\nSoyad: $_lastName\nÖğrenci Numarası: $_studentId\nE-posta: $_email')),
                  );
                }
              },
              child: const Text('Üye Ol'),
            ),
          ),
        ],
      ),
    );
  }
}
