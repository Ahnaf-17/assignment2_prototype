import 'package:flutter/material.dart';

/// Screen allowing the user to submit a prayer request. The request content is
/// captured in a text field. When submitted, a simple confirmation message
/// appears. In a real app, the request would be sent to the backend.
class PrayerRequestScreen extends StatefulWidget {
  const PrayerRequestScreen({super.key});

  static const String routeName = '/prayer_request';

  @override
  State<PrayerRequestScreen> createState() => _PrayerRequestScreenState();
}

class _PrayerRequestScreenState extends State<PrayerRequestScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _submitted
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      'Your request has been sent.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your prayer request below:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your request...'
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _submitted = true;
                      });
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}