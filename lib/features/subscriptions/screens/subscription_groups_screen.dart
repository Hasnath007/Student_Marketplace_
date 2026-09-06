import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/marketplace_provider.dart';
import '../../marketplace/widgets/payment_checkout_dialog.dart';

class SubscriptionGroupsScreen extends ConsumerStatefulWidget {
  const SubscriptionGroupsScreen({super.key});

  @override
  ConsumerState<SubscriptionGroupsScreen> createState() => _SubscriptionGroupsScreenState();
}

class _SubscriptionGroupsScreenState extends ConsumerState<SubscriptionGroupsScreen> {
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
      'price': '৳250',
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
      'price': '৳180',
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
      'price': '৳1200',
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
      'price': '৳450',
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
                                  hintText: '৳250 /mo',
                                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.normal),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text('৳', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                  ),
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
                                initialValue: selectedCategory,
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
                                  'price': '৳${priceCtrl.text.isEmpty ? "250" : priceCtrl.text.replaceAll("৳", "").replaceAll("\$", "")}',
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
    final isJoined = group['isJoined'] == true;
    if (!isJoined) {
      PaymentCheckoutDialog.show(
        context,
        itemName: group['title'] ?? 'Subscription Group',
        priceText: '${group['price'] ?? '৳250'}${group['period'] ?? '/mo'}',
        category: group['category'] ?? 'Subscription',
        onPaymentSuccess: () {
          setState(() {
            group['isJoined'] = true;
            group['slotsText'] = 'Joined ✓';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Joined ${group['title']} successfully!'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        },
      );
    } else {
      setState(() {
        group['isJoined'] = false;
        group['slotsText'] = '2/4 slots left';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Left ${group['title']} group.'),
          backgroundColor: const Color(0xFF64748B),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final cleanSearch = searchQuery.trim().toLowerCase();

    final filteredGroups = _groups.where((g) {
      final matchesCategory = _selectedCategory == 'All Categories' || g['category'] == _selectedCategory;
      final matchesSearch = cleanSearch.isEmpty ||
          (g['title'] as String).toLowerCase().contains(cleanSearch) ||
          (g['host'] as String).toLowerCase().contains(cleanSearch) ||
          (g['category'] as String).toLowerCase().contains(cleanSearch) ||
          (g['badge'] as String).toLowerCase().contains(cleanSearch);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
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

                // Category Filter Pills & Search Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ..._categories.map((cat) {
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
                        }),
                        if (searchQuery.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          ActionChip(
                            avatar: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF2563EB)),
                            label: Text('Search: "$searchQuery"'),
                            backgroundColor: const Color(0xFFDBEAFE),
                            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                            onPressed: () {
                              ref.read(searchQueryProvider.notifier).setQuery('');
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ],
                      ],
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

                // Empty State or Group Cards Grid
                if (filteredGroups.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'No subscription groups matching "$searchQuery"'
                              : 'No groups found in "$_selectedCategory"',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'Try searching for Netflix, Spotify, Coursera, Adobe, etc.'
                              : 'Be the first to start a group in this category!',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 16),
                        if (searchQuery.isNotEmpty)
                          OutlinedButton(
                            onPressed: () => ref.read(searchQueryProvider.notifier).setQuery(''),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF2563EB)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Clear Search', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: _showCreateGroupModal,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Start a Group'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 4;
                      double childAspectRatio = 0.90;
                      if (constraints.maxWidth < 620) {
                        crossAxisCount = 1;
                        childAspectRatio = 1.6;
                      } else if (constraints.maxWidth < 950) {
                        crossAxisCount = 2;
                        childAspectRatio = 1.0;
                      } else if (constraints.maxWidth < 1300) {
                        crossAxisCount = 3;
                        childAspectRatio = 0.92;
                      } else {
                        crossAxisCount = 4;
                        childAspectRatio = 0.90;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
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
    return _GroupCardWidget(
      title: title,
      host: host,
      slotsText: slotsText,
      progress: progress,
      badge: badge,
      price: price,
      period: period,
      buttonText: buttonText,
      isDisabled: isDisabled,
      isJoined: isJoined,
      onPressed: onPressed,
      iconWidget: iconWidget,
      isVerified: isVerified,
    );
  }
}

class _GroupCardWidget extends StatefulWidget {
  final String title;
  final String host;
  final String slotsText;
  final double progress;
  final String badge;
  final String price;
  final String period;
  final String buttonText;
  final bool isDisabled;
  final bool isJoined;
  final VoidCallback onPressed;
  final Widget iconWidget;
  final bool isVerified;

  const _GroupCardWidget({
    required this.title,
    required this.host,
    required this.slotsText,
    required this.progress,
    required this.badge,
    required this.price,
    required this.period,
    required this.buttonText,
    required this.isDisabled,
    required this.isJoined,
    required this.onPressed,
    required this.iconWidget,
    this.isVerified = false,
  });

  @override
  State<_GroupCardWidget> createState() => _GroupCardWidgetState();
}

class _GroupCardWidgetState extends State<_GroupCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isJoined
                ? const Color(0xFF10B981)
                : (_isHovered ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0)),
            width: widget.isJoined ? 2 : (_isHovered ? 1.5 : 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? const Color(0xFF1E293B).withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.03),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.iconWidget,
                if (widget.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(6)),
                    child: const Text('VERIFIED HOST', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                    child: Text(widget.badge, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('👤 Host: ${widget.host}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.slotsText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: widget.isDisabled ? Colors.red : (widget.isJoined ? const Color(0xFF10B981) : const Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: widget.progress,
              backgroundColor: const Color(0xFFE2E8F0),
              color: widget.isDisabled ? Colors.red : (widget.isJoined ? const Color(0xFF10B981) : const Color(0xFF2563EB)),
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
                        Text(widget.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                        Text(widget.period, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: widget.isDisabled ? null : widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isJoined ? const Color(0xFF10B981) : (widget.isVerified ? const Color(0xFF2563EB) : const Color(0xFFEEF2FF)),
                    foregroundColor: widget.isJoined || widget.isVerified ? Colors.white : const Color(0xFF2563EB),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(widget.buttonText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
