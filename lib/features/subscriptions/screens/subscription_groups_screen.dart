import 'package:flutter/material.dart';

class SubscriptionGroupsScreen extends StatefulWidget {
  const SubscriptionGroupsScreen({super.key});

  @override
  State<SubscriptionGroupsScreen> createState() => _SubscriptionGroupsScreenState();
}

class _SubscriptionGroupsScreenState extends State<SubscriptionGroupsScreen> {
  String _selectedCategory = 'All Categories';
  final List<String> _categories = ['All Categories', 'Entertainment', 'Academic', 'Productivity'];

  final List<Map<String, dynamic>> _groups = [
    {
      'id': 'g1',
      'title': 'Netflix Premium 4K',
      'host': 'Alex Chen',
      'slotsText': '2/4 slots left',
      'progress': 0.5,
      'badge': 'ENTERTAINMENT',
      'category': 'Entertainment',
      'price': '\$5.50',
      'period': '/mo',
      'isFull': false,
      'isJoined': false,
      'color': Colors.red.shade900,
      'logo': 'N',
    },
    {
      'id': 'g2',
      'title': 'Spotify Duo',
      'host': 'Sarah J.',
      'slotsText': '1/2 slots left',
      'progress': 0.5,
      'badge': 'ENTERTAINMENT',
      'category': 'Entertainment',
      'price': '\$7.49',
      'period': '/mo',
      'isFull': false,
      'isJoined': false,
      'color': Colors.black,
      'logo': '🟢',
    },
    {
      'id': 'g3',
      'title': 'Coursera Plus (Annual)',
      'host': 'CS Study Group',
      'slotsText': '3/5 slots left',
      'progress': 0.6,
      'badge': 'ACADEMIC',
      'category': 'Academic',
      'isVerified': true,
      'price': '\$79',
      'period': '/yr',
      'isFull': false,
      'isJoined': false,
      'color': const Color(0xFF0056D2),
      'logo': 'C',
    },
    {
      'id': 'g4',
      'title': 'Adobe Creative Cloud',
      'host': 'Design Club',
      'slotsText': '0/2 slots left',
      'progress': 1.0,
      'badge': 'PRODUCTIVITY',
      'category': 'Productivity',
      'price': '\$19.99',
      'period': '/mo',
      'isFull': true,
      'isJoined': false,
      'color': const Color(0xFFFF0000),
      'logo': 'Ai',
    },
  ];

  void _showHowItWorksDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB)),
            SizedBox(width: 8),
            Text('How Subscription Sharing Works', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Choose a group: Select from streaming, software, or learning tools.', style: TextStyle(fontSize: 13, height: 1.4)),
            SizedBox(height: 8),
            Text('2. Split the bill: Pay your portion automatically every month via verified campus pay.', style: TextStyle(fontSize: 13, height: 1.4)),
            SizedBox(height: 8),
            Text('3. Get instant access: Receive login credentials securely managed by the verified host.', style: TextStyle(fontSize: 13, height: 1.4)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupModal() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String selectedCategory = 'Entertainment';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            elevation: 8,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Icon Badge & Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.add_task_rounded, color: Color(0xFF2563EB), size: 24),
                            ),
                            const SizedBox(width: 14),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start a Subscription Group',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.3),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Share subscriptions & split monthly costs with peers',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Input 1: Group Name
                    const Text('Service or Group Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'e.g. ChatGPT Plus, Figma, Netflix 4K',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        prefixIcon: const Icon(Icons.layers_outlined, size: 20, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input 2: Price & Category Side-by-side
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Price / Member', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                              const SizedBox(height: 6),
                              TextField(
                                controller: priceCtrl,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: '\$5.50 /mo',
                                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.normal),
                                  prefixIcon: const Icon(Icons.attach_money_rounded, size: 20, color: Color(0xFF64748B)),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedCategory,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                                  DropdownMenuItem(value: 'Academic', child: Text('Academic')),
                                  DropdownMenuItem(value: 'Productivity', child: Text('Productivity')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setModalState(() => selectedCategory = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Actions Bar (Cancel & Publish)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (titleCtrl.text.isNotEmpty) {
                              setState(() {
                                _groups.insert(0, {
                                  'id': DateTime.now().toString(),
                                  'title': titleCtrl.text,
                                  'host': 'You (Alex R.)',
                                  'slotsText': '1/4 slots filled',
                                  'progress': 0.25,
                                  'badge': selectedCategory.toUpperCase(),
                                  'category': selectedCategory,
                                  'price': '\$${priceCtrl.text.isEmpty ? "5.00" : priceCtrl.text}',
                                  'period': '/mo',
                                  'isFull': false,
                                  'isJoined': true,
                                  'color': const Color(0xFF2563EB),
                                  'logo': '⭐',
                                });
                              });
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Subscription Group created successfully!'), backgroundColor: Color(0xFF2563EB)),
                              );
                            }
                          },
                          icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                          label: const Text('Publish Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _toggleJoinGroup(Map<String, dynamic> group) {
    setState(() {
      final isJoined = group['isJoined'] == true;
      group['isJoined'] = !isJoined;
      if (!isJoined) {
        group['slotsText'] = 'Joined!';
      } else {
        group['slotsText'] = '2/4 slots left';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(group['isJoined'] ? 'Joined ${group['title']} group!' : 'Left ${group['title']} group.'),
        backgroundColor: group['isJoined'] ? const Color(0xFF2563EB) : const Color(0xFF64748B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _groups.where((g) {
      if (_selectedCategory == 'All Categories') return true;
      return g['category'] == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title & Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'COST SHARING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Share Costs, Save Money',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 450),
                            child: const Text(
                              'Join existing subscription groups on campus to split the bill, or start your own and invite others. Trusted, verified peer-to-peer sharing.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _showHowItWorksDialog,
                          icon: const Icon(Icons.info_outline_rounded, size: 16),
                          label: const Text('How it works', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFEEF2FF),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _showCreateGroupModal,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Create Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Category Filter Pills & Sort
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (s) => (s) ? setState(() => _selectedCategory = cat) : null,
                            selectedColor: const Color(0xFF0F172A),
                            backgroundColor: const Color(0xFFEEF2FF),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        );
                      }).toList(),
                    ),
                    const Row(
                      children: [
                        Text('Sort by: ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text('Newest First', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Group Cards Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredGroups.length,
                  itemBuilder: (context, index) {
                    final group = filteredGroups[index];
                    final isFull = group['isFull'] == true;
                    final isJoined = group['isJoined'] == true;

                    return _buildGroupCard(
                      title: group['title'],
                      host: group['host'],
                      slotsText: group['slotsText'],
                      progress: group['progress'],
                      badge: group['badge'],
                      price: group['price'],
                      period: group['period'],
                      buttonText: isJoined ? 'Joined ✓' : (isFull ? 'Full' : 'Join Group'),
                      isDisabled: isFull,
                      isJoined: isJoined,
                      onPressed: () => _toggleJoinGroup(group),
                      iconWidget: _buildLogoBox(group['logo'], group['color']),
                      isVerified: group['isVerified'] == true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBox(String text, Color bg) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
    );
  }

  Widget _buildGroupCard({
    required String title,
    required String host,
    required String slotsText,
    required double progress,
    required String badge,
    required String price,
    required String period,
    required String buttonText,
    required bool isDisabled,
    required bool isJoined,
    required VoidCallback onPressed,
    required Widget iconWidget,
    bool isVerified = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isJoined ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: isJoined ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconWidget,
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(6)),
                  child: const Text('VERIFIED HOST', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                  child: Text(badge, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 9, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('👤 Host: $host', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(slotsText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDisabled ? Colors.red : (isJoined ? const Color(0xFF10B981) : const Color(0xFF2563EB)))),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            color: isDisabled ? Colors.red : (isJoined ? const Color(0xFF10B981) : const Color(0xFF2563EB)),
            minHeight: 4,
            borderRadius: BorderRadius.circular(4),
          ),
          const Spacer(),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PER PERSON', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                      Text(period, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: isDisabled ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isJoined ? const Color(0xFF10B981) : (isVerified ? const Color(0xFF2563EB) : const Color(0xFFEEF2FF)),
                  foregroundColor: isJoined || isVerified ? Colors.white : const Color(0xFF2563EB),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
