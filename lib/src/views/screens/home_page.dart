import 'package:flutter/material.dart';
import 'package:video_call_app/src/views/screens/video_call_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => const VideoCallPage()),
                  ),
                );
              },
              icon: const Icon(
                Icons.video_call,
                color: Colors.red,
              ),
              label: const Text(
                'Call to your friend',
              ),
            )
          ],
        ),
      ),
    );
  }
}
