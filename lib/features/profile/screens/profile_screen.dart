import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  double _availableBalance = 2850.0;
  double _pendingBalance = 650.0;
  double _totalWithdrawn = 3000.0;

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'tx_101',
      'title': 'Sale: Calculus 9th Edition Book',
      'type': 'Sale Earnings',
      'amount': '+৳450',
      'date': 'Today, 02:45 PM',
      'status': 'Available',
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'id': 'tx_102',
      'title': 'Subscription Share: Netflix 4K (Slot 2)',
      'type': 'Monthly Split',
      'amount': '+৳250',
      'date': 'Yesterday',
      'status': 'Available',
      'icon': Icons.subscriptions_rounded,
      'color': Color(0xFF2563EB),
    },
    {
      'id': 'tx_103',
      'title': 'Withdrawal to bKash (01712-***892)',
      'type': 'Payout',
      'amount': '-৳1,500',
      'date': '02 Sep 2026',
      'status': 'Completed',
      'icon': Icons.arrow_outward_rounded,
      'color': Color(0xFF64748B),
    },
    {
      'id': 'tx_104',
      'title': 'Sale: Mechanical Keyboard (Buyer Pickup)',
      'type': 'Escrow Hold',
      'amount': '+৳650',
      'date': 'Pending Verification',
      'status': 'Pending Escrow',
      'icon': Icons.hourglass_top_rounded,
      'color': Color(0xFFF59E0B),
    },
  ];

  void _showEditProfileModal() {
    final bioController = TextEditingController(text: 'Senior CS student. Selling textbooks, electronics, and random dorm stuff.');
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
    final numberController = TextEditingController(text: '01712345678');
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
                      hintText: '01XXXXXXXXX',
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
                            'title': 'Withdrawal to $selectedMethod (${numberController.text})',
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
                            content: Text('৳${amt.toStringAsFixed(0)} withdrawal request submitted to $selectedMethod!'),
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

                // Tabs Bar (4 Tabs)
                Row(
                  children: [
                    _buildTabItem(0, 'My Listings', '3'),
                    const SizedBox(width: 24),
                    _buildTabItem(1, 'Joined Groups', '2'),
                    const SizedBox(width: 24),
                    _buildTabItem(2, 'Seller Earnings & Wallet', '৳${_availableBalance.toStringAsFixed(0)}'),
                    const SizedBox(width: 24),
                    _buildTabItem(3, 'Settings', null),
                  ],
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Listings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildListingCard(
                  title: 'Calculus: Early Transcendentals 9th Edition',
                  price: '৳450',
                  desc: 'Used for one semester. Great condition, minimal highlighting.',
                  imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80',
                  status: 'Active',
                  isSold: false,
                  views: '12 views',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildListingCard(
                  title: 'Keychron K2 Wireless Mechanical Keyboard',
                  price: '৳1500',
                  desc: 'Brown switches. Includes original box and extra keycaps.',
                  imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=600&q=80',
                  status: 'Active',
                  isSold: false,
                  views: '45 views',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildListingCard(
                  title: 'IKEA Tertial Desk Lamp',
                  price: '৳350',
                  desc: 'Works perfectly, just upgraded my setup.',
                  imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80',
                  status: 'Sold',
                  isSold: true,
                  views: 'Sold on Oct 12',
                ),
              ),
            ],
          ),
        ],
      );
    } else if (_selectedTab == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Active Subscription Groups', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildJoinedGroupCard(
                  'Netflix Premium 4K',
                  '৳250 / mo',
                  'Alex Chen (Host)',
                  'Next billing: Sep 25, 2026',
                  'netflix_alex@campusnet.org',
                  'Screen 3 (Your Profile)',
                  '7492',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildJoinedGroupCard(
                  'Coursera Plus Annual',
                  '৳1200 / yr',
                  'CS Study Group (Host)',
                  'Next billing: Jan 15, 2027',
                  'cs_coursera_invite@group.edu',
                  'Member Seat #4',
                  'Active Token Verified',
                ),
              ),
            ],
          ),
        ],
      );
    } else if (_selectedTab == 2) {
      // Wallet & Earnings Dashboard Tab
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
          const SizedBox(height: 24),

          // Saved Payout Accounts Bar
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.account_balance_rounded, color: Color(0xFF334155), size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Default Payout Method: bKash (01712-***892)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                      SizedBox(height: 2),
                      Text('Earnings are deposited to this account within 5-10 minutes of withdrawal', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: _showWithdrawModal,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Change Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

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
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
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
                const Divider(),
                ListTile(
                  title: const Text('Payment & Payout Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('bKash (01712-***892), Nagad linked'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showWithdrawModal,
                ),
              ],
            ),
          ),
        ],
      );
    }
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

  Widget _buildListingCard({
    required String title,
    required String price,
    required String desc,
    required String imageUrl,
    required String status,
    required bool isSold,
    required String views,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          Stack(
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 400,
                  cacheHeight: 250,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image)),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSold ? Colors.black.withValues(alpha: 0.6) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
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
                      price,
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
                    if (!isSold) const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF64748B)),
                  ],
                ),
              ],
            ),
          ),
        ],
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening group chat with $host...'), backgroundColor: const Color(0xFF2563EB)),
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
}
