import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/events_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/event_booking_screen.dart';
import 'screens/prayer_request_screen.dart';
import 'screens/donation_screen.dart';
import 'screens/membership_screen.dart';
import 'screens/renew_membership_screen.dart';
import 'screens/course_enrolment_screen.dart';

void main() {
  runApp(const MyApp());
}

/// The root of the application. This widget sets up Material3 theming and routes
/// for all of the prototype screens. Navigation is handled using named routes
/// defined in the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KICC Community App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      // Define initial route and a map of routes to corresponding widgets. This
      // makes it easy to navigate between screens using Navigator.pushNamed.
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        CoursesScreen.routeName: (context) => const CoursesScreen(),
        CourseDetailScreen.routeName: (context) => const CourseDetailScreen(),
        CourseEnrolmentScreen.routeName: (context) => const CourseEnrolmentScreen(),
        EventsScreen.routeName: (context) => const EventsScreen(),
        EventDetailScreen.routeName: (context) => const EventDetailScreen(),
        EventBookingScreen.routeName: (context) => const EventBookingScreen(),
        PrayerRequestScreen.routeName: (context) => const PrayerRequestScreen(),
        DonationScreen.routeName: (context) => const DonationScreen(),
        MembershipScreen.routeName: (context) => const MembershipScreen(),
        RenewMembershipScreen.routeName: (context) => const RenewMembershipScreen(),
      },
    );
  }
}