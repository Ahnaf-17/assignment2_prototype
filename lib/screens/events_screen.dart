import 'package:flutter/material.dart';

import 'event_detail_screen.dart';

/// Displays a list of upcoming events. Users can filter events by type and
/// select an event to view details and book. Data is hard-coded for
/// demonstration.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  static const String routeName = '/events';

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Hard-coded list of example events. Each entry includes a title, type,
  // time, location, and cost. In a real app this would come from a backend.
  final List<Map<String, String>> _events = [
    {
      'title': 'Community Lunch',
      'type': 'Lunch',
      'time': 'Sun 12:30pm',
      'location': 'KICC Hall',
      'cost': 'Free',
    },
    {
      'title': 'Dance Night',
      'type': 'Dance',
      'time': 'Fri 7:00pm',
      'location': 'Community Centre',
      'cost': '\$15',
    },
    {
      'title': 'Bocce Tournament',
      'type': 'Bocce',
      'time': 'Sat 3:00pm',
      'location': 'Sports Ground',
      'cost': '\$10',
    },
  ];

  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    // Filter events based on selected type. If no type is selected show all.
    final List<Map<String, String>> filteredEvents = _selectedType == null
        ? _events
        : _events
            .where((event) => event['type'] == _selectedType)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Filter by type',
                border: OutlineInputBorder(),
              ),
              items: <String?>[null, 'Lunch', 'Dance', 'Bocce']
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type ?? 'All'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value == '' ? null : value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(event['title']!),
                    subtitle: Text(event['time'] ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        EventDetailScreen.routeName,
                        arguments: event,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}