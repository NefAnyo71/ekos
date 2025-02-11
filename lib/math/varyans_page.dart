import 'package:flutter/material.dart';

class VaryansPage extends StatefulWidget {
  const VaryansPage({super.key});

  @override
  _VaryansPageState createState() => _VaryansPageState();
}

class _VaryansPageState extends State<VaryansPage> {
  final TextEditingController _controllerN = TextEditingController();
  final TextEditingController _controllerMu = TextEditingController();
  final TextEditingController _controllerX = TextEditingController();
  final TextEditingController _controllerXBar = TextEditingController();

  double _result = 0.0;
  String _errorMessage = '';

  // Popülasyon Varyansını Hesapla
  void _calculatePopulationVariance() {
    try {
      final N = int.parse(_controllerN.text);
      final mu = double.parse(_controllerMu.text);
      final numbers = _controllerX.text.split(',').map(double.parse).toList();

      if (numbers.length != N) {
        throw 'Veri sayısı ile popülasyon büyüklüğü uyumsuz.';
      }

      final variance =
          numbers.map((x) => (x - mu) * (x - mu)).reduce((a, b) => a + b) / N;

      setState(() {
        _result = variance;
        _errorMessage = ''; // Hata mesajını temizle
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Hata: $e';
        _result = 0.0;
      });
    }
  }

  // Örneklem Varyansını Hesapla
  void _calculateSampleVariance() {
    try {
      final n = int.parse(_controllerN.text);
      final xBar = double.parse(_controllerXBar.text);
      final numbers = _controllerX.text.split(',').map(double.parse).toList();

      if (numbers.length != n) {
        throw 'Veri sayısı ile örneklem büyüklüğü uyumsuz.';
      }

      final variance =
          numbers.map((x) => (x - xBar) * (x - xBar)).reduce((a, b) => a + b) /
              (n - 1);

      setState(() {
        _result = variance;
        _errorMessage = ''; // Hata mesajını temizle
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Hata: $e';
        _result = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _controllerN.dispose();
    _controllerMu.dispose();
    _controllerX.dispose();
    _controllerXBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Varyans Hesaplama'),
      ),
      body: Container(
        color: Colors.grey[900], // Arka plan rengini koyu tutuyoruz
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Popülasyon Varyansı Formülü:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Text(
                'σ² = Σ (xᵢ - μ)² / N',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Örneklem Varyansı Formülü:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Text(
                's² = Σ (xᵢ - x̄)² / (n - 1)',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Değerleri girin:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllerN,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Popülasyon/Örneklem Büyüklüğü (N/n)',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black12, // Arka plan rengi
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllerMu,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Popülasyon Ortalaması (μ)',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllerX,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Veri Noktaları (x₁, x₂, ...)',
                  hintText: 'Örnek: 1,2,3,4,5',
                  hintStyle: TextStyle(color: Colors.white70),
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllerXBar,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Örneklem Ortalaması (x̄)',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculatePopulationVariance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Popülasyon Varyansını Hesapla'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _calculateSampleVariance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Örneklem Varyansını Hesapla'),
              ),
              const SizedBox(height: 20),
              Text(
                'Sonuç: $_result',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
