import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerate extends StatefulWidget {
  const QRGenerate({super.key});

  @override
  State<QRGenerate> createState() => _QRGenerateState();
}

class _QRGenerateState extends State<QRGenerate> {
  TextEditingController _cont = TextEditingController();
  String data = '';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _cont,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Enter the address"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  data = _cont.text;
                });
              },
              child: const Text('Generate QR'),
            ),
            Center(
              child: QrImage(
                data: data,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
