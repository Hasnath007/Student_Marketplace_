// 👥 Subscription Groups Screen (সাবস্ক্রিপশন শেয়ারিং পেজ)
// 📌 কাজ: Netflix, Spotify, Canva ইত্যাদি যৌথভাবে শেয়ার করার গ্রুপ লিস্ট, স্লট বুকিং ও হোস্ট চ্যাট।
// 🔗 ডায়ালগ: PaymentCheckoutDialog, HostChatDialog

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/providers/marketplace_provider.dart';
import '../../../core/providers/subscriptions_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../marketplace/widgets/payment_checkout_dialog.dart';
import '../widgets/host_chat_dialog.dart';

class SubscriptionGroupsScreen extends ConsumerStatefulWidget {
  const SubscriptionGroupsScreen({super.key});

  @override
  ConsumerState<SubscriptionGroupsScreen> createState() => _SubscriptionGroupsScreenState();
}

class _SubscriptionGroupsScreenState extends ConsumerState<SubscriptionGroupsScreen> {
  String _selectedCategory = 'All Categories';
  final List<String> _categories = ['All Categories', 'Entertainment', 'Academic', 'Productivity', 'AI Tools', 'Dev Tools'];



  Map<String, dynamic> _getBrandStyle(String title) {
    final t = title.toLowerCase();
    if (t.contains('netflix')) {
      return {'color': Colors.red.shade900, 'logo': 'N'};
    } else if (t.contains('spotify')) {
      return {'color': Colors.black, 'logo': '🟢'};
    } else if (t.contains('coursera')) {
      return {'color': const Color(0xFF0056D2), 'logo': 'C'};
    } else if (t.contains('adobe')) {
      return {'color': const Color(0xFFFF0000), 'logo': 'Ai'};
    } else if (t.contains('canva')) {
      return {'color': const Color(0xFF00C4CC), 'logo': 'C'};
    } else if (t.contains('prime') || t.contains('amazon')) {
      return {'color': const Color(0xFF00A8E1), 'logo': 'a'};
    } else if (t.contains('chatgpt') || t.contains('openai')) {
      return {'color': const Color(0xFF10A37F), 'logo': '🤖'};
    } else if (t.contains('youtube')) {
      return {'color': Colors.red, 'logo': '▶'};
    } else {
      final firstLetter = title.isNotEmpty ? title[0].toUpperCase() : '⭐';
      final colors = [const Color(0xFF2563EB), const Color(0xFF9333EA), const Color(0xFF0D9488), const Color(0xFFEA580C), const Color(0xFFE11D48)];
      final color = title.isNotEmpty ? colors[title.codeUnitAt(0) % colors.length] : const Color(0xFF2563EB);
      return {'color': color, 'logo': firstLetter};
    }
  }


  void _showGroupDetailsModal(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final user = FirebaseAuth.instance.currentUser;
          final currentUserName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Hasnat';
          
          final members = (group['members'] as List<dynamic>?) ?? [];
          final isJoined = members.any((m) => m['name'] == currentUserName && m['status'] != 'Vacant');
          
          final isFull = group['isFull'] == true;
          final isHost = group['host'] == currentUserName;

          return Dialog(
            backgroundColor: context.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: context.borderColor),
            ),
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
                                Text(group['title'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.textPrimary)),
                                Text('Host: ${group['host']}', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(onPressed: () => Navigator.pop(ctx), icon: Icon(Icons.close, size: 20, color: context.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Price & Slots Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.containerBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cost per Member', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                              const SizedBox(height: 2),
                              Text('৳${((group['totalPrice'] as int? ?? 0) / ((group['totalSlots'] as int? ?? 1) == 0 ? 1 : (group['totalSlots'] as int? ?? 1))).round()}${group['period']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isJoined ? const Color(0xFFD1FAE5) : const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isJoined ? 'You are a Member ✓' : (group['slotsText'] as String? ?? ''),
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
                    Text('Group Seats & Member Allocation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.textPrimary)),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        separatorBuilder: (_, _) => Divider(height: 1, color: context.borderColor),
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
                                    backgroundColor: isVacant ? context.containerBg : const Color(0xFFE0E7FF),
                                    child: isVacant
                                        ? Icon(Icons.person_add_alt_1_rounded, size: 16, color: context.textSecondary)
                                        : Text(
                                            (m['name'] as String).isNotEmpty ? (m['name'] as String)[0].toUpperCase() : 'U',
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                                          ),
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
                                          color: isVacant ? context.textMuted : context.textPrimary,
                                        ),
                                      ),
                                      Text('${m['role']} • ${m['screen']}', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isVacant ? context.containerBg : const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isVacant ? 'Open Seat' : 'Occupied',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isVacant ? context.textSecondary : const Color(0xFF047857)),
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
                    if (isJoined || isHost) ...[
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF0F172A).withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Builder(
                          builder: (context) {
                            final accessMethod = group['accessMethod'] as String? ?? 'login';
                            
                            if (accessMethod == 'link') {
                              final inviteLink = group['inviteLink']?.toString() ?? 'No invite link provided';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.shield_moon_rounded, size: 18, color: Color(0xFF38BDF8)),
                                      const SizedBox(width: 8),
                                      Text(
                                        isHost ? 'Host Access Credentials' : 'Your Secure Vault',
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.white, letterSpacing: 0.5),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0xFF047857).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(6)),
                                        child: const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF34D399))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  const Text('PREMIUM INVITE LINK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.0)),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFF334155)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            inviteLink,
                                            style: const TextStyle(fontSize: 13, color: Color(0xFF38BDF8), decoration: TextDecoration.underline),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: inviteLink));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Invite Link copied!'), backgroundColor: Color(0xFF0F172A), duration: Duration(seconds: 2))
                                            );
                                          },
                                          icon: const Icon(Icons.copy_rounded, size: 14),
                                          label: const Text('Copy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF0284C7),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                            minimumSize: const Size(0, 32),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Click Copy and paste this link in your browser to join the Family plan.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                ],
                              );
                            } else {
                              final loginEmail = group['accountEmail'] ?? 'group_access@campus.edu';
                              final mySeat = members.firstWhere(
                                (m) => m['name'] == currentUserName,
                                orElse: () => {'screen': group['assignedScreen'] ?? 'N/A'},
                              )['screen'];
                              final seatStr = mySeat != null && mySeat.toString().isNotEmpty ? mySeat.toString() : 'N/A';
                              final pinStr = (group['pinCode'] != null && group['pinCode'].toString().isNotEmpty) ? group['pinCode'].toString() : 'N/A';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.shield_moon_rounded, size: 18, color: Color(0xFF38BDF8)),
                                      const SizedBox(width: 8),
                                      Text(
                                        isHost ? 'Host Access Credentials' : 'Your Secure Vault',
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.white, letterSpacing: 0.5),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: const Color(0xFF047857).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(6)),
                                        child: const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF34D399))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  
                                  // Login Email
                                  const Text('ACCOUNT LOGIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.0)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(loginEmail.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC))),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: loginEmail.toString()));
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email copied to clipboard!'), backgroundColor: Color(0xFF0F172A), duration: Duration(seconds: 1)));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(color: const Color(0xFF334155), borderRadius: BorderRadius.circular(6)),
                                          child: const Icon(Icons.copy_rounded, size: 14, color: Color(0xFF38BDF8)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 14),
                                  const Divider(color: Color(0xFF334155), height: 1),
                                  const SizedBox(height: 14),
                                  
                                  // Profile & PIN
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('YOUR PROFILE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.0)),
                                            const SizedBox(height: 6),
                                            Text(seatStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC))),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('PROFILE PIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.0)),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Text(pinStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFF8FAFC), letterSpacing: 1.5)),
                                                const SizedBox(width: 8),
                                                InkWell(
                                                  onTap: () {
                                                    Clipboard.setData(ClipboardData(text: pinStr));
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN copied to clipboard!'), backgroundColor: Color(0xFF0F172A), duration: Duration(seconds: 1)));
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(color: const Color(0xFF334155), borderRadius: BorderRadius.circular(6)),
                                                    child: const Icon(Icons.copy_rounded, size: 14, color: Color(0xFF38BDF8)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          }
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
                                isHostMode: isHost,
                              );
                            },
                            icon: Icon(isHost ? Icons.forum_rounded : Icons.chat_outlined, size: 16),
                            label: Text(isHost ? 'Manage Group Chat' : 'Chat with Host', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: context.textPrimary,
                              side: BorderSide(color: context.borderColor),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: (isFull && !isJoined) || isHost
                                ? null
                                : () {
                                    Navigator.pop(ctx);
                                    _toggleJoinGroup(group);
                                  },
                            icon: Icon(isJoined ? Icons.exit_to_app_rounded : (isHost ? Icons.admin_panel_settings : Icons.lock_open_rounded), size: 16),
                            label: Text(
                              isHost ? 'You are Host' : (isJoined ? 'Leave Group' : (isFull ? 'Group Full' : 'Join & Split Now')),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isJoined ? const Color(0xFFDC2626) : (isHost ? const Color(0xFF94A3B8) : const Color(0xFF2563EB)),
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
    final inviteLinkCtrl = TextEditingController();
    String selectedCategory = 'Entertainment';
    String accessMethod = 'login';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            elevation: 8,
            backgroundColor: context.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: context.borderColor),
            ),
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
                                color: context.primaryContainerBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.add_task_rounded, color: context.primaryAccent, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start a Subscription Group',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.textPrimary, letterSpacing: -0.3),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Share subscriptions & split monthly costs with peers',
                                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(Icons.close_rounded, color: context.textSecondary, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Input 1: Group Name
                    Text('Service or Group Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleCtrl,
                      style: TextStyle(fontSize: 14, color: context.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'e.g. ChatGPT Plus, Netflix 4K, Spotify Family',
                        hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                        prefixIcon: Icon(Icons.layers_outlined, size: 20, color: context.textSecondary),
                        filled: true,
                        fillColor: context.containerBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.primaryAccent, width: 1.5)),
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
                              Text('Total Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: priceCtrl,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textPrimary),
                                decoration: InputDecoration(
                                  hintText: '৳1000 /mo',
                                  hintStyle: TextStyle(color: context.textMuted, fontSize: 13, fontWeight: FontWeight.normal),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text('৳', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.textSecondary)),
                                  ),
                                  filled: true,
                                  fillColor: context.containerBg,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.primaryAccent, width: 1.5)),
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
                              Text('Total Slots (Seats)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: totalSlotsCtrl,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textPrimary),
                                decoration: InputDecoration(
                                  hintText: '4',
                                  prefixIcon: Icon(Icons.people_outline_rounded, size: 20, color: context.textSecondary),
                                  filled: true,
                                  fillColor: context.containerBg,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.primaryAccent, width: 1.5)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Input 3: Category
                    Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      dropdownColor: context.cardBg,
                      style: TextStyle(fontSize: 13, color: context.textPrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.containerBg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                        DropdownMenuItem(value: 'Academic', child: Text('Academic')),
                        DropdownMenuItem(value: 'Productivity', child: Text('Productivity')),
                        DropdownMenuItem(value: 'AI Tools', child: Text('AI Tools')),
                        DropdownMenuItem(value: 'Dev Tools', child: Text('Dev Tools')),
                        DropdownMenuItem(value: 'Others', child: Text('Others')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Access Method Selector
                    Text('How will members access this?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => accessMethod = 'login'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: accessMethod == 'login' ? context.primaryContainerBg : context.containerBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: accessMethod == 'login' ? context.primaryAccent : context.borderColor, width: accessMethod == 'login' ? 1.5 : 1.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.password_rounded, size: 16, color: accessMethod == 'login' ? context.primaryAccent : context.textSecondary),
                                  const SizedBox(width: 6),
                                  Text('Shared Login', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accessMethod == 'login' ? context.primaryAccent : context.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => accessMethod = 'link'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: accessMethod == 'link' ? context.primaryContainerBg : context.containerBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: accessMethod == 'link' ? context.primaryAccent : context.borderColor, width: accessMethod == 'link' ? 1.5 : 1.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.link_rounded, size: 16, color: accessMethod == 'link' ? context.primaryAccent : context.textSecondary),
                                  const SizedBox(width: 6),
                                  Text('Invite Link', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accessMethod == 'link' ? context.primaryAccent : context.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Helper text for Hosts to understand what to choose
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: context.containerBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: context.borderColor)),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, size: 16, color: context.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              accessMethod == 'login' 
                                  ? 'Share your Email & Password/PIN (e.g., Netflix, ChatGPT Plus).'
                                  : 'Share a Premium Invite Link. No password needed (e.g., Spotify, Canva).',
                              style: TextStyle(fontSize: 11, color: context.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dynamic Inputs based on accessMethod
                    if (accessMethod == 'login') ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Account Email', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: emailCtrl,
                                  style: TextStyle(color: context.textPrimary, fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. host@email.com',
                                    hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                                    prefixIcon: Icon(Icons.email_outlined, size: 18, color: context.textSecondary),
                                    filled: true,
                                    fillColor: context.containerBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
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
                                Text('Password / Profile PIN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: pinCtrl,
                                  style: TextStyle(color: context.textPrimary, fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 4829 or MyPass123',
                                    hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                                    prefixIcon: Icon(Icons.vpn_key_outlined, size: 18, color: context.textSecondary),
                                    filled: true,
                                    fillColor: context.containerBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text('Premium Invite Link', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textSecondary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: inviteLinkCtrl,
                        style: TextStyle(color: context.textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'https://spotify.com/invite/...',
                          hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                          prefixIcon: Icon(Icons.link_rounded, size: 18, color: context.textSecondary),
                          filled: true,
                          fillColor: context.containerBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.borderColor)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),

                    // Actions Bar (Cancel & Publish)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: context.borderColor),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, color: context.textSecondary)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (titleCtrl.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a Service or Group Name.'), backgroundColor: Color(0xFFDC2626)));
                              return;
                            }
                            if (priceCtrl.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the Total Price.'), backgroundColor: Color(0xFFDC2626)));
                              return;
                            }
                            
                            if (accessMethod == 'login') {
                              if (emailCtrl.text.trim().isEmpty || pinCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Email and Password/PIN are required for Shared Login.'), backgroundColor: Color(0xFFDC2626)));
                                return;
                              }
                            } else {
                              if (inviteLinkCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Premium Invite Link is required.'), backgroundColor: Color(0xFFDC2626)));
                                return;
                              }
                            }

                            final total = int.tryParse(totalSlotsCtrl.text.trim()) ?? 4;
                            final rawPriceStr = priceCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
                            final parsedPrice = int.tryParse(rawPriceStr) ?? 1000;
                            final user = FirebaseAuth.instance.currentUser;
                            final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'You';
                            final userEmail = user?.email ?? emailCtrl.text;
                            final brandStyle = _getBrandStyle(titleCtrl.text);
                            
                            ref.read(subscriptionsProvider.notifier).addGroup({
                                'id': DateTime.now().toString(),
                                'title': titleCtrl.text,
                                'host': userName,
                                'slotsText': '0/$total slots filled',
                                'progress': 0.0,
                                'badge': selectedCategory.toUpperCase(),
                                'category': selectedCategory,
                                'totalPrice': parsedPrice,
                                'period': '/mo',
                                'isFull': false,
                                'isJoined': false,
                                'color': brandStyle['color'],
                                'logo': brandStyle['logo'],
                                'totalSlots': total,
                                'filledSlots': 0,
                                'accessMethod': accessMethod,
                                'inviteLink': inviteLinkCtrl.text,
                                'accountEmail': emailCtrl.text.isNotEmpty ? emailCtrl.text : userEmail,
                                'pinCode': pinCtrl.text.isNotEmpty ? pinCtrl.text : 'Active Host PIN',
                                'assignedScreen': '',
                                'members': [
                                  for (int i = 1; i <= total; i++)
                                    {'name': 'Available Slot', 'role': 'Open', 'status': 'Vacant', 'avatar': null, 'screen': 'Seat $i'},
                                ],
                              });
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Subscription Group created successfully!'), backgroundColor: Color(0xFF2563EB)),
                              );
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
    final user = FirebaseAuth.instance.currentUser;
    final currentUserName = user?.displayName ?? user?.email?.split('@')[0] ?? 'You';
    final membersList = (group['members'] as List<dynamic>?) ?? [];
    final isJoined = membersList.any((m) => m['name'] == currentUserName && m['status'] != 'Vacant');

    if (!isJoined) {
      PaymentCheckoutDialog.show(
        context,
        itemName: group['title'] ?? 'Subscription Group',
        priceText: '৳${((group['totalPrice'] as int? ?? 0) / ((group['totalSlots'] as int? ?? 1) == 0 ? 1 : (group['totalSlots'] as int? ?? 1))).round()}${group['period'] ?? '/mo'}',
        category: group['category'] ?? 'Subscription',
        accountEmail: group['accountEmail'] as String?,
        pinCode: group['pinCode'] as String?,
        assignedScreen: group['assignedScreen'] as String?,
        hostName: group['host'] as String?,
        accessMethod: group['accessMethod'] as String?,
        inviteLink: group['inviteLink'] as String?,
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
          final updatedGroup = Map<String, dynamic>.from(group);
          final members = List<dynamic>.from(updatedGroup['members'] ?? []);
          if (members.isNotEmpty) {
            for (int i = 0; i < members.length; i++) {
              final m = Map<String, dynamic>.from(members[i]);
              if (m['status'] == 'Vacant') {
                final user = FirebaseAuth.instance.currentUser;
                final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'You';
                
                m['name'] = userName;
                m['role'] = 'Member';
                m['status'] = 'Active';
                m['avatar'] = null;
                members[i] = m;
                final currentFilled = (updatedGroup['filledSlots'] as int? ?? 0) + 1;
                final total = updatedGroup['totalSlots'] as int? ?? 4;
                updatedGroup['filledSlots'] = currentFilled;
                updatedGroup['slotsText'] = '$currentFilled/$total slots filled';
                updatedGroup['isFull'] = currentFilled >= total;
                break;
              }
            }
          }
          updatedGroup['members'] = members;
          ref.read(subscriptionsProvider.notifier).updateGroup(updatedGroup['id'], updatedGroup);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Joined ${group['title']} successfully! Check credentials now.'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        },
      );
    } else {
      final updatedGroup = Map<String, dynamic>.from(group);
      
      final members = List<dynamic>.from(updatedGroup['members'] ?? []);
      for (int i = 0; i < members.length; i++) {
        final m = Map<String, dynamic>.from(members[i]);
        if (m['name'] == currentUserName) {
          m['name'] = 'Available Slot';
          m['role'] = 'Open';
          m['status'] = 'Vacant';
          m['avatar'] = null;
          members[i] = m;
          break;
        }
      }
      updatedGroup['members'] = members;

      final total = updatedGroup['totalSlots'] as int? ?? 4;
      final filled = (updatedGroup['filledSlots'] as int? ?? 1) - 1;
      updatedGroup['filledSlots'] = filled;
      updatedGroup['slotsText'] = '$filled/$total slots filled';
      updatedGroup['isFull'] = false;
      
      ref.read(subscriptionsProvider.notifier).updateGroup(updatedGroup['id'], updatedGroup);
      
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
    final groups = ref.watch(subscriptionsProvider);
    final cleanSearch = searchQuery.trim().toLowerCase();

    final filteredGroups = groups.where((g) {
      final gCat = (g['category'] as String? ?? '').toLowerCase();
      final gTitle = (g['title'] as String? ?? '').toLowerCase();
      final gBadge = (g['badge'] as String? ?? '').toLowerCase();
      final selCat = _selectedCategory.toLowerCase();

      bool matchesCategory = false;
      if (_selectedCategory == 'All Categories' || _selectedCategory == 'All') {
        matchesCategory = true;
      } else if (selCat == 'entertainment') {
        matchesCategory = gCat.contains('entertain') || gBadge.contains('entertain') || gTitle.contains('netflix') || gTitle.contains('spotify') || gTitle.contains('prime') || gTitle.contains('disney') || gTitle.contains('hulu') || gTitle.contains('youtube');
      } else if (selCat == 'academic') {
        matchesCategory = gCat.contains('academic') || gBadge.contains('academic') || gTitle.contains('coursera') || gTitle.contains('edx') || gTitle.contains('chegg') || gTitle.contains('grammarly') || gTitle.contains('study');
      } else if (selCat == 'productivity') {
        matchesCategory = gCat.contains('product') || gBadge.contains('product') || gTitle.contains('adobe') || gTitle.contains('canva') || gTitle.contains('notion') || gTitle.contains('office') || gTitle.contains('figma');
      } else if (selCat.contains('ai')) {
        matchesCategory = gCat.contains('ai') || gBadge.contains('ai') || gTitle.contains('chatgpt') || gTitle.contains('claude') || gTitle.contains('midjourney') || gTitle.contains('copilot');
      } else if (selCat.contains('dev')) {
        matchesCategory = gCat.contains('dev') || gBadge.contains('dev') || gTitle.contains('github') || gTitle.contains('jetbrains') || gTitle.contains('aws');
      } else {
        matchesCategory = gCat == selCat || gCat.contains(selCat);
      }

      bool matchesSearch = true;
      if (cleanSearch.isNotEmpty) {
        final queryTerms = cleanSearch.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
        matchesSearch = queryTerms.every((term) =>
            gTitle.contains(term) ||
            (g['host'] as String? ?? '').toLowerCase().contains(term) ||
            gCat.contains(term) ||
            gBadge.contains(term) ||
            ((g['totalPrice'] ?? 0).toString()).contains(term) ||
            (g['accountEmail'] as String? ?? '').toLowerCase().contains(term));
      }

      return matchesCategory && matchesSearch;
    }).toList();

    int getSubCategoryCount(String cat) {
      if (cat == 'All Categories' || cat == 'All') return groups.length;
      final sel = cat.toLowerCase();
      return groups.where((g) {
        final gCat = (g['category'] as String? ?? '').toLowerCase();
        final gTitle = (g['title'] as String? ?? '').toLowerCase();
        final gBadge = (g['badge'] as String? ?? '').toLowerCase();
        if (sel == 'entertainment') {
          return gCat.contains('entertain') || gBadge.contains('entertain') || gTitle.contains('netflix') || gTitle.contains('spotify');
        } else if (sel == 'academic') {
          return gCat.contains('academic') || gBadge.contains('academic') || gTitle.contains('coursera') || gTitle.contains('edx');
        } else if (sel == 'productivity') {
          return gCat.contains('product') || gBadge.contains('product') || gTitle.contains('adobe') || gTitle.contains('canva');
        } else if (sel.contains('ai')) {
          return gCat.contains('ai') || gBadge.contains('ai') || gTitle.contains('chatgpt');
        } else if (sel.contains('dev')) {
          return gCat.contains('dev') || gBadge.contains('dev') || gTitle.contains('github');
        }
        return gCat == sel;
      }).length;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          Text(
                            'COST SHARING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: context.primaryAccent,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Share Costs, Save Money',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: context.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Pool subscription seats with verified university peers for maximum savings.',
                            style: TextStyle(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showCreateGroupModal,
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Start a Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryAccent,
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
                const SizedBox(height: 24),

                // Category Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        final count = getSubCategoryCount(cat);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cat),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white.withValues(alpha: 0.25) : context.containerBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : context.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) setState(() => _selectedCategory = cat);
                            },
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : context.textSecondary,
                            ),
                            backgroundColor: context.cardBg,
                            selectedColor: context.primaryAccent,
                            side: BorderSide(
                              color: isSelected ? context.primaryAccent : context.borderColor,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            showCheckmark: false,
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
                ),
                const SizedBox(height: 16),

                // Active Filter Status Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${filteredGroups.length} ${filteredGroups.length == 1 ? 'group' : 'groups'} in $_selectedCategory',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                    if (_selectedCategory != 'All Categories' || searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = 'All Categories');
                          ref.read(searchQueryProvider.notifier).setQuery('');
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.refresh_rounded, size: 14, color: Color(0xFF2563EB)),
                            SizedBox(width: 4),
                            Text('Reset All Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

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
                      final currentUser = FirebaseAuth.instance.currentUser;
                      final currentUserName = currentUser?.displayName ?? currentUser?.email?.split('@')[0] ?? 'You';

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
                          final isHost = group['host'] == currentUserName;
                          
                          // Check if current user is in the members list
                          final members = (group['members'] as List<dynamic>?) ?? [];
                          final isJoined = members.any((m) => m['name'] == currentUserName && m['status'] != 'Vacant');

                          String btnText = 'Join Group';
                          if (isHost) {
                            btnText = 'Your Group';
                          } else if (isJoined) {
                            btnText = 'Joined ✓';
                          } else if (isFull) {
                            btnText = 'Full';
                          }

                          return _buildGroupCard(
                            title: group['title'],
                            host: group['host'],
                            slotsText: isJoined ? 'Joined ✓' : (group['slotsText'] ?? ''),
                            progress: group['progress'],
                            badge: group['badge'],
                            price: '৳${((group['totalPrice'] as int? ?? 0) / ((group['totalSlots'] as int? ?? 1) == 0 ? 1 : (group['totalSlots'] as int? ?? 1))).round()}',
                            period: group['period'],
                            buttonText: btnText,
                            isDisabled: isFull || isHost,
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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? context.primaryAccent : context.borderColor,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? Colors.black.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.04),
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
                      decoration: BoxDecoration(color: context.primaryContainerBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(widget.badge, style: TextStyle(color: context.primaryAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.2, color: context.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('👤 Host: ${widget.host}', style: TextStyle(fontSize: 11, color: context.textSecondary)),
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
                backgroundColor: context.borderColor,
                color: widget.isDisabled ? Colors.red : (widget.isJoined ? const Color(0xFF10B981) : const Color(0xFF2563EB)),
                minHeight: 4,
                borderRadius: BorderRadius.circular(4),
              ),
              const Spacer(),
              Divider(height: 1, color: context.borderColor),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PER PERSON', style: TextStyle(fontSize: 9, color: context.textMuted, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Text(widget.price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: context.textPrimary)),
                          Text(widget.period, style: TextStyle(fontSize: 11, color: context.textSecondary)),
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
