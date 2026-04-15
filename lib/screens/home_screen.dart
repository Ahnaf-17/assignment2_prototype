import 'package:flutter/material.dart';

import 'courses_screen.dart';
import 'events_screen.dart';
import 'prayer_request_screen.dart';
import 'donation_screen.dart';
import 'membership_screen.dart';

/// The landing page for the prototype application. It presents a list of the
/// major tasks available to the user as described in the activity diagrams.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KICC Community'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNavigationCard(
            context,
            title: 'Courses',
            subtitle: 'Browse and enrol in short courses',
            routeName: CoursesScreen.routeName,
          ),
          _buildNavigationCard(
            context,
            title: 'Events',
            subtitle: 'View and book upcoming events',
            routeName: EventsScreen.routeName,
          ),
          _buildNavigationCard(
            context,
            title: 'Prayer Requests',
            subtitle: 'Submit a personal prayer request',
            routeName: PrayerRequestScreen.routeName,
          ),
          _buildNavigationCard(
            context,
            title: 'Donate',
            subtitle: 'Make a donation to support the community',
            routeName: DonationScreen.routeName,
          ),
          _buildNavigationCard(
            context,
            title: 'Membership',
            subtitle: 'Check status and renew your membership',
            routeName: MembershipScreen.routeName,
          ),
        ],
      ),
    );
  }

  /// Builds a clickable card that navigates to the given route when tapped.
  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String routeName,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}