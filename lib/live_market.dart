import 'package:flutter/material.dart';

class LiveMarketPage extends StatefulWidget {
  @override
  _LiveMarketPageState createState() => _LiveMarketPageState();
}

class _LiveMarketPageState extends State<LiveMarketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BIST Prices'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Şimdilik Borsa İstanbul\'un grafik API\'lerini bekliyoruz.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Yakında burada BIST 100 ve çeşitli grafikler göreceksiniz.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Our API code is ready, but I cannot use it. It seems that integrating it into the Dart language will be a difficult process.
