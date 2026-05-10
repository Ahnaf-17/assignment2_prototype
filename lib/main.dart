import 'package:flutter/material.dart';

void main() {
  runApp(const KiccApp());
}

class KiccApp extends StatefulWidget {
  const KiccApp({super.key});

  @override
  State<KiccApp> createState() => _KiccAppState();
}

class _KiccAppState extends State<KiccApp> {
  double textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KICC Community App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3C6E71),
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: MainShell(
        textScale: textScale,
        onTextScaleChanged: (value) {
          setState(() {
            textScale = value;
          });
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.textScale,
    required this.onTextScaleChanged,
  });

  final double textScale;
  final ValueChanged<double> onTextScaleChanged;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  void goToPage(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onNavigate: goToPage),
      const EventsPage(),
      const CoursesPage(),
      const MembershipPage(),
      SettingsPage(
        textScale: widget.textScale,
        onTextScaleChanged: widget.onTextScaleChanged,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: goToPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Membership',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_fields_outlined),
            selectedIcon: Icon(Icons.text_fields),
            label: 'Text',
          ),
        ],
      ),
      // floatingActionButton: index == 0
      //     ? FloatingActionButton.extended(
      //         onPressed: () => goToPage(1),
      //         icon: const Icon(Icons.event_available),
      //         label: const Text('Upcoming Events'),
      //       )
      //     : null,
      floatingActionButton: null,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Welcome, Giovanna',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your next club activities and membership actions are below.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),

        SectionHeader(
          title: 'Upcoming events',
          actionLabel: 'See all',
          onPressed: () => onNavigate(1),
        ),
        const SizedBox(height: 12),
        UpcomingEventHighlight(onPressed: () => onNavigate(1)),

        const SizedBox(height: 24),

        SectionHeader(
          title: 'Continue learning',
          actionLabel: 'Courses',
          onPressed: () => onNavigate(2),
        ),
        const SizedBox(height: 12),
        const SimpleListRow(
          icon: Icons.play_circle_outline,
          title: 'Beginner Bocce Skills',
          subtitle: 'Lesson 2 of 4 · 6 min remaining',
          primaryLabel: 'Resume',
        ),
        const Divider(height: 28),
        const SimpleListRow(
          icon: Icons.school_outlined,
          title: 'Volunteering Basics',
          subtitle: 'Starts Friday · 3 short lessons',
          primaryLabel: 'View course',
        ),

        const SizedBox(height: 24),

        SectionHeader(
          title: 'Quick actions',
          actionLabel: '',
          onPressed: null,
        ),
        const SizedBox(height: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: () => onNavigate(3),
              icon: const Icon(Icons.badge),
              label: const Text('Renew membership'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrayerRequestScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.favorite_border),
              label: const Text('Prayer request'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DonationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.volunteer_activism_outlined),
              label: const Text('Donate'),
            ),
          ],
        ),
      ],
    );
  }
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController = TabController(length: 3, vsync: this);
  int selectedEventId = 1;

  final List<EventItem> events = const [
    EventItem(
      id: 1,
      title: 'Seniors Lunch',
      time: 'Today · 12:30 PM',
      location: 'Main Hall',
      category: 'Community',
      paid: false,
    ),
    EventItem(
      id: 2,
      title: 'Bingo Afternoon',
      time: 'Thursday · 2:00 PM',
      location: 'Games Room',
      category: 'Community',
      paid: false,
    ),
    EventItem(
      id: 3,
      title: 'Bocce Practice',
      time: 'Saturday · 10:00 AM',
      location: 'Outdoor Court',
      category: 'Sport',
      paid: true,
    ),
    EventItem(
      id: 4,
      title: 'Cultural Dance Night',
      time: 'Saturday · 7:00 PM',
      location: 'Ballroom',
      category: 'Culture',
      paid: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['Community', 'Sport', 'Culture'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        final selectedCategory = categories[tabController.index];

        final filteredEvents = events
            .where((event) => event.category == selectedCategory)
            .toList();

        final selectedEvent = filteredEvents.firstWhere(
          (event) => event.id == selectedEventId,
          orElse: () => filteredEvents.first,
        );

        final listPane = Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Events',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Event reminders turned on'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Remind me'),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: tabController,
              onTap: (_) {
                setState(() {
                  selectedEventId = filteredEvents.first.id;
                });
              },
              tabs: const [
                Tab(text: 'Community'),
                Tab(text: 'Sport'),
                Tab(text: 'Culture'),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filteredEvents.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      child: Icon(
                        event.paid
                            ? Icons.confirmation_num_outlined
                            : Icons.groups_2_outlined,
                      ),
                    ),
                    title: Text(event.title),
                    subtitle: Text('${event.time}\n${event.location}'),
                    isThreeLine: true,
                    trailing: isWide ? null : const Icon(Icons.chevron_right),
                    onTap: () {
                      if (isWide) {
                        setState(() {
                          selectedEventId = event.id;
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailsPage(event: event),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );

        if (isWide) {
          return Row(
            children: [
              SizedBox(width: 360, child: listPane),
              const VerticalDivider(width: 1),
              Expanded(child: EventDetailsContent(event: selectedEvent)),
            ],
          );
        }

        return listPane;
      },
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event details')),
      body: EventDetailsContent(event: event),
    );
  }
}

class EventDetailsContent extends StatelessWidget {
  const EventDetailsContent({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(
          Icons.event_available,
          size: 56,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          event.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(event.time, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(event.location),
        const SizedBox(height: 24),
        Text(
          event.paid
              ? 'This is a paid event. Payment confirmation will be shown before final booking.'
              : 'This event is free for members.',
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Booking confirmed'),
                content: Text(
                  'You have successfully booked ${event.title}.',
                ),
                actions: [
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Book this event'),
        ),
      ],
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  final List<CourseItem> courses = const [
    CourseItem(
      title: 'Beginner Bocce Skills',
      duration: '4 short lessons',
      level: 'Beginner',
      description: 'Learn the basic rules, scoring and safe play techniques.',
    ),
    CourseItem(
      title: 'Volunteering Basics',
      duration: '3 short lessons',
      level: 'Beginner',
      description: 'Understand how to support club events confidently.',
    ),
    CourseItem(
      title: 'Italian Culture Workshop',
      duration: '5 short lessons',
      level: 'All levels',
      description: 'Explore food, music and community traditions.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Short Courses',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Small, practical lessons for KICC members.',
        ),
        const SizedBox(height: 24),
        for (final course in courses) ...[
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            leading: const CircleAvatar(child: Icon(Icons.menu_book)),
            title: Text(course.title),
            subtitle: Text('${course.level} · ${course.duration}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailsPage(course: course),
                ),
              );
            },
          ),
          const Divider(),
        ],
      ],
    );
  }
}

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({super.key, required this.course});

  final CourseItem course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course details')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            course.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text('${course.level} · ${course.duration}'),
          const SizedBox(height: 20),
          Text(course.description),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Enrolment confirmed'),
                  content: Text(
                    'You are now enrolled in ${course.title}.',
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.school),
            label: const Text('Enrol in course'),
          ),
        ],
      ),
    );
  }
}

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: 'Giovanna Russo');
  final emailController = TextEditingController(text: 'giovanna@example.com');
  String selectedPlan = 'Standard';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void confirmRenewal() {
    if (!formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm membership renewal'),
        content: Text(
          'Name: ${nameController.text}\n'
          'Email: ${emailController.text}\n'
          'Plan: $selectedPlan\n\n'
          'Do you want to confirm renewal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Membership renewed'),
                  content: const Text(
                    'Your membership has been renewed successfully.',
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = const [
      MembershipPlan(
        name: 'Standard',
        price: '\$20',
        detail: 'Basic access to club events and member updates.',
      ),
      MembershipPlan(
        name: 'Premium',
        price: '\$40',
        detail: 'Includes priority booking and selected course discounts.',
      ),
      MembershipPlan(
        name: 'Social',
        price: '\$15',
        detail: 'Suitable for casual participation in social activities.',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Membership',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        const Text('Status: Active · Renewal due soon'),
        const SizedBox(height: 24),

        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your name'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || !value.contains('@')
                        ? 'Enter a valid email'
                        : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Text(
          'Choose membership type',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),

        for (final plan in plans)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedPlan = plan.name;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: const BoxConstraints(minHeight: 72),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selectedPlan == plan.name
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    width: selectedPlan == plan.name ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedPlan == plan.name
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${plan.name} (${plan.price})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(plan.detail),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: confirmRenewal,
          icon: const Icon(Icons.payment),
          label: const Text('Continue to payment'),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.textScale,
    required this.onTextScaleChanged,
  });

  final double textScale;
  final ValueChanged<double> onTextScaleChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Text size',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Adjust text size to make the app easier to read.',
        ),
        const SizedBox(height: 24),
        Slider(
          value: textScale,
          min: 0.9,
          max: 1.4,
          divisions: 5,
          label: textScale.toStringAsFixed(1),
          onChanged: onTextScaleChanged,
        ),
        const SizedBox(height: 16),
        Text(
          'Sample readable text for Giovanna.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class PrayerRequestScreen extends StatelessWidget {
  const PrayerRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: 'Giovanna Russo');
    final requestController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Request')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Submit your prayer request',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: requestController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Prayer request',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prayer request submitted')),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.favorite),
            label: const Text('Submit request'),
          ),
        ],
      ),
    );
  }
}

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: 'Giovanna Russo');
  final amountController = TextEditingController();
  String donationType = 'General support';

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void confirmDonation() {
    if (!formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm donation'),
        content: Text(
          'Donor: ${nameController.text}\n'
          'Amount: \$${amountController.text}\n'
          'Purpose: $donationType\n\n'
          'Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              showSuccess();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Donation successful'),
        content: const Text(
          'Thank you for supporting the KICC community. A receipt has been sent.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final donationOptions = [
      'General support',
      'Seniors activities',
      'Short courses',
      'Community events',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Donate')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Support KICC',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose an amount and purpose for your donation.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Enter your name'
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Donation amount',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter an amount';
                    }

                    final amount = double.tryParse(value);

                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Donation purpose',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (final option in donationOptions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          donationType = option;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 56),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: donationType == option
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            width: donationType == option ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              donationType == option
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: confirmDonation,
                    icon: const Icon(Icons.volunteer_activism),
                    label: const Text('Continue to donate'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        if (actionLabel.isNotEmpty && onPressed != null)
          TextButton(
            onPressed: onPressed,
            child: Text(actionLabel),
          ),
      ],
    );
  }
}

class UpcomingEventHighlight extends StatelessWidget {
  const UpcomingEventHighlight({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.event_available, size: 36),
            const SizedBox(height: 12),
            Text(
              'Next: Seniors Lunch',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Today · 12:30 PM · Main Hall',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onPressed,
              child: const Text('View upcoming events'),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleListRow extends StatelessWidget {
  const SimpleListRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 34),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
        FilledButton.tonal(
          onPressed: () {},
          child: Text(primaryLabel),
        ),
      ],
    );
  }
}

class EventItem {
  const EventItem({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.category,
    required this.paid,
  });

  final int id;
  final String title;
  final String time;
  final String location;
  final String category;
  final bool paid;
}

class CourseItem {
  const CourseItem({
    required this.title,
    required this.duration,
    required this.level,
    required this.description,
  });

  final String title;
  final String duration;
  final String level;
  final String description;
}

class MembershipPlan {
  const MembershipPlan({
    required this.name,
    required this.price,
    required this.detail,
  });

  final String name;
  final String price;
  final String detail;
}