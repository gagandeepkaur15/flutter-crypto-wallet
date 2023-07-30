import 'package:flutter/material.dart';
import 'transaction_model.dart';

class TList extends StatelessWidget {
  final Result data;
  final String address;
  const TList({super.key, required this.data, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              data.hash!.substring(0, 15) + '...',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                (double.parse(data.value!) / 1000000000000000000).toString(),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            data.toAddress != address
                ? const Icon(
                    Icons.arrow_upward,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.arrow_downward,
                    color: Colors.green,
                  ),
          ],
        ),
      ),
    );
  }
}
