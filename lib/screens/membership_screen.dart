import 'package:flutter/material.dart';

import 'renew_membership_screen.dart';

/// Displays membership information such as status and renewal date. Provides an
/// option for the user to renew their membership.
class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  static const String routeName = '/membership';

  @override
  Widget build(BuildContext context) {
    // For prototype purposes, membership status and expiry are hard-coded.
    const String status = 'Active';
    const String renewalDate = '2024-12-31';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: $status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Renewal date: $renewalDate'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RenewMembershipScreen.routeName);
              },
              child: const Text('Renew Membership'),
            ),
          ],
        ),
      ),
    );
  }
}