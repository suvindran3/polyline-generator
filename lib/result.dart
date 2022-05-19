import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key, required this.encodedPolyline})
      : super(key: key);

  final String encodedPolyline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Encoded Polyline',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width / 2,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => Clipboard.setData(
                            ClipboardData(text: encodedPolyline)),
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Text(
                            encodedPolyline,
                            softWrap: true,
                            style: const TextStyle(height: 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
