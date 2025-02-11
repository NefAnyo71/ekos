import 'package:flutter/material.dart';
import 'dart:math';

class ConfidenceIntervalPage extends StatefulWidget {
  const ConfidenceIntervalPage({Key? key}) : super(key: key);

  @override
  _ConfidenceIntervalPageState createState() => _ConfidenceIntervalPageState();
}

class _ConfidenceIntervalPageState extends State<ConfidenceIntervalPage> {
  final TextEditingController _meanController = TextEditingController();
  final TextEditingController _stdDevController = TextEditingController();
  final TextEditingController _sampleSizeController = TextEditingController();
  double? _confidenceLevel;
  String _result = "";

  void _calculateConfidenceInterval() {
    final double mean = double.tryParse(_meanController.text) ?? 0;
    final double stdDev = double.tryParse(_stdDevController.text) ?? 0;
    final int sampleSize = int.tryParse(_sampleSizeController.text) ?? 0;

    if (sampleSize <= 0 || stdDev <= 0 || _confidenceLevel == null) {
      setState(() {
        _result = "Lütfen tüm alanları doğru bir şekilde doldurun.";
      });
      return;
    }

    // Z-score for the selected confidence level
    double z = 1.96; // Default for 95%
    if (_confidenceLevel == 0.99) {
      z = 2.576;
    } else if (_confidenceLevel == 0.90) {
      z = 1.645;
    }

    final double marginOfError = z * (stdDev / sqrt(sampleSize));
    final double lowerBound = mean - marginOfError;
    final double upperBound = mean + marginOfError;

    setState(() {
      _result =
          "Güven Aralığı: \nAlt Sınır: ${lowerBound.toStringAsFixed(2)}, Üst Sınır: ${upperBound.toStringAsFixed(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Koyu arka plan
      appBar: AppBar(
        title: const Text(
          'Güven Aralığı Hesaplama',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Başlık rengi beyaz
          ),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 4.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formül görseli
            Center(
              child: Image.asset(
                'assets/images/güven_aralığı.png',
                height: 100, // Görsel yüksekliği
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _meanController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white), // Metin rengi beyaz
              decoration: InputDecoration(
                labelText: 'Ortalama (Mean)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _stdDevController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Standart Sapma (Standard Deviation)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _sampleSizeController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Örneklem Büyüklüğü (Sample Size)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            DropdownButton<double>(
              value: _confidenceLevel,
              dropdownColor: Colors.grey[900], // Koyu tema için arkaplan
              hint: const Text(
                'Güven Seviyesi Seçin',
                style: TextStyle(color: Colors.white70),
              ),
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 0.90,
                  child: Text('90%', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 0.95,
                  child: Text('95%', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 0.99,
                  child: Text('99%', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _confidenceLevel = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calculateConfidenceInterval,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Hesapla',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white, // Sonuç metni beyaz
              ),
            ),
          ],
        ),
      ),
    );
  }
}
