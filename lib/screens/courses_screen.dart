import 'package:flutter/material.dart';

import 'course_detail_screen.dart';

/// Screen displaying a list of available short courses. Each item navigates to
/// a detail screen when tapped. Data is currently hard-coded but could
/// eventually come from a data source or API.
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  static const String routeName = '/courses';

  // Hard-coded list of example courses. Each entry contains a name, level,
  // schedule, cost and delivery mode for demonstration purposes.
  static final List<Map<String, String>> _courses = [
    {
      'name': 'Basic Bible Study',
      'level': 'Beginner',
      'schedule': 'Wednesdays 6pm',
      'cost': 'Free',
      'mode': 'Online',
    },
    {
      'name': 'Leadership Skills',
      'level': 'Intermediate',
      'schedule': 'Saturdays 10am',
      'cost': '\$50',
      'mode': 'On-site',
    },
    {
      'name': 'Community Outreach',
      'level': 'Advanced',
      'schedule': 'Tuesdays 7pm',
      'cost': '\$30',
      'mode': 'Hybrid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(course['name']!),
              subtitle: Text('Level: ${course['level']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CourseDetailScreen.routeName,
                  arguments: course,
                );
              },
            ),
          );
        },
      ),
    );
  }
}