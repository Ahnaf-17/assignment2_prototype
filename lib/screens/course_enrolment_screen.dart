import 'package:flutter/material.dart';


class CourseEnrolmentScreen extends StatefulWidget {
  const CourseEnrolmentScreen({super.key});

  static const String routeName = '/course_enrolment';

  @override
  State<CourseEnrolmentScreen> createState() => _CourseEnrolmentScreenState();
}

class _CourseEnrolmentScreenState extends State<CourseEnrolmentScreen> {
  bool _isProcessing = false;
  bool _enrolled = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> course =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Enrol in ${course['name'] ?? 'Course'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _enrolled
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      'You are enrolled!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm enrolment for ${course['name'] ?? 'course'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  _isProcessing
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isProcessing = true;
                            });
                            // Simulate network/payment processing delay.
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              _isProcessing = false;
                              _enrolled = true;
                            });
                          },
                          child: const Text('Confirm Enrolment'),
                        ),
                ],
              ),
      ),
    );
  }
}