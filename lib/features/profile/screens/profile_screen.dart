import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../subscriptions/widgets/host_chat_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  bool _linearAlgebraReceived = false;
  double _availableBalance = 2850.0;
  final double _pendingBalance = 650.0;
  double _totalWithdrawn = 3000.0;

  final List<Map<String, dynamic>> _myListings = [
    {
      'id': 'list_1',
      'title': 'Calculus: Early Transcendentals 9th Edition',
      'price': '450',
      'desc': 'Used for one semester. Great condition, minimal highlighting.',
      'imageUrl': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80',
      'status': 'Active',
      'isSold': false,
      'views': '12 views',
      'category': 'Books',
    },
    {
      'id': 'list_2',
      'title': 'Keychron K2 Wireless Mechanical Keyboard',
      'price': '1500',
      'desc': 'Brown switches. Includes original box and extra keycaps.',
      'imageUrl': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=600&q=80',
      'status': 'Active',
      'isSold': false,
      'views': '45 views',
      'category': 'Electronics',
    },
    {
      'id': 'list_3',
      'title': 'IKEA Tertial Desk Lamp',
      'price': '350',
      'desc': 'Works perfectly, just upgraded my setup.',
      'imageUrl': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80',
      'status': 'Sold',
      'isSold': true,
      'views': 'Sold on Oct 12',
      'category': 'Dorm Gear',
    },
  ];

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'tx_101',
      'title': 'Sale: Calculus 9th Edition Book',
      'type': 'Sale Earnings',
      'amount': '+৳450',
      'date': 'Today, 02:45 PM',
      'status': 'Available',
      'icon': Icons.check_circle_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'id': 'tx_102',
      'title': 'Subscription Share: Netflix 4K (Slot 2)',
      'type': 'Monthly Split',
      'amount': '+৳250',
      'date': 'Yesterday',
      'status': 'Available',
      'icon': Icons.subscriptions_rounded,
      'color': const Color(0xFF2563EB),
    },
    {
      'id': 'tx_103',
      'title': 'Withdrawal to bKash (017XXXXXXXX)',
      'type': 'Payout',
      'amount': '-৳1,500',
      'date': '02 Sep 2026',
      'status': 'Completed',
      'icon': Icons.arrow_outward_rounded,
      'color': const Color(0xFF64748B),
    },
    {
      'id': 'tx_104',
      'title': 'Sale: Mechanical Keyboard (Buyer Pickup)',
      'type': 'Escrow Hold',
      'amount': '+৳650',
      'date': 'Pending Verification',
      'status': 'Pending Escrow',
      'icon': Icons.hourglass_top_rounded,
      'color': const Color(0xFFF59E0B),
    },
  ];

  void _showEditListingModal(Map<String, dynamic> listing) {
    final titleController = TextEditingController(text: listing['title'] as String);
    final priceController = TextEditingController(text: listing['price'] as String);
    final descController = TextEditingController(text: listing['desc'] as String);
    bool isSold = listing['isSold'] as bool;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29000000),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Listing',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title Input
                TextField(
                  controller: titleController,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                // Price Input
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Price (৳)',
                    prefixText: '৳ ',
                    prefixStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                // Description Input
                TextField(
                  controller: descController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 14),

                // Mark as Sold Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isSold ? Icons.check_circle_rounded : Icons.storefront_rounded,
                          color: isSold ? const Color(0xFF64748B) : const Color(0xFF10B981),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isSold ? 'Marked as Sold' : 'Available for Sale',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSold ? const Color(0xFF64748B) : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: !isSold,
                      activeThumbColor: const Color(0xFF10B981),
                      onChanged: (active) {
                        setModalState(() {
                          isSold = !active;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Footer Buttons
                Row(
                  children: [
                    // Delete Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _myListings.removeWhere((item) => item['id'] == listing['id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Listing "${listing['title']}" deleted.'),
                            backgroundColor: const Color(0xFFDC2626),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                      child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),

                    // Cancel Button
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                    ),
                    const SizedBox(width: 8),

                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        final newTitle = titleController.text.trim();
                        final newPrice = priceController.text.trim();
                        final newDesc = descController.text.trim();

                        if (newTitle.isEmpty || newPrice.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Title and price cannot be empty'), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        setState(() {
                          final idx = _myListings.indexWhere((item) => item['id'] == listing['id']);
                          if (idx != -1) {
                            _myListings[idx]['title'] = newTitle;
                            _myListings[idx]['price'] = newPrice;
                            _myListings[idx]['desc'] = newDesc;
                            _myListings[idx]['isSold'] = isSold;
                            _myListings[idx]['status'] = isSold ? 'Sold' : 'Active';
                          }
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Listing updated successfully!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProfileModal() {
    final bioController = TextEditingController(text: 'Senior CS student. Selling textbooks, electronics, and sharing subscription slots.');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Profile Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Bio & Campus Info',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Color(0xFF2563EB)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawModal() {
    final amountController = TextEditingController(text: '1000');
    final numberController = TextEditingController();
    String selectedMethod = 'bKash';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF059669), size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Withdraw Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              Text('Instant Payout to your mobile wallet', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Current Balance Pill
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Available Balance:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        Text('৳${_availableBalance.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Select Payout Method
                  const Text('Payout Method', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedMethod = 'bKash'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedMethod == 'bKash' ? const Color(0xFFFDF2F8) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedMethod == 'bKash' ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
                                width: selectedMethod == 'bKash' ? 2 : 1,
                              ),
                            ),
                            child: const Center(
                              child: Text('bKash (বিকাশ)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFE11D48))),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedMethod = 'Nagad'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedMethod == 'Nagad' ? const Color(0xFFFFFBEB) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedMethod == 'Nagad' ? const Color(0xFFD97706) : const Color(0xFFE2E8F0),
                                width: selectedMethod == 'Nagad' ? 2 : 1,
                              ),
                            ),
                            child: const Center(
                              child: Text('Nagad (নগদ)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Account Number
                  const Text('Wallet Account Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '017XXXXXXXX',
                      prefixIcon: const Icon(Icons.phone_android_rounded, size: 20, color: Color(0xFF64748B)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Amount
                  const Text('Withdraw Amount (৳)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'e.g. 500',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('৳', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Withdraw Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final enteredNumber = numberController.text.trim();
                        if (enteredNumber.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter your account number (e.g. 017XXXXXXXX)'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final amt = double.tryParse(amountController.text.trim()) ?? 0;
                        if (amt <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount'), backgroundColor: Colors.red));
                          return;
                        }
                        if (amt > _availableBalance) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Amount exceeds available balance'), backgroundColor: Colors.red));
                          return;
                        }

                        setState(() {
                          _availableBalance -= amt;
                          _totalWithdrawn += amt;
                          _transactions.insert(0, {
                            'id': 'tx_${DateTime.now().millisecondsSinceEpoch}',
                            'title': 'Withdrawal to $selectedMethod ($enteredNumber)',
                            'type': 'Payout',
                            'amount': '-৳${amt.toStringAsFixed(0)}',
                            'date': 'Just Now',
                            'status': 'Processing',
                            'icon': Icons.arrow_outward_rounded,
                            'color': const Color(0xFF2563EB),
                          });
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('৳${amt.toStringAsFixed(0)} withdrawal request submitted to $selectedMethod ($enteredNumber)!'),
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Confirm & Withdraw', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCredentialsModal(String title, String email, String profile, String pin) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.vpn_key_rounded, color: Color(0xFF2563EB), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text('Subscription Credentials Vault', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildCredentialRow('Account Email / Login:', email),
                  const Divider(height: 16),
                  _buildCredentialRow('Your Assigned Profile:', profile),
                  const Divider(height: 16),
                  _buildCredentialRow('Profile PIN / Access Code:', pin),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.shield_outlined, size: 16, color: Color(0xFF10B981)),
                SizedBox(width: 6),
                Expanded(
                  child: Text('Only verified split members can see this credential.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Access info copied to clipboard!'), backgroundColor: Color(0xFF2563EB)),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Copy Access Info'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Banner Card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with verified badge
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 46,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF2563EB),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Alex Rivera',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: _showEditProfileModal,
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF2563EB)),
                                  tooltip: 'Edit Profile',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.school_outlined, size: 16, color: Color(0xFF475569)),
                                const SizedBox(width: 4),
                                const Text('Stanford University', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                                const Text('  •  ', style: TextStyle(color: Color(0xFF94A3B8))),
                                const Icon(Icons.science_outlined, size: 16, color: Color(0xFF475569)),
                                const SizedBox(width: 4),
                                const Text('Computer Science', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                                const Text('  •  ', style: TextStyle(color: Color(0xFF94A3B8))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Joined Aug 2022', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Senior CS student. Selling textbooks, electronics, and sharing subscription slots. Usually on campus near the engineering quad.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                            ),
                          ],
                        ),
                      ),

                      // Sign Out Button
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                          context.go('/landing');
                        },
                        icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFDC2626)),
                        label: const Text('Sign Out', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEE2E2),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tabs Bar (5 Tabs)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTabItem(0, 'My Listings', '3'),
                      const SizedBox(width: 24),
                      _buildTabItem(1, 'Subscriptions', '3'),
                      const SizedBox(width: 24),
                      _buildTabItem(2, 'My Orders (Escrow)', _linearAlgebraReceived ? '0 Active' : '1 Active'),
                      const SizedBox(width: 24),
                      _buildTabItem(3, 'Seller Wallet & Payout', '৳${_availableBalance.toStringAsFixed(0)}'),
                      const SizedBox(width: 24),
                      _buildTabItem(4, 'Settings', null),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 24),

                // Dynamic Tab Content
                _buildTabContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      final activeCount = _myListings.where((l) => !(l['isSold'] as bool)).length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.inventory_2_rounded, color: Color(0xFF2563EB), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Active Listings ($activeCount)',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/sell'),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Listing', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Click on any listing card or the "Edit" button to update price, description, or mark as sold.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 18),
          if (_myListings.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Text('No listings found. Tap "+ New Listing" to add one!'),
              ),
            )
          else
            Row(
              children: _myListings.map((listing) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildListingCard(listing),
                  ),
                );
              }).toList(),
            ),
        ],
      );
    } else if (_selectedTab == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SECTION 1: GROUPS HOSTED BY YOU (OWNER)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.stars_rounded, color: Color(0xFF2563EB), size: 22),
                  SizedBox(width: 8),
                  Text('Groups Hosted by You (Owner)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/subscriptions'),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Start Another Group', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Hosted Card
          _buildHostedGroupCard(
            title: 'ChatGPT Plus & Team Split',
            price: '৳350 / mo',
            filledSlots: '3/4 slots filled',
            totalRevenue: '+৳1,050 / mo',
            email: 'alex.rivera.chatgpt@stanford.edu',
            pin: 'Active Workspace Invite Token',
            members: const ['You (Host)', 'Sarah J.', 'Tanvir H.', '1 Open Slot'],
          ),
          const SizedBox(height: 32),

          // SECTION 2: GROUPS JOINED AS MEMBER
          const Row(
            children: [
              Icon(Icons.group_rounded, color: Color(0xFF059669), size: 22),
              SizedBox(width: 8),
              Text('Groups Joined as Member', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildJoinedGroupCard(
                  'Netflix Premium 4K',
                  '৳250 / mo',
                  'Alex Chen (Host)',
                  'Next billing: Sep 25, 2026',
                  'campus_netflix_4k@gmail.com',
                  'Screen 3 (Your Profile)',
                  '5829',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildJoinedGroupCard(
                  'Coursera Plus Annual',
                  '৳1200 / yr',
                  'CS Study Group (Host)',
                  'Next billing: Jan 15, 2027',
                  'stanford_cs_coursera@group.edu',
                  'Member Seat #4',
                  'Org Invite License #4',
                ),
              ),
            ],
          ),
        ],
      );
    } else if (_selectedTab == 2) {
      // TAB 2: MY ORDERS & CAMPUS ESCROW HANDOVER
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Purchases & Escrow Handover', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  SizedBox(height: 2),
                  Text('Track items you bought, view your 4-digit verification PIN, and confirm receipt', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/marketplace'),
                icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                label: const Text('Browse More Deals', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Escrow Safety Explainer Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Campus Escrow Protection is Active 🛡️',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E3A8A)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your bKash / Nagad payment is held safely in Escrow. The seller does NOT receive payment until you meet in person on campus, check the item condition, and tap "Item Received" (or give your 4-digit PIN).',
                        style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ACTIVE ORDERS SECTION
          Row(
            children: [
              Icon(
                _linearAlgebraReceived ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                color: _linearAlgebraReceived ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _linearAlgebraReceived ? 'Active Orders (0)' : 'Active Orders (1 Awaiting Campus Handover)',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Active Order Item Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _linearAlgebraReceived ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=200&q=80',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(width: 70, height: 70, color: Colors.grey.shade200),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Introduction to Linear Algebra, 5th Ed',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _linearAlgebraReceived ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _linearAlgebraReceived ? 'COMPLETED ✓' : 'IN ESCROW VAULT',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: _linearAlgebraReceived ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('Paid ৳1,500 via bKash • Seller: Alex R. (Verified Campus Student)', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF2563EB)),
                              SizedBox(width: 4),
                              Text('Campus Handover: Central Library / TSC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (!_linearAlgebraReceived) ...[
                  // Handover PIN Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.key_rounded, color: Color(0xFFD97706), size: 20),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Handover Verification PIN', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                            Text('PIN: #8492', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: 1.5)),
                          ],
                        ),
                        const Spacer(),
                        const Text('Tell seller this PIN or confirm below when meeting', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HostChatDialog.show(
                              context,
                              hostName: 'Alex R.',
                              groupTitle: 'Introduction to Linear Algebra, 5th Ed',
                              assignedScreen: 'Central Library',
                              isSellerMode: true,
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                          label: const Text('Chat with Seller (Schedule Meetup)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0xFF2563EB)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                                    SizedBox(width: 8),
                                    Text('Confirm Handover?'),
                                  ],
                                ),
                                content: const Text('Did you meet Alex R. and receive "Introduction to Linear Algebra, 5th Ed"? This will release ৳1,500 to the seller.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Not Yet')),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      setState(() {
                                        _linearAlgebraReceived = true;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('🎉 Handover confirmed! ৳1,500 released to Alex R.'),
                                          backgroundColor: Color(0xFF10B981),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Yes, Item Received ✓'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_circle_rounded, size: 16),
                          label: const Text('Item Received (Complete Handover)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Completed Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Handover successfully completed on campus. ৳1,500 released to Alex R.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF14532D)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),

          // PAST PURCHASES SECTION
          const Text('Past Completed Purchases', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=150&q=80',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Keychron K2 Wireless Mechanical Keyboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                      SizedBox(height: 2),
                      Text('৳1,500 • Delivered on 28 Aug 2026 • Seller: Tanvir Hossain', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                  child: const Text('DELIVERED ✓', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Admin Transparency Guide Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.hub_rounded, color: Color(0xFF475569), size: 18),
                    SizedBox(width: 8),
                    Text('How Admin & System Verifies Handover Automatically', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStepChip('1', 'bKash/Nagad in Escrow'),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF94A3B8)),
                    _buildStepChip('2', 'Campus Meetup'),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF94A3B8)),
                    _buildStepChip('3', 'Item Received / PIN'),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF94A3B8)),
                    _buildStepChip('4', 'Payout to Seller'),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_selectedTab == 3) {
      // TAB 3: WALLET & EARNINGS DASHBOARD
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Quick Withdraw Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller Earnings & Wallet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  SizedBox(height: 2),
                  Text('Track sales income, split revenue, and withdraw instantly', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showWithdrawModal,
                icon: const Icon(Icons.account_balance_wallet_rounded, size: 16),
                label: const Text('Withdraw Funds', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4 Metric Stat Cards
          Row(
            children: [
              Expanded(
                child: _buildWalletStatCard(
                  title: 'Available for Withdrawal',
                  amount: '৳${_availableBalance.toStringAsFixed(0)}',
                  subtitle: 'Ready to cash out',
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF059669),
                  bgColor: const Color(0xFFECFDF5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildWalletStatCard(
                  title: 'Pending in Escrow',
                  amount: '৳${_pendingBalance.toStringAsFixed(0)}',
                  subtitle: '1 order awaiting handover',
                  icon: Icons.hourglass_empty_rounded,
                  iconColor: const Color(0xFFD97706),
                  bgColor: const Color(0xFFFFFBEB),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildWalletStatCard(
                  title: 'Total Revenue Earned',
                  amount: '৳${(_availableBalance + _pendingBalance + _totalWithdrawn).toStringAsFixed(0)}',
                  subtitle: 'From 5 items + 2 splits',
                  icon: Icons.trending_up_rounded,
                  iconColor: const Color(0xFF2563EB),
                  bgColor: const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildWalletStatCard(
                  title: 'Total Withdrawn',
                  amount: '৳${_totalWithdrawn.toStringAsFixed(0)}',
                  subtitle: 'Paid to bKash/Nagad',
                  icon: Icons.payments_outlined,
                  iconColor: const Color(0xFF7C3AED),
                  bgColor: const Color(0xFFF5F3FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Transactions History
          const Text('Recent Earnings & Payout History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (tx['color'] as Color).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(tx['icon'] as IconData, color: tx['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                            const SizedBox(height: 2),
                            Text('${tx['type']} • ${tx['date']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (tx['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tx['status'] as String,
                          style: TextStyle(color: tx['color'] as Color, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        tx['amount'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: (tx['amount'] as String).startsWith('+') ? const Color(0xFF059669) : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      // TAB 4: SETTINGS
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account & Privacy Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Campus Email Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Receive notifications when someone messages or buys your listing'),
                  value: true,
                  activeThumbColor: const Color(0xFF2563EB),
                  onChanged: (val) {},
                ),
                const Divider(),
                ListTile(
                  title: const Text('Campus Identity Verification', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Verified student via alex.r@stanford.edu'),
                  trailing: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildStepChip(String step, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  step,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletStatCard({
    required String title,
    required String amount,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, String? count) {
    final isSelected = _selectedTab == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Column(
          children: [
            Row(
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  ),
                  child: Text(label),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              height: 2,
              width: isSelected ? 110 : 0,
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    final title = listing['title'] as String;
    final price = listing['price'] as String;
    final desc = listing['desc'] as String;
    final imageUrl = listing['imageUrl'] as String;
    final status = listing['status'] as String;
    final isSold = listing['isSold'] as bool;
    final views = listing['views'] as String;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (cardCtx, setCardState) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setCardState(() => isHovered = true),
        onExit: (_) => setCardState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered
                  ? const Color(0xFF2563EB)
                  : (isSold ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1)),
              width: isHovered ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? const Color(0xFF2563EB).withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isHovered ? 18 : 6,
                offset: Offset(0, isHovered ? 8 : 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showEditListingModal(listing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Image with zoom on hover
                Stack(
                  children: [
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: AnimatedScale(
                        scale: isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          cacheWidth: 400,
                          cacheHeight: 250,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, size: 36, color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                    ),

                    // Hover Overlay Hint
                    if (isHovered)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.15),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit_note_rounded, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Click to Edit',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Status Badge
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSold ? Colors.black.withValues(alpha: 0.7) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isSold)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                              ),
                            if (!isSold) const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSold ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '৳$price',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(views, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isHovered ? const Color(0xFF2563EB) : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  size: 13,
                                  color: isHovered ? Colors.white : const Color(0xFF2563EB),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isHovered ? Colors.white : const Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinedGroupCard(
    String title,
    String price,
    String host,
    String billing,
    String email,
    String profile,
    String pin,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)),
                child: const Text('ACTIVE MEMBER', style: TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
          const SizedBox(height: 4),
          Text('👑 $host', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 12),
          Text('📅 $billing', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCredentialsModal(title, email, profile, pin),
                  icon: const Icon(Icons.vpn_key_rounded, size: 15),
                  label: const Text('View Credentials', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF2FF),
                    foregroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  HostChatDialog.show(
                    context,
                    hostName: host,
                    groupTitle: title,
                    accountEmail: email,
                    pinCode: pin,
                    assignedScreen: profile,
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                label: const Text('Group Chat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHostedGroupCard({
    required String title,
    required String price,
    required String filledSlots,
    required String totalRevenue,
    required String email,
    required String pin,
    required List<String> members,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF93C5FD), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.stars_rounded, color: Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                      const Text('You are the Host / Admin', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('HOSTED BY YOU', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price per Seat', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Slots Occupied', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(filledSlots, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Monthly Revenue', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(totalRevenue, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF059669))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_alt_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Active Members: ${members.join(", ")}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCredentialsModal(title, email, 'Master Admin Account', pin),
                  icon: const Icon(Icons.shield_outlined, size: 15),
                  label: const Text('Manage Vault & PIN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  HostChatDialog.show(
                    context,
                    hostName: 'You (Alex Rivera)',
                    groupTitle: title,
                    accountEmail: email,
                    pinCode: pin,
                    assignedScreen: 'Host Master Screen',
                    isHostMode: true,
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                label: const Text('Host Group Chat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
