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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color.fromARGB(225, 248, 86, 88),
                  ),
                ),
                labelText: 'Enter address',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
                // isDense: true,
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color.fromARGB(225, 248, 86, 88),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color.fromARGB(225, 248, 86, 88),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  data = _cont.text;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(225, 248, 86, 88),
              ),
              child: const Text('Generate QR'),
            ),
            Container(
              height: 220,
              width: 220,
              color: Colors.white,
              child: Center(
                child: QrImage(
                  data: data,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
