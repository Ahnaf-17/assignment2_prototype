import 'package:flutter/material.dart';

import 'course_enrolment_screen.dart';

/// A screen that displays detailed information about a selected course. The
/// course data is passed via the [arguments] parameter of Navigator.pushNamed.
class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  static const String routeName = '/course_detail';

  @override
  Widget build(BuildContext context) {
    // Retrieve course information from the navigation arguments. If no
    // arguments are provided, fall back to an empty map to avoid null checks.
    final Map<String, String> course =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {};
    return Scaffold(
      appBar: AppBar(
        title: Text(course['name'] ?? 'Course Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['name'] ?? 'Course',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Level: ${course['level'] ?? '-'}'),
            Text('Schedule: ${course['schedule'] ?? '-'}'),
            Text('Cost: ${course['cost'] ?? '-'}'),
            Text('Mode: ${course['mode'] ?? '-'}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  CourseEnrolmentScreen.routeName,
                  arguments: course,
                );
              },
              child: const Text('Enrol'),
            ),
          ],
        ),
      ),
    );
  }
}