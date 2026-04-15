import 'package:flutter/material.dart';

/// Screen for renewing membership. The user selects a membership type and
/// confirms payment. A simulated payment flow is used for demonstration.
class RenewMembershipScreen extends StatefulWidget {
  const RenewMembershipScreen({super.key});

  static const String routeName = '/renew_membership';

  @override
  State<RenewMembershipScreen> createState() => _RenewMembershipScreenState();
}

class _RenewMembershipScreenState extends State<RenewMembershipScreen> {
  String _selectedType = 'Standard';
  bool _isProcessing = false;
  bool _renewed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renew Membership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _renewed
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.card_membership, color: Colors.blue, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      'Membership renewed!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select membership type',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Standard', child: Text('Standard - \$20')), 
                      DropdownMenuItem(value: 'Premium', child: Text('Premium - \$40')), 
                      DropdownMenuItem(value: 'Lifetime', child: Text('Lifetime - \$100')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
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
                              _renewed = true;
                            });
                          },
                          child: const Text('Pay & Renew'),
                        ),
                ],
              ),
      ),
    );
  }
}