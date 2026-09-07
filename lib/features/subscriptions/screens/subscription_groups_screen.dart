import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/marketplace_provider.dart';
import '../../marketplace/widgets/payment_checkout_dialog.dart';
import '../widgets/host_chat_dialog.dart';

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
      'totalSlots': 4,
      'filledSlots': 2,
      'accountEmail': 'campus_netflix_4k@gmail.com',
      'pinCode': '5829',
      'assignedScreen': 'Screen 3',
      'members': [
        {'name': 'Alex Chen', 'role': 'Host (Owner)', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80', 'screen': 'Screen 1'},
        {'name': 'Sarah Jenkins', 'role': 'Member', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80', 'screen': 'Screen 2'},
        {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Screen 3'},
        {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Screen 4'},
      ],
    },
    {
      'id': 'g2',
      'title': 'Spotify Family Plan',
      'host': 'Sarah J.',
      'slotsText': '1/6 slots left',
      'progress': 0.83,
      'badge': 'ENTERTAINMENT',
      'category': 'Entertainment',
      'price': '৳120',
      'period': '/mo',
      'isFull': false,
      'isJoined': false,
      'color': Colors.black,
      'logo': '🟢',
      'totalSlots': 6,
      'filledSlots': 5,
      'accountEmail': 'spotify_family_sarah@gmail.com',
      'pinCode': 'Family Invite Token',
      'assignedScreen': 'Personal Account Seat #6',
      'members': [
        {'name': 'Sarah J.', 'role': 'Host (Owner)', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 1'},
        {'name': 'Tanvir Hossain', 'role': 'Member', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 2'},
        {'name': 'Nabila R.', 'role': 'Member', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 3'},
        {'name': 'Rahim Khan', 'role': 'Member', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 4'},
        {'name': 'Afsana Mimi', 'role': 'Member', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 5'},
        {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Seat 6'},
      ],
    },
    {
      'id': 'g3',
      'title': 'Coursera Plus (Annual Split)',
      'host': 'CS Study Group',
      'slotsText': '3/5 slots left',
      'progress': 0.4,
      'badge': 'ACADEMIC',
      'category': 'Academic',
      'isVerified': true,
      'price': '৳1200',
      'period': '/yr',
      'isFull': false,
      'isJoined': false,
      'color': const Color(0xFF0056D2),
      'logo': 'C',
      'totalSlots': 5,
      'filledSlots': 2,
      'accountEmail': 'stanford_cs_coursera@group.edu',
      'pinCode': 'Org Invite License #3',
      'assignedScreen': 'Seat #3',
      'members': [
        {'name': 'CS Study Group', 'role': 'Host Admin', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=150&q=80', 'screen': 'Admin Seat'},
        {'name': 'David K.', 'role': 'Member', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 2'},
        {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Seat 3'},
        {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Seat 4'},
        {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Seat 5'},
      ],
    },
    {
      'id': 'g4',
      'title': 'Adobe Creative Cloud Team',
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
      'totalSlots': 2,
      'filledSlots': 2,
      'accountEmail': 'design_club_adobe@stanford.edu',
      'pinCode': 'Team License Seat 2',
      'assignedScreen': 'Seat #2',
      'members': [
        {'name': 'Design Club', 'role': 'Host', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 1'},
        {'name': 'Chloe Miller', 'role': 'Member', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80', 'screen': 'Seat 2'},
      ],
    },
  ];

  void _showHowItWorksDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB)),
            SizedBox(width: 10),
            Text('How Subscription Sharing Works', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHowItWorksStep('1', 'Host creates group', 'A student with a multi-screen or family plan lists the service and sets the price per member.'),
            const SizedBox(height: 12),
            _buildHowItWorksStep('2', 'Students join & split bill', 'Peers pick an available slot and pay their share easily via bKash, Nagad, or Card.'),
            const SizedBox(height: 12),
            _buildHowItWorksStep('3', 'Instant Access & PIN Vault', 'Once payment is confirmed, login credentials and profile PIN are instantly unlocked.'),
            const SizedBox(height: 12),
            _buildHowItWorksStep('4', 'Monthly Renewals', 'Auto-reminders before billing dates ensure continuous and fair subscription access.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  static Widget _buildHowItWorksStep(String num, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
          child: Center(child: Text(num, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2563EB)))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  void _showGroupDetailsModal(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isJoined = group['isJoined'] == true;
          final isFull = group['isFull'] == true;
          final members = (group['members'] as List<dynamic>?) ?? [];

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: group['color'] as Color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  group['logo'] as String,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(group['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                Text('Host: ${group['host']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              ],
                            ),
                          ],
                        ),
                        IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8))),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Price & Slots Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cost per Member', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              const SizedBox(height: 2),
                              Text('${group['price']}${group['period']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isJoined ? const Color(0xFFD1FAE5) : const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isJoined ? 'You are a Member ✓' : (group['slotsText'] as String),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isJoined ? const Color(0xFF047857) : const Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Member Slots Breakdown
                    const Text('Group Seats & Member Allocation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        itemBuilder: (context, idx) {
                          final m = members[idx] as Map<String, dynamic>;
                          final isVacant = m['status'] == 'Vacant';
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                if (m['avatar'] != null)
                                  CircleAvatar(radius: 16, backgroundImage: NetworkImage(m['avatar'] as String))
                                else
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: const Color(0xFFF1F5F9),
                                    child: Icon(isVacant ? Icons.person_add_alt_1_rounded : Icons.person, size: 16, color: const Color(0xFF94A3B8)),
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m['name'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isVacant ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      Text('${m['role']} • ${m['screen']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isVacant ? const Color(0xFFF1F5F9) : const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isVacant ? 'Open Seat' : 'Occupied',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isVacant ? const Color(0xFF64748B) : const Color(0xFF047857)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Unlocked Credentials Card if joined
                    if (isJoined) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.vpn_key_rounded, size: 16, color: Color(0xFF2563EB)),
                                SizedBox(width: 8),
                                Text('Your Access Credentials', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E40AF))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Login: ${group['accountEmail'] ?? 'group_access@campus.edu'}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                            const SizedBox(height: 2),
                            Text('Profile: ${group['assignedScreen'] ?? 'Screen 3'} | PIN: ${group['pinCode'] ?? '4829'}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              HostChatDialog.show(
                                context,
                                hostName: group['host'] as String? ?? 'Group Host',
                                groupTitle: group['title'] as String? ?? 'Subscription Group',
                                accountEmail: group['accountEmail'] as String?,
                                pinCode: group['pinCode'] as String?,
                                assignedScreen: group['assignedScreen'] as String?,
                              );
                            },
                            icon: const Icon(Icons.chat_outlined, size: 16),
                            label: const Text('Chat with Host', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF475569),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isFull && !isJoined
                                ? null
                                : () {
                                    Navigator.pop(ctx);
                                    _toggleJoinGroup(group);
                                  },
                            icon: Icon(isJoined ? Icons.check_circle_rounded : Icons.lock_open_rounded, size: 16),
                            label: Text(
                              isJoined ? 'Leave Group' : (isFull ? 'Group Full' : 'Join & Split Now'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isJoined ? const Color(0xFFDC2626) : const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
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

  void _showCreateGroupModal() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final totalSlotsCtrl = TextEditingController(text: '4');
    final emailCtrl = TextEditingController();
    final pinCtrl = TextEditingController();
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
              constraints: const BoxConstraints(maxWidth: 540),
              child: SingleChildScrollView(
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
                        hintText: 'e.g. ChatGPT Plus, Netflix 4K, Spotify Family',
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
                              const Text('Total Slots (Seats)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                              const SizedBox(height: 6),
                              TextField(
                                controller: totalSlotsCtrl,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: '4',
                                  prefixIcon: const Icon(Icons.people_outline_rounded, size: 20, color: Color(0xFF64748B)),
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
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Input 3: Category & Login Email
                    Row(
                      children: [
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Profile PIN / Token', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                              const SizedBox(height: 6),
                              TextField(
                                controller: pinCtrl,
                                decoration: InputDecoration(
                                  hintText: 'e.g. 4829 or Invite link',
                                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                  prefixIcon: const Icon(Icons.vpn_key_outlined, size: 18, color: Color(0xFF64748B)),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                ),
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
                              final total = int.tryParse(totalSlotsCtrl.text.trim()) ?? 4;
                              final price = priceCtrl.text.isEmpty ? '250' : priceCtrl.text.replaceAll('৳', '').replaceAll('\$', '');
                              setState(() {
                                _groups.insert(0, {
                                  'id': DateTime.now().toString(),
                                  'title': titleCtrl.text,
                                  'host': 'You (Alex R.)',
                                  'slotsText': '1/$total slots filled',
                                  'progress': 1 / total,
                                  'badge': selectedCategory.toUpperCase(),
                                  'category': selectedCategory,
                                  'price': '৳$price',
                                  'period': '/mo',
                                  'isFull': false,
                                  'isJoined': true,
                                  'color': const Color(0xFF2563EB),
                                  'logo': '⭐',
                                  'totalSlots': total,
                                  'filledSlots': 1,
                                  'accountEmail': emailCtrl.text.isNotEmpty ? emailCtrl.text : 'you.campus@stanford.edu',
                                  'pinCode': pinCtrl.text.isNotEmpty ? pinCtrl.text : 'Active Host PIN',
                                  'assignedScreen': 'Host Screen 1',
                                  'members': [
                                    {'name': 'You (Alex Rivera)', 'role': 'Host (Owner)', 'status': 'Active', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80', 'screen': 'Screen 1'},
                                    for (int i = 2; i <= total; i++)
                                      {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Screen $i'},
                                  ],
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
        accountEmail: group['accountEmail'] as String?,
        pinCode: group['pinCode'] as String?,
        assignedScreen: group['assignedScreen'] as String?,
        hostName: group['host'] as String?,
        onOpenChat: () {
          HostChatDialog.show(
            context,
            hostName: group['host'] as String? ?? 'Group Host',
            groupTitle: group['title'] as String? ?? 'Subscription Group',
            accountEmail: group['accountEmail'] as String?,
            pinCode: group['pinCode'] as String?,
            assignedScreen: group['assignedScreen'] as String?,
          );
        },
        onPaymentSuccess: () {
          setState(() {
            group['isJoined'] = true;
            group['slotsText'] = 'Joined ✓';
            final members = group['members'] as List<dynamic>?;
            if (members != null) {
              for (final m in members) {
                if (m['status'] == 'Vacant') {
                  m['name'] = 'You (Joined)';
                  m['role'] = 'Member';
                  m['status'] = 'Active';
                  m['avatar'] = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80';
                  break;
                }
              }
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Joined ${group['title']} successfully! Check credentials now.'),
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
                          const SizedBox(height: 6),
                          const Text(
                            'Pool subscription seats with verified university peers for maximum savings.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _showHowItWorksDialog,
                          icon: const Icon(Icons.help_outline_rounded, size: 16),
                          label: const Text('How it Works', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0xFF93C5FD)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _showCreateGroupModal,
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Start a Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Category Chips
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF2563EB),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                // Groups Grid View
                if (filteredGroups.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No subscription groups found',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 6),
                          const Text('Try changing the search query or category filter.', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showCreateGroupModal,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Be the first to start a group!'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
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
                            onCardTap: () => _showGroupDetailsModal(group),
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
    required VoidCallback onCardTap,
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
      onCardTap: onCardTap,
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
  final VoidCallback onCardTap;
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
    required this.onCardTap,
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
      child: GestureDetector(
        onTap: widget.onCardTap,
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
      ),
    );
  }
}
