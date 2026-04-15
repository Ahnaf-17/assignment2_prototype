import 'package:flutter/material.dart';

/// Screen that allows the user to make a donation. The user enters an amount
/// and then submits the donation. A simple simulated payment flow is used
/// here for demonstration purposes.
class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  static const String routeName = '/donate';

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;
  bool _donated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _donated
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, color: Colors.pink, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      'Thank you for your donation!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter donation amount',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                      hintText: 'Amount',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isProcessing
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isProcessing = true;
                            });
                            // Simulate payment processing
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              _isProcessing = false;
                              _donated = true;
                            });
                          },
                          child: const Text('Donate'),
                        ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}