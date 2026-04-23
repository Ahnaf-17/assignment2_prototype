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
      debugShowCheckedModeBanner: false,
      title: 'KICC Community App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3C6E71),
        visualDensity: VisualDensity.standard,
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
        onTextScaleChanged: (value) => setState(() => textScale = value),
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onNavigate: _goTo),
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
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge), label: 'Membership'),
          NavigationDestination(icon: Icon(Icons.text_fields_outlined), selectedIcon: Icon(Icons.text_fields), label: 'Text'),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _goTo(1),
              icon: const Icon(Icons.event_available),
              label: const Text('Upcoming Events'),
            )
          : null,
    );
  }

  void _goTo(int newIndex) {
    setState(() => index = newIndex);
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
        Text('Welcome, Giovanna', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Your next club activities and membership actions are below.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'Upcoming events',
          actionLabel: 'See all',
          onPressed: () => onNavigate(1),
        ),
        const SizedBox(height: 12),
        _UpcomingEventHighlight(onPressed: () => onNavigate(1)),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'Continue learning',
          actionLabel: 'Courses',
          onPressed: () => onNavigate(2),
        ),
        const SizedBox(height: 12),
        const _SimpleListRow(
          icon: Icons.play_circle_outline,
          title: 'Beginner Bocce Skills',
          subtitle: 'Lesson 2 of 4 · 6 min remaining',
          primaryLabel: 'Resume',
        ),
        const Divider(height: 28),
        const _SimpleListRow(
          icon: Icons.school_outlined,
          title: 'Volunteering Basics',
          subtitle: 'Starts Friday · 3 short lessons',
          primaryLabel: 'View course',
        ),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'Quick actions',
          actionLabel: '',
          onPressed: null,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => onNavigate(3),
              icon: const Icon(Icons.badge),
              label: const Text('Renew membership'),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
              label: const Text('Prayer request'),
            ),
            TextButton.icon(
              onPressed: () {},
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

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);
  int? selectedEventId;

  final List<EventItem> allEvents = const [
    EventItem(1, 'Seniors Lunch', 'Today · 12:30 PM', 'Main Hall', 'Community', false),
    EventItem(2, 'Bingo Afternoon', 'Thursday · 2:00 PM', 'Games Room', 'Community', false),
    EventItem(3, 'Bocce Practice', 'Saturday · 10:00 AM', 'Outdoor Court', 'Sport', true),
    EventItem(4, 'Cultural Dance Night', 'Saturday · 7:00 PM', 'Ballroom', 'Culture', true),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['Community', 'Sport', 'Culture'];
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        final currentCategory = categories[_tabController.index.clamp(0, categories.length - 1)];
        final items = allEvents.where((e) => e.category == currentCategory).toList();
        final selected = selectedEventId == null
            ? (items.isNotEmpty ? items.first : null)
            : items.firstWhere(
                (e) => e.id == selectedEventId,
                orElse: () => items.first,
              );

        Widget listPane = Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Events', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Remind me'),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              onTap: (_) => setState(() => selectedEventId = null),
              tabs: const [
                Tab(text: 'Community'),
                Tab(text: 'Sport'),
                Tab(text: 'Culture'),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final event = items[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    title: Text(event.title),
                    subtitle: Text('${event.time}\n${event.location}'),
                    isThreeLine: true,
                    leading: CircleAvatar(child: Icon(event.paid ? Icons.confirmation_num_outlined : Icons.groups_2_outlined)),
                    trailing: wide ? null : const Icon(Icons.chevron_right),
                    onTap: () {
                      if (wide) {
                        setState(() => selectedEventId = event.id);
                      } else {
                        Navigator.of(context).push(
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

        if (!wide) return listPane;

        return Row(
          children: [
            SizedBox(width: 360, child: listPane),
            const VerticalDivider(width: 1),
            Expanded(
              child: selected == null
                  ? const Center(child: Text('Select an event'))
                  : EventDetailsPanel(event: selected),
            ),
          ],
        );
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
      body: EventDetailsPanel(event: event),
    );
  }
}

class EventDetailsPanel extends StatelessWidget {
  const EventDetailsPanel({super.key, required this.event});

  final EventItem event;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(event.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(event.time, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(event.location, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        Text(
          'Join friends at this KICC event. Booking confirms your place and sends a reminder before it starts.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Booking confirmed'),
                content: Text(
                  event.paid
                      ? 'Your event ticket is reserved. You will see the payment confirmation in your email.'
                      : 'Your place is reserved. A reminder will be sent before the event.',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                ],
              ),
            );
          },
          icon: const Icon(Icons.event_available),
          label: Text(event.paid ? 'Book and pay' : 'Book event'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.calendar_month_outlined),
          label: const Text('Add reminder'),
        ),
      ],
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = const [
      ('Beginner Bocce Skills', '4 short lessons · 5–7 min each', true),
      ('Volunteering Basics', '3 short lessons · New this week', false),
      ('Italian Culture Workshop', '2 short lessons · In person + app notes', false),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: courses.length + 1,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Short courses', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Short, simple lessons that are easy to continue later.', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
            ],
          );
        }
        final course = courses[index - 1];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Icon(course.$3 ? Icons.play_circle_fill : Icons.school_outlined, size: 32),
          title: Text(course.$1),
          subtitle: Text(course.$2),
          trailing: course.$3
              ? FilledButton(onPressed: () {}, child: const Text('Resume'))
              : OutlinedButton(onPressed: () {}, child: const Text('View')),
        );
      },
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
  final phoneController = TextEditingController(text: '0400 000 000');
  String membership = 'Standard';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Membership', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Renew your details and choose the membership that suits you.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter your full name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone number', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter your phone number' : null,
              ),
              const SizedBox(height: 20),
              Text('Choose a membership', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _MembershipOption(
                title: 'Standard',
                subtitle: 'Access to club events and weekly social activities',
                price: '20/year',
                selected: membership == 'Standard',
                onTap: () => setState(() => membership = 'Standard'),
              ),
              const SizedBox(height: 12),
              _MembershipOption(
                title: 'Premium',
                subtitle: 'Standard benefits plus priority booking and discounted paid events',
                price: '40/year',
                selected: membership == 'Premium',
                onTap: () => setState(() => membership = 'Premium'),
              ),
              const SizedBox(height: 12),
              _MembershipOption(
                title: 'Social',
                subtitle: 'For casual members who attend selected events only',
                price: '15/year',
                selected: membership == 'Social',
                onTap: () => setState(() => membership = 'Social'),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.payment),
                label: const Text('Pay and renew'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Ask staff for help'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment confirmation'),
        content: Text('Your $membership membership has been renewed for Giovanna Russo. A receipt has been sent.'),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.textScale, required this.onTextScaleChanged});

  final double textScale;
  final ValueChanged<double> onTextScaleChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Text size', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Adjust the text size for easier reading.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        SegmentedButton<double>(
          segments: const [
            ButtonSegment(value: 1.0, label: Text('Standard')),
            ButtonSegment(value: 1.15, label: Text('Large')),
            ButtonSegment(value: 1.3, label: Text('Extra large')),
          ],
          selected: {textScale},
          onSelectionChanged: (selection) => onTextScaleChanged(selection.first),
        ),
        const SizedBox(height: 24),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.check_circle_outline),
          title: Text('Large buttons enabled'),
          subtitle: Text('Tap targets are kept spacious for easier selection.'),
        ),
      ],
    );
  }
}

class _MembershipOption extends StatelessWidget {
  const _MembershipOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          color: selected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(.4) : null,
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(price, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel, this.onPressed});

  final String title;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        if (actionLabel.isNotEmpty)
          TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}

class _UpcomingEventHighlight extends StatelessWidget {
  const _UpcomingEventHighlight({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Next event', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text('Seniors Lunch', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Today · 12:30 PM · Main Hall', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          FilledButton(onPressed: onPressed, child: const Text('View upcoming events')),
        ],
      ),
    );
  }
}

class _SimpleListRow extends StatelessWidget {
  const _SimpleListRow({required this.icon, required this.title, required this.subtitle, required this.primaryLabel});

  final IconData icon;
  final String title;
  final String subtitle;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.tonal(onPressed: () {}, child: Text(primaryLabel)),
      ],
    );
  }
}

class EventItem {
  const EventItem(this.id, this.title, this.time, this.location, this.category, this.paid);

  final int id;
  final String title;
  final String time;
  final String location;
  final String category;
  final bool paid;
}
