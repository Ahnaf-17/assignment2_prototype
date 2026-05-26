
import 'package:flutter/material.dart';

void main() => runApp(const KiccApp());

/// Final COIT20270 Assignment 4 app.
/// Design focus:
/// - Fewer primary navigation destinations to reduce cognitive load.
/// - Interactive flows rather than static screens.
/// - Consistent responsive layout for mobile, tablet, and desktop/DartPad.
/// - Material 3 components with standard page transitions.
/// - Central ChangeNotifier state management so UI updates consistently.
class KiccApp extends StatelessWidget {
  const KiccApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: AppController(),
      child: const KiccThemeHost(),
    );
  }
}

class KiccThemeHost extends StatelessWidget {
  const KiccThemeHost({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return MaterialApp(
      title: 'KICC Community App',
      debugShowCheckedModeBanner: false,
      themeMode: app.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F6F73),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F6F73),
        brightness: Brightness.dark,
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(app.textScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const MainShell(),
    );
  }
}

/// Central app state. This is stronger than scattered local state because bookings,
/// reminders, enrolments, donations and user details update across screens.
class AppController extends ChangeNotifier {
  String name = 'Giovanna Russo';
  String email = 'giovanna@example.com';

  bool darkMode = false;
  double textScale = 1.0;

  int selectedTab = 0;
  String membershipPlan = 'Standard';
  bool membershipSubmitted = false;

  final Set<int> bookedEvents = {};
  final Set<int> eventReminders = {};
  final Set<String> enrolledCourses = {};
  final List<String> prayerRequests = [];
  final List<DonationRecord> donations = [];
  final List<String> activityLog = [];

  void selectTab(int value) {
    selectedTab = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void setTextScale(double value) {
    textScale = value;
    notifyListeners();
  }

  void toggleReminder(int eventId, String title) {
    if (eventReminders.contains(eventId)) {
      eventReminders.remove(eventId);
      addActivity('Reminder removed: $title');
    } else {
      eventReminders.add(eventId);
      addActivity('Reminder added: $title');
    }
    notifyListeners();
  }

  void bookEvent(EventItem event) {
    bookedEvents.add(event.id);
    addActivity('Booked event: ${event.title}');
    notifyListeners();
  }

  void enrolCourse(CourseItem course) {
    enrolledCourses.add(course.title);
    addActivity('Enrolled course: ${course.title}');
    notifyListeners();
  }

  void submitMembership({
    required String newName,
    required String newEmail,
    required String plan,
  }) {
    name = newName;
    email = newEmail;
    membershipPlan = plan;
    membershipSubmitted = true;
    addActivity('Membership application submitted: $plan');
    notifyListeners();
  }

  void submitPrayer(String request) {
    prayerRequests.add(request);
    addActivity('Prayer request submitted');
    notifyListeners();
  }

  void addDonation(DonationRecord donation) {
    donations.add(donation);
    addActivity('Donation made: \$${donation.amount} for ${donation.purpose}');
    notifyListeners();
  }

  void addActivity(String message) {
    activityLog.insert(0, message);
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    return scope!.notifier!;
  }
}

// -------------------- MAIN SHELL --------------------

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    final pages = const [
      HomePage(),
      EventsPage(),
      CoursesPage(),
      MorePage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 820;

        return Scaffold(
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: app.selectedTab,
                  onDestinationSelected: app.selectTab,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.event_outlined),
                      selectedIcon: Icon(Icons.event),
                      label: Text('Events'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.more_horiz),
                      selectedIcon: Icon(Icons.more),
                      label: Text('More'),
                    ),
                  ],
                ),
              Expanded(
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(app.selectedTab),
                      child: pages[app.selectedTab],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: app.selectedTab,
                  onDestinationSelected: app.selectTab,
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
                      icon: Icon(Icons.more_horiz),
                      selectedIcon: Icon(Icons.more),
                      label: 'More',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// -------------------- HOME --------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final firstName = app.name.split(' ').first;

    return ResponsivePage(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Welcome, $firstName',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text('Find events, courses and member actions quickly.'),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Next event',
            actionLabel: 'All events',
            onPressed: () => app.selectTab(1),
          ),
          const SizedBox(height: 12),
          UpcomingEventTile(
            event: AppLists.events.first,
            onTap: () => app.selectTab(1),
          ),
          const SizedBox(height: 20),
          SectionHeader(title: 'Quick actions', actionLabel: '', onPressed: null),
          const SizedBox(height: 8),
          ActionGrid(
            children: [
              ActionTile(
                icon: Icons.badge_outlined,
                title: 'Membership',
                subtitle: app.membershipSubmitted ? 'Submitted' : 'Apply or renew',
                onTap: () => openPage(context, const MembershipPage()),
              ),
              ActionTile(
                icon: Icons.favorite_border,
                title: 'Prayer',
                subtitle: 'Send request',
                onTap: () => openPage(context, const PrayerRequestPage()),
              ),
              ActionTile(
                icon: Icons.volunteer_activism_outlined,
                title: 'Donate',
                subtitle: 'Support KICC',
                onTap: () => openPage(context, const DonationPage()),
              ),
              ActionTile(
                icon: Icons.dashboard_outlined,
                title: 'Activity',
                subtitle: 'Your updates',
                onTap: () => openPage(context, const ActivityPage()),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'My summary',
            actionLabel: 'Details',
            onPressed: () => openPage(context, const ActivityPage()),
          ),
          const SizedBox(height: 12),
          DashboardSummary(app: app),
        ],
      ),
    );
  }
}

// -------------------- EVENTS --------------------

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  late final TabController tabController = TabController(length: 3, vsync: this);
  int selectedEventId = 1;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final categories = ['Community', 'Sport', 'Culture'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final category = categories[tabController.index];
        final events = AppLists.events.where((e) => e.category == category).toList();

        if (!events.any((e) => e.id == selectedEventId)) {
          selectedEventId = events.first.id;
        }

        final selected = events.firstWhere((e) => e.id == selectedEventId);

        final listPane = Column(
          children: [
            const PageHeader(
              title: 'Events',
              subtitle: 'Tap an event to view details. Swipe right to toggle reminders.',
            ),
            TabBar(
              controller: tabController,
              onTap: (_) => setState(() {}),
              tabs: const [
                Tab(text: 'Community'),
                Tab(text: 'Sport'),
                Tab(text: 'Culture'),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: events.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final event = events[index];
                  final booked = app.bookedEvents.contains(event.id);
                  final reminded = app.eventReminders.contains(event.id);

                  /// Swipe gesture: users can swipe right to add or remove reminders.
                  return Dismissible(
                    key: ValueKey('event-${event.id}-$reminded'),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (_) async {
                      app.toggleReminder(event.id, event.title);
                      showMessage(
                        context,
                        app.eventReminders.contains(event.id)
                            ? 'Reminder added'
                            : 'Reminder removed',
                      );
                      return false;
                    },
                    background: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.notifications_active),
                    ),
                    child: ListTile(
                      selected: wide && selectedEventId == event.id,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      leading: CircleAvatar(
                        child: Icon(booked ? Icons.check : Icons.event),
                      ),
                      title: Text(event.title),
                      subtitle: Text(
                        '${event.time} · ${event.location}'
                        '${reminded ? '\nReminder on' : ''}'
                        '${booked ? '\nBooked' : ''}',
                      ),
                      isThreeLine: reminded || booked,
                      trailing: wide ? null : const Icon(Icons.chevron_right),
                      onTap: () {
                        if (wide) {
                          setState(() => selectedEventId = event.id);
                        } else {
                          openPage(context, EventDetailsPage(event: event));
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );

        if (wide) {
          return Row(
            children: [
              SizedBox(width: 380, child: listPane),
              const VerticalDivider(width: 1),
              Expanded(child: EventDetailsContent(event: selected)),
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

class EventDetailsContent extends StatefulWidget {
  const EventDetailsContent({super.key, required this.event});

  final EventItem event;

  @override
  State<EventDetailsContent> createState() => _EventDetailsContentState();
}

class _EventDetailsContentState extends State<EventDetailsContent> {
  bool loading = false;

  /// Paid events open a demo payment form before booking.
  /// Free events only need a confirmation dialog.
  Future<void> book() async {
    final app = AppScope.of(context);

    if (widget.event.paid) {
      final paid = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => EventPaymentPage(event: widget.event),
        ),
      );

      if (paid != true) return;
      app.bookEvent(widget.event);
      showMessage(context, 'Paid event booked');
      return;
    }

    final confirmed = await confirmDialog(
      context,
      title: 'Confirm booking',
      message: 'Book ${widget.event.title} for ${app.name}?',
      confirmText: 'Book',
    );

    if (!confirmed) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    app.bookEvent(widget.event);

    if (!mounted) return;
    setState(() => loading = false);
    showMessage(context, 'Booking confirmed');
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final booked = app.bookedEvents.contains(widget.event.id);
    final reminded = app.eventReminders.contains(widget.event.id);

    return ResponsivePage(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.event.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text('${widget.event.time} · ${widget.event.location}'),
          const SizedBox(height: 16),
          Text(widget.event.description),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reminder'),
            subtitle: Text(reminded ? 'Reminder is on' : 'Reminder is off'),
            value: reminded,
            onChanged: (_) {
              app.toggleReminder(widget.event.id, widget.event.title);
            },
          ),
          const SizedBox(height: 16),
          StatusPanel(
            icon: widget.event.paid ? Icons.payment : Icons.card_giftcard,
            title: widget.event.paid ? 'Paid event' : 'Free event',
            message: widget.event.paid
                ? 'A demo card payment form is required before booking.'
                : 'No payment is required.',
          ),
          const SizedBox(height: 24),
          loading
              ? const Center(child: CircularProgressIndicator())
              : FilledButton.icon(
                  onPressed: booked ? null : book,
                  icon: Icon(booked ? Icons.check_circle : Icons.check),
                  label: Text(
                    booked
                        ? 'Already booked'
                        : widget.event.paid
                            ? 'Pay and book'
                            : 'Book event',
                  ),
                ),
        ],
      ),
    );
  }
}

/// Demo payment form for paid events.
/// This answers the feedback that paid events need payment details.
class EventPaymentPage extends StatefulWidget {
  const EventPaymentPage({super.key, required this.event});

  final EventItem event;

  @override
  State<EventPaymentPage> createState() => _EventPaymentPageState();
}

class _EventPaymentPageState extends State<EventPaymentPage> {
  final formKey = GlobalKey<FormState>();
  final cardName = TextEditingController();
  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    cardName.dispose();
    cardNumber.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  Future<void> pay() async {
    if (!formKey.currentState!.validate()) return;

    final confirmed = await confirmDialog(
      context,
      title: 'Confirm payment',
      message: 'Pay demo fee and book ${widget.event.title}?',
      confirmText: 'Pay',
    );

    if (!confirmed) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => loading = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event payment'),
      ),
      body: ResponsivePage(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              PageHeader(
                title: 'Payment details',
                subtitle: 'Demo payment for ${widget.event.title}.',
              ),
              PaymentFields(
                cardName: cardName,
                cardNumber: cardNumber,
                expiry: expiry,
                cvv: cvv,
              ),
              const SizedBox(height: 20),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton.icon(
                      onPressed: pay,
                      icon: const Icon(Icons.payment),
                      label: const Text('Pay and confirm booking'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- COURSES --------------------

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return ResponsivePage(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PageHeader(
            title: 'Short Courses',
            subtitle: 'Choose a practical short course for KICC members.',
          ),
          for (final course in AppLists.courses) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: CircleAvatar(
                child: Icon(
                  app.enrolledCourses.contains(course.title)
                      ? Icons.check
                      : Icons.menu_book,
                ),
              ),
              title: Text(course.title),
              subtitle: Text('${course.level} · ${course.duration}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => openPage(context, CourseDetailsPage(course: course)),
            ),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class CourseDetailsPage extends StatefulWidget {
  const CourseDetailsPage({super.key, required this.course});

  final CourseItem course;

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  bool loading = false;

  Future<void> enrol() async {
    final app = AppScope.of(context);

    final confirmed = await confirmDialog(
      context,
      title: 'Confirm enrolment',
      message: 'Enrol in ${widget.course.title}?',
      confirmText: 'Enrol',
    );

    if (!confirmed) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    app.enrolCourse(widget.course);

    if (!mounted) return;
    setState(() => loading = false);
    showMessage(context, 'Course enrolment confirmed');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final enrolled = app.enrolledCourses.contains(widget.course.title);

    return Scaffold(
      appBar: AppBar(title: const Text('Course details')),
      body: ResponsivePage(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.course.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text('${widget.course.level} · ${widget.course.duration}'),
            const SizedBox(height: 16),
            Text(widget.course.description),
            const SizedBox(height: 20),
            StatusPanel(
              icon: Icons.touch_app,
              title: 'Gesture',
              message: 'Long press the button for a quick preview message.',
            ),
            const SizedBox(height: 24),
            loading
                ? const Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onLongPress: () => showMessage(context, 'This enrols you in the course.'),
                    child: FilledButton.icon(
                      onPressed: enrolled ? null : enrol,
                      icon: Icon(enrolled ? Icons.check_circle : Icons.school),
                      label: Text(enrolled ? 'Already enrolled' : 'Enrol'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// -------------------- MORE --------------------

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PageHeader(
            title: 'More',
            subtitle: 'Membership, donation, prayer, activity and settings.',
          ),
          MoreTile(
            icon: Icons.badge_outlined,
            title: 'Membership application',
            subtitle: 'Apply, renew, and enter payment details',
            onTap: () => openPage(context, const MembershipPage()),
          ),
          MoreTile(
            icon: Icons.volunteer_activism_outlined,
            title: 'Donate',
            subtitle: 'Enter donation and payment details',
            onTap: () => openPage(context, const DonationPage()),
          ),
          MoreTile(
            icon: Icons.favorite_border,
            title: 'Prayer request',
            subtitle: 'Submit a request',
            onTap: () => openPage(context, const PrayerRequestPage()),
          ),
          MoreTile(
            icon: Icons.dashboard_outlined,
            title: 'My activity',
            subtitle: 'View bookings and updates',
            onTap: () => openPage(context, const ActivityPage()),
          ),
          MoreTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Text size and dark mode',
            onTap: () => openPage(context, const SettingsPage()),
          ),
        ],
      ),
    );
  }
}

// -------------------- MEMBERSHIP --------------------

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController email;
  final cardName = TextEditingController();
  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();

  String plan = 'Standard';
  bool loading = false;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Design note: AppScope depends on inherited context, so it is read here
    // instead of initState. This prevents Quick Action cards from crashing.
    if (!initialized) {
      final app = AppScope.of(context);
      name = TextEditingController(text: app.name);
      email = TextEditingController(text: app.email);
      plan = app.membershipPlan;
      initialized = true;
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    cardName.dispose();
    cardNumber.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final app = AppScope.of(context);
    if (!formKey.currentState!.validate()) return;

    final confirmed = await confirmDialog(
      context,
      title: 'Confirm membership',
      message: 'Submit $plan membership application and payment?',
      confirmText: 'Submit',
    );

    if (!confirmed) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 750));

    app.submitMembership(
      newName: name.text.trim(),
      newEmail: email.text.trim(),
      plan: plan,
    );

    if (!mounted) return;
    setState(() => loading = false);
    showMessage(context, 'Membership application submitted');
  }

  @override
  Widget build(BuildContext context) {
    final plans = const [
      MembershipPlan('Standard', '\$20', 'Events and member updates.'),
      MembershipPlan('Premium', '\$40', 'Priority booking and course discounts.'),
      MembershipPlan('Social', '\$15', 'Casual social activity access.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Membership application')),
      body: ResponsivePage(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const PageHeader(
                title: 'Apply or renew',
                subtitle: 'Enter member and payment details.',
              ),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: requiredField,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: emailField,
              ),
              const SizedBox(height: 16),
              Text('Select plan', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final item in plans)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SelectablePanel(
                    selected: plan == item.name,
                    onTap: () => setState(() => plan = item.name),
                    child: Row(
                      children: [
                        Icon(plan == item.name
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('${item.name} ${item.price}\n${item.detail}'),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              PaymentFields(
                cardName: cardName,
                cardNumber: cardNumber,
                expiry: expiry,
                cvv: cvv,
              ),
              const SizedBox(height: 20),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton.icon(
                      onPressed: submit,
                      icon: const Icon(Icons.payment),
                      label: const Text('Submit and pay'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- DONATION --------------------

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name;
  final amount = TextEditingController();
  final cardName = TextEditingController();
  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();

  String purpose = 'General support';
  bool loading = false;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Design note: AppScope is read in didChangeDependencies to avoid
    // context-related crashes when opening Donate from Quick Actions.
    if (!initialized) {
      name = TextEditingController(text: AppScope.of(context).name);
      initialized = true;
    }
  }

  @override
  void dispose() {
    name.dispose();
    amount.dispose();
    cardName.dispose();
    cardNumber.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final app = AppScope.of(context);
    if (!formKey.currentState!.validate()) return;

    final confirmed = await confirmDialog(
      context,
      title: 'Confirm donation',
      message: 'Donate \$${amount.text} for $purpose?',
      confirmText: 'Donate',
    );

    if (!confirmed) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 750));

    app.addDonation(DonationRecord(amount.text.trim(), purpose));

    if (!mounted) return;
    setState(() => loading = false);
    showMessage(context, 'Donation completed');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const purposes = [
      'General support',
      'Seniors activities',
      'Short courses',
      'Community events',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Donate')),
      body: ResponsivePage(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const PageHeader(
                title: 'Support KICC',
                subtitle: 'Enter donation and payment details.',
              ),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Donor name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: requiredField,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Example: 25',
                  helperText: 'Enter a whole dollar amount for demo payment.',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: amountField,
              ),
              const SizedBox(height: 16),
              Text('Purpose', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final item in purposes)
                    ChoiceChip(
                      label: Text(item),
                      selected: purpose == item,
                      onSelected: (_) => setState(() => purpose = item),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              PaymentFields(
                cardName: cardName,
                cardNumber: cardNumber,
                expiry: expiry,
                cvv: cvv,
              ),
              const SizedBox(height: 20),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton.icon(
                      onPressed: submit,
                      icon: const Icon(Icons.volunteer_activism),
                      label: const Text('Confirm donation'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- OTHER PAGES --------------------

class PrayerRequestPage extends StatefulWidget {
  const PrayerRequestPage({super.key});

  @override
  State<PrayerRequestPage> createState() => _PrayerRequestPageState();
}

class _PrayerRequestPageState extends State<PrayerRequestPage> {
  final formKey = GlobalKey<FormState>();
  final request = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    request.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final app = AppScope.of(context);
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    app.submitPrayer(request.text.trim());

    if (!mounted) return;
    setState(() => loading = false);
    showMessage(context, 'Prayer request submitted');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer request'),
      ),
      body: ResponsivePage(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const PageHeader(
                title: 'Prayer request',
                subtitle: 'Write a short request for the KICC team.',
              ),
              TextFormField(
                controller: request,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Request',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: requiredField,
              ),
              const SizedBox(height: 20),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton.icon(
                      onPressed: submit,
                      icon: const Icon(Icons.favorite),
                      label: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My activity')),
      body: ResponsivePage(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const PageHeader(
              title: 'My activity',
              subtitle: 'Live updates from your actions.',
            ),
            DashboardSummary(app: app),
            const SizedBox(height: 20),
            if (app.activityLog.isEmpty)
              const Text('No activity yet.')
            else
              for (final item in app.activityLog)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.check)),
                  title: Text(item),
                ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ResponsivePage(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark mode'),
              value: app.darkMode,
              onChanged: app.setDarkMode,
            ),
            const Divider(),
            Text('Text size', style: Theme.of(context).textTheme.titleLarge),
            Slider(
              value: app.textScale,
              min: 0.9,
              max: 1.4,
              divisions: 5,
              label: app.textScale.toStringAsFixed(1),
              onChanged: app.setTextScale,
            ),
            const SizedBox(height: 12),
            Text(
              'Sample readable text.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- REUSABLE WIDGETS --------------------

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    /// Consistent responsiveness: all pages share the same max width.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: child,
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 6),
          Text(subtitle),
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
          child: Text(title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
        ),
        if (actionLabel.isNotEmpty && onPressed != null)
          TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}

class UpcomingEventTile extends StatelessWidget {
  const UpcomingEventTile({
    super.key,
    required this.event,
    required this.onTap,
  });

  final EventItem event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      /// Tap gesture implemented through InkWell.
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_available, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Text('${event.title}\n${event.time} · ${event.location}'),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class ActionGrid extends StatelessWidget {
  const ActionGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 700 ? 4 : 2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: count,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: children,
        );
      },
    );
  }
}

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      /// Tap gesture on the full tile improves touch accessibility.
      onTap: onTap,
      onLongPress: () => showMessage(context, title),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class MoreTile extends StatelessWidget {
  const MoreTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({super.key, required this.app});

  final AppController app;

  @override
  Widget build(BuildContext context) {
    final items = [
      SummaryItem(Icons.event, '${app.bookedEvents.length}', 'Events'),
      SummaryItem(Icons.menu_book, '${app.enrolledCourses.length}', 'Courses'),
      SummaryItem(Icons.volunteer_activism, '${app.donations.length}', 'Donations'),
      SummaryItem(Icons.favorite, '${app.prayerRequests.length}', 'Prayers'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 700 ? 4 : 2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: count,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            for (final item in items)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(item.icon),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.value,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                        Text(item.label),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class StatusPanel extends StatelessWidget {
  const StatusPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text('$title\n$message')),
        ],
      ),
    );
  }
}

class SelectablePanel extends StatelessWidget {
  const SelectablePanel({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      /// Selection panels are large enough for older users and use animated
      /// border feedback instead of a small dropdown.
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class PaymentFields extends StatelessWidget {
  const PaymentFields({
    super.key,
    required this.cardName,
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
  });

  final TextEditingController cardName;
  final TextEditingController cardNumber;
  final TextEditingController expiry;
  final TextEditingController cvv;

  @override
  Widget build(BuildContext context) {
    /// Payment details are included as a prototype form to address incomplete
    /// payment feedback. No real payment processing occurs.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        TextFormField(
          controller: cardName,
          decoration: const InputDecoration(
            labelText: 'Name on card',
            hintText: 'Example: Giovanna Russo',
            helperText: 'Use the name printed on the card.',
            border: OutlineInputBorder(),
          ),
          validator: requiredField,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: cardNumber,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Card number',
            hintText: 'Example: 4111 1111 1111 1111',
            helperText: 'Demo only: enter at least 12 digits.',
            border: OutlineInputBorder(),
          ),
          validator: cardField,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: expiry,
                decoration: const InputDecoration(
                  labelText: 'Expiry MM/YY',
                  hintText: '08/28',
                  helperText: 'Month/year',
                  border: OutlineInputBorder(),
                ),
                validator: requiredField,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: cvv,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  helperText: '3 digits',
                  border: OutlineInputBorder(),
                ),
                validator: cvvField,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -------------------- HELPERS --------------------

void openPage(BuildContext context, Widget page) {
  /// Standard MaterialPageRoute used to satisfy the request for standard transitions.
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );

  return result ?? false;
}

String? requiredField(String? value) {
  if (value == null || value.trim().isEmpty) return 'Required';
  return null;
}

String? emailField(String? value) {
  if (value == null || value.trim().isEmpty) return 'Required';
  if (!value.contains('@')) return 'Enter a valid email';
  return null;
}

String? amountField(String? value) {
  if (value == null || value.trim().isEmpty) return 'Required';
  final amount = double.tryParse(value);
  if (amount == null || amount <= 0) return 'Enter valid amount';
  return null;
}

String? cardField(String? value) {
  final digits = (value ?? '').replaceAll(' ', '');
  if (digits.length < 12) return 'Enter card number';
  return null;
}

String? cvvField(String? value) {
  if ((value ?? '').length < 3) return 'Enter CVV';
  return null;
}

// -------------------- DATA MODELS --------------------

class AppLists {
  static const events = [
    EventItem(
      id: 1,
      title: 'Seniors Lunch',
      time: 'Today 12:30 PM',
      location: 'Main Hall',
      category: 'Community',
      paid: false,
      description: 'A friendly lunch for members to socialise.',
    ),
    EventItem(
      id: 2,
      title: 'Bingo Afternoon',
      time: 'Thursday 2:00 PM',
      location: 'Games Room',
      category: 'Community',
      paid: false,
      description: 'A relaxed afternoon activity for members.',
    ),
    EventItem(
      id: 3,
      title: 'Bocce Practice',
      time: 'Saturday 10:00 AM',
      location: 'Outdoor Court',
      category: 'Sport',
      paid: true,
      description: 'Guided bocce practice for all skill levels.',
    ),
    EventItem(
      id: 4,
      title: 'Cultural Dance Night',
      time: 'Saturday 7:00 PM',
      location: 'Ballroom',
      category: 'Culture',
      paid: true,
      description: 'Music and dance night for the community.',
    ),
  ];

  static const courses = [
    CourseItem(
      title: 'Beginner Bocce Skills',
      level: 'Beginner',
      duration: '4 lessons',
      description: 'Learn basic rules, scoring and safe play.',
    ),
    CourseItem(
      title: 'Volunteering Basics',
      level: 'Beginner',
      duration: '3 lessons',
      description: 'Learn how to help during KICC events.',
    ),
    CourseItem(
      title: 'Italian Culture Workshop',
      level: 'All levels',
      duration: '5 lessons',
      description: 'Explore food, music and community traditions.',
    ),
  ];
}

class EventItem {
  const EventItem({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.category,
    required this.paid,
    required this.description,
  });

  final int id;
  final String title;
  final String time;
  final String location;
  final String category;
  final bool paid;
  final String description;
}

class CourseItem {
  const CourseItem({
    required this.title,
    required this.level,
    required this.duration,
    required this.description,
  });

  final String title;
  final String level;
  final String duration;
  final String description;
}

class MembershipPlan {
  const MembershipPlan(this.name, this.price, this.detail);

  final String name;
  final String price;
  final String detail;
}

class DonationRecord {
  const DonationRecord(this.amount, this.purpose);

  final String amount;
  final String purpose;
}

class SummaryItem {
  const SummaryItem(this.icon, this.value, this.label);

  final IconData icon;
  final String value;
  final String label;
}
