import 'package:flutter/material.dart';

import 'event_booking_screen.dart';

/// Shows detailed information about a selected event, including time, location
/// and cost. Provides a button to book (RSVP) for the event.
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  static const String routeName = '/event_detail';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> event =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {};
    return Scaffold(
      appBar: AppBar(
        title: Text(event['title'] ?? 'Event Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'] ?? 'Event',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Type: ${event['type'] ?? '-'}'),
            Text('Time: ${event['time'] ?? '-'}'),
            Text('Location: ${event['location'] ?? '-'}'),
            Text('Cost: ${event['cost'] ?? '-'}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EventBookingScreen.routeName,
                  arguments: event,
                );
              },
              child: const Text('Book'),
            ),
          ],
        ),
      ),
    );
  }
}