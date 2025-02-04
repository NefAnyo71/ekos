import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberJoinPage extends StatefulWidget {
  const MemberJoinPage({Key? key}) : super(key: key);

  @override
  MemberJoinPageState createState() => MemberJoinPageState();
}

class MemberJoinPageState extends State<MemberJoinPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final SignatureController _signController =
      SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  String? _pdfFilePath;

  @override
  void initState() {
    super.initState();
    _showWarningMessage();
  }

  void _showWarningMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bilgilendirme'),
            content: const Text(
              'Burada kayıt işleminizi tamamladığınızda PDF dosyası oluşturulacaktır. Bu PDF dosyasını arifkerem71@gmail.com adresine gönderiniz üyelik işleminizi tamamlayabilmeniz için.',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    });
  }

  String _removeTurkishCharacters(String input) {
    const Map<String, String> turkishChars = {
      'ç': 'c',
      'ğ': 'g',
      'ı': 'i',
      'ö': 'o',
      'ş': 's',
      'ü': 'u',
      'Ç': 'C',
      'Ğ': 'G',
      'İ': 'I',
      'Ö': 'O',
      'Ş': 'S',
      'Ü': 'U',
    };
    return input.split('').map((char) => turkishChars[char] ?? char).join();
  }

  Future<void> _submitForm() async {
    String name = _removeTurkishCharacters(_nameController.text);
    String email = _removeTurkishCharacters(_emailController.text);
    String phone = _removeTurkishCharacters(_phoneController.text);
    String studentId = _removeTurkishCharacters(_studentIdController.text);

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        studentId.isEmpty ||
        _signController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Lütfen tüm alanları doldurun ve imzanızı atın',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    try {
      final Uint8List? signBytes = await _signController.toPngBytes();
      if (signBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'İmza alınamadı',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      final pdf = pw.Document();
      final image = pw.MemoryImage(signBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Ad Soyad: $name'),
              pw.Text('Email: $email'),
              pw.Text('Telefon Numarasi: $phone'),
              pw.Text('Ogrenci Numarasi: $studentId'),
              pw.SizedBox(height: 20),
              pw.Text('Imza:'),
              pw.SizedBox(height: 10),
              pw.Image(image),
            ],
          ),
        ),
      );

      // Temporary directory for storing PDF
      final Directory? directory = await getTemporaryDirectory();
      if (directory == null) {
        throw Exception("Temporary directory is null");
      }
      final String dirPath = '${directory.path}/MemberJoinForms';
      final Directory dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final String filePath = '$dirPath/${name}_$studentId.pdf';
      final File file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      setState(() {
        _pdfFilePath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PDF dosyası oluşturuldu ve indirildi: $filePath',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _studentIdController.clear();
      _signController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PDF dosyası oluşturulamadı: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  Future<void> _sendWhatsApp(String message) async {
    final String phoneNumber =
        '+90xxxxxxxxxx'; // Replace with your phone number
    final String url = 'https://wa.me/$phoneNumber?text=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'WhatsApp açılmadı',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  Future<void> _sendEmail(String filePath) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'arifkerem71@gmail.com',
      query:
          'subject=Üyelik Formu&body=Lütfen ekli PDF dosyasını inceleyin.%0D%0A%0D%0A$filePath',
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'E-posta uygulaması açılamadı',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  void _openPDF() {
    if (_pdfFilePath != null) {
      OpenFile.open(_pdfFilePath);
    }
  }

  void _savePDF() {
    if (_pdfFilePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PDF başarıyla kaydedildi: $_pdfFilePath',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluğa Üye Olma'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Üyelik Bilgileri',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _nameController,
                labelText: 'Ad Soyad',
                icon: Icons.person,
              ),
              const SizedBox(height: 12.0),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 12.0),
              _buildTextField(
                controller: _phoneController,
                labelText: 'Telefon Numarasi',
                icon: Icons.phone,
              ),
              const SizedBox(height: 12.0),
              _buildTextField(
                controller: _studentIdController,
                labelText: 'Öğrenci Numarası',
                icon: Icons.school,
              ),
              const SizedBox(height: 20),
              const Text(
                'İmza:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Signature(
                  controller: _signController,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _submitForm,
                  child: const Text('Kayıt Ol'),
                ),
              ),
              if (_pdfFilePath != null) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _openPDF,
                      child: const Text('PDF Aç'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _savePDF,
                      child: const Text('PDF Kaydet'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _sendWhatsApp(
                            'Üyelik kaydınızı tamamladım. PDF dosyasını göndermek için arifkerem71@gmail.com adresine gönderebilirsiniz.');
                      },
                      child: const Text('WhatsApp ile Gönder'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _sendEmail(_pdfFilePath!);
                      },
                      child: const Text('E-posta ile Gönder'),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
