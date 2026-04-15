import 'package:flutter/material.dart';

/// A screen that allows the user to confirm booking (RSVP) for an event. If
/// payment is required, a simulated payment flow is provided. After booking,
/// the event is added to the user's list.
class EventBookingScreen extends StatefulWidget {
  const EventBookingScreen({super.key});

  static const String routeName = '/event_booking';

  @override
  State<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  bool _isProcessing = false;
  bool _booked = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> event =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {};
    final bool paymentRequired = (event['cost'] ?? 'Free').toLowerCase() != 'free';

    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${event['title'] ?? 'Event'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _booked
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      'Booking confirmed!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm your booking for ${event['title'] ?? 'event'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  if (paymentRequired)
                    Text('Payment of ${event['cost']} required.'),
                  const SizedBox(height: 16),
                  _isProcessing
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isProcessing = true;
                            });
                            // Simulate payment processing delay
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              _isProcessing = false;
                              _booked = true;
                            });
                          },
                          child: Text(paymentRequired
                              ? 'Pay & Confirm Booking'
                              : 'Confirm Booking'),
                        ),
                ],
              ),
      ),
    );
  }
}