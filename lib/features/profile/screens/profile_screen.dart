// 👤 Profile Screen (ইউজার প্রোফাইল ও সেটিংস পেজ)
// 📌 কাজ: ব্যবহারকারীর তথ্য, মোট ব্যালেন্স, মাই লিস্টিং (My Listings), অর্ডার হিস্ট্রি ও সেটিংস।
// 🔗 ডায়ালগ: HostChatDialog, GoRouter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../subscriptions/widgets/host_chat_dialog.dart';
import '../../chat/widgets/dynamic_chat_dialog.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/order_service.dart';
import '../../../core/models/order_model.dart';
import '../../../core/providers/marketplace_provider.dart';
import '../../../core/providers/subscriptions_provider.dart';
import '../../../core/providers/admin_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../models/product.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedTab = 0;
  bool _linearAlgebraReceived = false;
  double _availableBalance = 2850.0;
  final double _pendingBalance = 650.0;
  double _totalWithdrawn = 3000.0;

  Stream<DocumentSnapshot>? _userDocStream;

  @override
  void initState() {
    super.initState();
    _initUserDocStream();
  }

  void _initUserDocStream() {
    if (Firebase.apps.isNotEmpty) {
      final uid = FirebaseAuth.instance.currentUser?.uid.trim() ?? '';
      if (uid.isNotEmpty && !uid.contains('/')) {
        try {
          _userDocStream = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
          return;
        } catch (_) {}
      }
    }
    _userDocStream = const Stream<DocumentSnapshot>.empty();
  }



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
    String selectedCat = (listing['category'] as String?) ?? 'Books';
    bool isSold = listing['isSold'] as bool;

    final categories = ['Books', 'Electronics', 'Stationery', 'Notes', 'Digital Services'];

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
              color: context.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
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
                    Text(
                      'Edit Listing',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close_rounded, color: context.textSecondary, size: 20),
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

                // Category & Price Row
                Row(
                  children: [
                    // Category Dropdown
                    Expanded(
                      flex: 6,
                      child: DropdownButtonFormField<String>(
                        initialValue: categories.contains(selectedCat) ? selectedCat : 'Books',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                        decoration: InputDecoration(
                          labelText: 'Category',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedCat = val);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Price Input
                    Expanded(
                      flex: 4,
                      child: TextField(
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
                    ),
                  ],
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
                            color: isSold ? context.textSecondary : context.textPrimary,
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
                        ref.read(marketplaceProvider.notifier).deleteProduct(listing['id']);
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

                        final updatedProduct = (listing['_originalProduct'] as Product).copyWith(
                          title: newTitle,
                          price: double.tryParse(newPrice) ?? 0.0,
                          description: newDesc,
                          category: selectedCat,
                          isSold: isSold,
                        );
                        ref.read(marketplaceProvider.notifier).updateProduct(updatedProduct);

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
            Text('Edit Profile Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)),
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

  void _showHelpAndReportDialog({
    required String itemTitle,
    required String sellerName,
    required double amount,
  }) {
    final issueController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedReason = 'Payout delayed past 24 hours';
    final reasons = [
      'Payout delayed past 24 hours',
      'Handover complete but balance not updated',
      'Buyer did not show up on campus',
      'Wrong payment amount received',
      'Other payment/order issue',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.support_agent_rounded, color: Color(0xFFDC2626), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Need Help / Report Issue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
                    Text('Direct message to Admin Support', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.containerBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order / Item: $itemTitle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textPrimary)),
                        const SizedBox(height: 2),
                        Text('Amount: ৳${amount.toStringAsFixed(0)} • Party: $sellerName', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select Issue Reason', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedReason,
                        isExpanded: true,
                        items: reasons.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 12)))).toList(),
                        onChanged: (v) {
                          if (v != null) setModalState(() => selectedReason = v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Your bKash / Nagad Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'e.g. 01712345678',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Details / Explanation (Optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: issueController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe what happened...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Student';
                final phone = phoneController.text.trim();
                final note = issueController.text.trim();
                
                final fullReason = '$selectedReason ${phone.isNotEmpty ? "(Wallet: $phone)" : ""} ${note.isNotEmpty ? "- $note" : ""}';
                
                final newReport = AdminReport(
                  id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
                  reportedItem: '$itemTitle (৳${amount.toStringAsFixed(0)})',
                  reportedBy: userName,
                  reason: fullReason,
                  type: 'product',
                  status: 'pending',
                  date: 'Just now',
                );

                ref.read(adminReportsProvider.notifier).addReport(newReport);
                orderService.submitDisputeReport(
                  orderId: itemTitle,
                  itemName: '$itemTitle (৳${amount.toStringAsFixed(0)})',
                  reason: fullReason,
                  contactNumber: phone,
                  notes: note,
                );
                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Report submitted to Admin! They will review your payout promptly.'),
                    backgroundColor: Color(0xFF059669),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Submit to Admin'),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawModal([double? currentAvailable]) {
    final effectiveAvailable = currentAvailable ?? _availableBalance;
    final amountController = TextEditingController(text: effectiveAvailable > 0 ? (effectiveAvailable > 500 ? '500' : effectiveAvailable.toStringAsFixed(0)) : '0');
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Withdraw Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)),
                              Text('Instant Payout to your mobile wallet', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close, size: 20, color: context.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Current Balance Pill
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.containerBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Available Balance:', style: TextStyle(fontSize: 13, color: context.textSecondary)),
                        Text('৳${effectiveAvailable.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Select Payout Method
                  Text('Payout Method', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedMethod = 'bKash'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedMethod == 'bKash' ? (context.isDarkMode ? const Color(0xFF831843).withValues(alpha: 0.3) : const Color(0xFFFDF2F8)) : context.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedMethod == 'bKash' ? const Color(0xFFE11D48) : context.borderColor,
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
                              color: selectedMethod == 'Nagad' ? (context.isDarkMode ? const Color(0xFF78350F).withValues(alpha: 0.3) : const Color(0xFFFFFBEB)) : context.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedMethod == 'Nagad' ? const Color(0xFFD97706) : context.borderColor,
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
                  Text('Wallet Account Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textPrimary)),
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
        Text(label, style: TextStyle(fontSize: 12, color: context.textSecondary)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.textPrimary)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscriptions = ref.watch(subscriptionsProvider);
    final authUser = FirebaseAuth.instance.currentUser;
    final authUserName = authUser?.displayName ?? authUser?.email?.split('@')[0] ?? 'Hasnat';
    
    final hostedGroups = subscriptions.where((g) => g['host'] == authUserName).toList();
    final joinedGroups = subscriptions.where((g) {
      final members = (g['members'] as List<dynamic>?) ?? [];
      return members.any((m) => m['name'] == authUserName);
    }).toList();
    final totalSubs = hostedGroups.length + joinedGroups.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: _userDocStream,
                    builder: (context, snapshot) {
                      String userName = 'Student';
                      String userDept = 'University Student';
                      String joinedDate = 'Joined Recently';
                      String? photoUrl;
                      bool isAdmin = false;

                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                        userName = data['name'] ?? userName;
                        userDept = data['department'] ?? userDept;
                        photoUrl = data['photoUrl'] ?? data['profileImageUrl'];
                        final role = (data['role'] ?? '').toString().toLowerCase();
                        final userEmail = (FirebaseAuth.instance.currentUser?.email ?? '').toLowerCase();
                        if (role == 'admin' ||
                            data['isAdmin'] == true ||
                            userEmail == 'studentmarket@gmail.com' ||
                            userEmail.startsWith('studentmarket') ||
                            userEmail.startsWith('admin@')) {
                          isAdmin = true;
                        }
                        if (data['createdAt'] != null) {
                          final date = (data['createdAt'] as Timestamp).toDate();
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          joinedDate = 'Joined ${months[date.month - 1]} ${date.year}';
                        }
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar with verified badge
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 46,
                                backgroundColor: const Color(0xFF2563EB),
                                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                                child: photoUrl == null 
                                  ? Text(
                                      userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                                    )
                                  : null,
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
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: context.textPrimary,
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
                                    const Icon(Icons.school_outlined, size: 16, color: Color(0xFF3B82F6)),
                                    const SizedBox(width: 4),
                                    Text('University Student', style: TextStyle(fontSize: 13, color: context.textSecondary)),
                                    Text('  •  ', style: TextStyle(color: context.textMuted)),
                                    const Icon(Icons.science_outlined, size: 16, color: Color(0xFF3B82F6)),
                                    const SizedBox(width: 4),
                                    Text(userDept, style: TextStyle(fontSize: 13, color: context.textSecondary)),
                                    Text('  •  ', style: TextStyle(color: context.textMuted)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: context.containerBg,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(joinedDate, style: TextStyle(fontSize: 11, color: context.textSecondary)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Student at the university. Interested in textbooks, electronics, and sharing subscriptions.',
                                  style: TextStyle(fontSize: 13, color: context.textSecondary, height: 1.4),
                                ),
                              ],
                            ),
                          ),

                          // Admin Dashboard Button (Only for Admins)
                          if (isAdmin) ...[
                            ElevatedButton.icon(
                              onPressed: () => context.go('/admin'),
                              icon: const Icon(Icons.admin_panel_settings_rounded, size: 16, color: Colors.white),
                              label: const Text(
                                'Admin Panel',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0052CC),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],

                          // Sign Out Button
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (Firebase.apps.isNotEmpty) {
                                await FirebaseAuth.instance.signOut();
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Logged out successfully')),
                                );
                                context.go('/landing');
                              }
                            },
                            icon: Icon(Icons.logout_rounded, size: 16, color: context.isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626)),
                            label: Text('Sign Out', style: TextStyle(color: context.isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.isDarkMode ? const Color(0xFF7F1D1D).withValues(alpha: 0.35) : const Color(0xFFFEE2E2),
                              side: BorderSide(color: context.isDarkMode ? const Color(0xFFEF4444).withValues(alpha: 0.4) : const Color(0xFFFCA5A5)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
                const SizedBox(height: 24),

                // Tabs Bar (5 Tabs)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTabItem(0, 'My Listings', '${ref.watch(marketplaceProvider).where((p) {
                        final u = FirebaseAuth.instance.currentUser;
                        final prefix = u?.email?.split('@')[0] ?? '';
                        return p.sellerId == (u?.uid ?? '') || p.sellerName == (u?.displayName ?? '') || (prefix.isNotEmpty && p.sellerName == prefix);
                      }).length}'),
                      const SizedBox(width: 24),
                      _buildTabItem(1, 'Subscriptions', '$totalSubs'),
                      const SizedBox(width: 24),
                      _buildTabItem(2, 'My Orders (SafePay)', null),
                      const SizedBox(width: 24),
                      _buildTabItem(3, 'Seller Wallet & Payout', null),
                      const SizedBox(width: 24),
                      _buildTabItem(4, 'Settings', null),
                    ],
                  ),
                ),
                Divider(height: 1, color: context.borderColor),
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
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? '';
    final currentUserDisplayName = currentUser?.displayName ?? '';
    final currentUserEmailPrefix = currentUser?.email?.split('@')[0] ?? '';
    
    final allProducts = ref.watch(marketplaceProvider);
    
    // Dynamic Listings Filtering
    final myProducts = allProducts.where((p) {
      if (p.sellerId == currentUserId) return true;
      if (currentUserDisplayName.isNotEmpty && p.sellerName == currentUserDisplayName) return true;
      if (currentUserEmailPrefix.isNotEmpty && p.sellerName == currentUserEmailPrefix) return true;
      return false;
    }).toList();
    
    final myListings = myProducts.map((p) => {
      'id': p.id,
      'title': p.title,
      'price': p.price.toStringAsFixed(0),
      'desc': p.description,
      'imageUrl': p.imageUrl,
      'status': p.isSold ? 'Sold' : 'Active',
      'isSold': p.isSold,
      'views': '0 views', // Dynamic views not available yet
      'category': p.category,
      '_originalProduct': p, // Store reference for updating
    }).toList();

    if (_selectedTab == 0) {
      final activeCount = myListings.where((l) => !(l['isSold'] as bool)).length;
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textPrimary),
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
          Text(
            'Click on any listing card or the "Edit" button to update price, description, or mark as sold.',
            style: TextStyle(fontSize: 12, color: context.textSecondary),
          ),
          const SizedBox(height: 18),
          if (myListings.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Center(
                child: Text('No listings found. Tap "+ New Listing" to add one!', style: TextStyle(color: context.textSecondary)),
              ),
            )
          else
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: myListings.map((listing) {
                return SizedBox(
                  width: 320,
                  child: _buildListingCard(listing),
                );
              }).toList(),
            ),
        ],
      );
    } else if (_selectedTab == 1) {
      final subscriptions = ref.watch(subscriptionsProvider);
      final user = FirebaseAuth.instance.currentUser;
      final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Hasnat';
      
      final hostedGroups = subscriptions.where((g) => g['host'] == userName).toList();
      final joinedGroups = subscriptions.where((g) {
        final members = (g['members'] as List<dynamic>?) ?? [];
        return members.any((m) => m['name'] == userName);
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SECTION 1: GROUPS HOSTED BY YOU (OWNER)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.stars_rounded, color: context.primaryAccent, size: 22),
                  const SizedBox(width: 8),
                  Text('Groups Hosted by You (Owner)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/subscriptions'),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(hostedGroups.isEmpty ? 'Start a Group' : 'Start Another Group', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.primaryAccent,
                  side: BorderSide(color: context.primaryAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Hosted Card
          if (hostedGroups.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('You are not hosting any groups.', style: TextStyle(color: Colors.grey)),
            )
          else
            Column(
              children: hostedGroups.map((g) {
                final members = (g['members'] as List<dynamic>?) ?? [];
                final memberNames = members.map((m) => m['name'] as String).toList();
                final pricePerSeat = ((g['totalPrice'] as int? ?? 0) / ((g['totalSlots'] as int? ?? 1) == 0 ? 1 : (g['totalSlots'] as int? ?? 1))).round();
                final revenue = pricePerSeat * (g['filledSlots'] as int? ?? 0);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildHostedGroupCard(
                    groupId: g['id'],
                    title: g['title'],
                    host: g['host'] as String? ?? (FirebaseAuth.instance.currentUser?.displayName ?? 'Host'),
                    price: '৳$pricePerSeat ${g['period']}',
                    filledSlots: '${g['filledSlots']}/${g['totalSlots']} slots filled',
                    totalRevenue: '+৳$revenue ${g['period']}',
                    email: g['accountEmail'],
                    pin: g['pinCode'],
                    members: memberNames,
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 32),

          // SECTION 2: GROUPS JOINED AS MEMBER
          Row(
            children: [
              const Icon(Icons.group_rounded, color: Color(0xFF059669), size: 22),
              const SizedBox(width: 8),
              Text('Groups Joined as Member', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.textPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          if (joinedGroups.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('You have not joined any groups.', style: TextStyle(color: Colors.grey)),
            )
          else
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: joinedGroups.map((g) {
                final pricePerSeat = ((g['totalPrice'] as int? ?? 0) / ((g['totalSlots'] as int? ?? 1) == 0 ? 1 : (g['totalSlots'] as int? ?? 1))).round();
                return SizedBox(
                  width: 320,
                  child: _buildJoinedGroupCard(
                    g['title'],
                    '৳$pricePerSeat ${g['period']}',
                    '${g['host']} (Host)',
                    'Next billing: N/A',
                    g['accountEmail'],
                    'Your Seat', 
                    g['pinCode'],
                  ),
                );
              }).toList(),
            ),
        ],
      );
    } else if (_selectedTab == 2) {
      return _buildDynamicBuyerOrdersTab();
    } else if (_selectedTab == 3) {
      return _buildDynamicSellerWalletTab();
    } else if (_selectedTab == 9999) {
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
                  Text('My Purchases & SafePay Handover', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
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
                        'Campus SafePay Protection is Active 🛡️',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E3A8A)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your bKash / Nagad payment is held safely in SafePay. The seller does NOT receive payment until you meet in person on campus, check the item condition, and tap "Item Received" (or give your 4-digit PIN).',
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
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: context.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Active Order Item Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.cardBg,
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
                        errorBuilder: (context, error, stackTrace) => Container(width: 70, height: 70, color: context.containerBg),
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
                              Text(
                                'Introduction to Linear Algebra, 5th Ed',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: context.textPrimary),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _linearAlgebraReceived ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _linearAlgebraReceived ? 'COMPLETED ✓' : 'IN SAFEPAY VAULT',
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
                          Text('Paid ৳1,500 via bKash • Seller: Alex R. (Verified Campus Student)', style: TextStyle(fontSize: 12, color: context.textSecondary)),
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
                      color: context.isDarkMode ? const Color(0xFF78350F).withValues(alpha: 0.25) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.isDarkMode ? const Color(0xFFD97706).withValues(alpha: 0.5) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.key_rounded, color: Color(0xFFD97706), size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Handover Verification PIN', style: TextStyle(fontSize: 10, color: context.textSecondary, fontWeight: FontWeight.bold)),
                            Text('PIN: #8492', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: context.isDarkMode ? const Color(0xFFFDE68A) : const Color(0xFF0F172A), letterSpacing: 1.5)),
                          ],
                        ),
                        const Spacer(),
                        Text('Tell seller this PIN or confirm below when meeting', style: TextStyle(fontSize: 11, color: context.textSecondary)),
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _showHelpAndReportDialog(
                        itemTitle: 'Introduction to Linear Algebra, 5th Ed',
                        sellerName: 'Alex R.',
                        amount: 1500,
                      ),
                      icon: const Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFFDC2626)),
                      label: const Text('Having an issue? Report to Admin', style: TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
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
          Text('Past Completed Purchases', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: context.textPrimary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Keychron K2 Wireless Mechanical Keyboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textPrimary)),
                      const SizedBox(height: 2),
                      Text('৳1,500 • Delivered on 28 Aug 2026 • Seller: Tanvir Hossain', style: TextStyle(fontSize: 11, color: context.textSecondary)),
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
              color: context.containerBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.hub_rounded, color: context.textSecondary, size: 18),
                    const SizedBox(width: 8),
                    Text('How Admin & System Verifies Handover Automatically', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStepChip('1', 'bKash/Nagad SafePay'),
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
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showHelpAndReportDialog(
                      itemTitle: 'Seller Payout / Withdrawal',
                      sellerName: 'Admin Support',
                      amount: _availableBalance > 0 ? _availableBalance : 1000,
                    ),
                    icon: const Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFFDC2626)),
                    label: const Text('Report Payout Delay', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                  title: 'Pending in SafePay',
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
      final currentThemeMode = ref.watch(themeModeProvider);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance & Display Mode',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose how Student Marketplace looks to you across web and mobile',
            style: TextStyle(fontSize: 13, color: context.textSecondary),
          ),
          const SizedBox(height: 16),

          // Theme Selector Cards (Light, Dark, System)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.primaryContainerBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.palette_outlined, size: 20, color: context.primaryAccent),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme Preference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: context.textPrimary)),
                        Text('Select your preferred color theme', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2 Choice Cards: Light Theme & Dark Theme
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      children: [
                        // Light Mode
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: _buildThemeOptionCard(
                            title: 'Light Theme',
                            description: 'Crisp bright interface for daytime',
                            icon: Icons.light_mode_rounded,
                            iconColor: const Color(0xFFD97706),
                            isSelected: currentThemeMode == ThemeMode.light,
                            onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light),
                          ),
                        ),
                        SizedBox(width: isMobile ? 0 : 14, height: isMobile ? 12 : 0),

                        // Dark Mode
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: _buildThemeOptionCard(
                            title: 'Dark Theme',
                            description: 'Sleek obsidian look for night studying',
                            icon: Icons.dark_mode_rounded,
                            iconColor: const Color(0xFF38BDF8),
                            isSelected: currentThemeMode == ThemeMode.dark,
                            onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildThemeOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected 
              ? (context.isDarkMode ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF))
              : context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? context.primaryAccent : context.borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.primaryAccent.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, size: 20, color: context.primaryAccent)
                else
                  Icon(Icons.radio_button_unchecked_rounded, size: 20, color: context.borderColor),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? context.primaryAccent : context.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 11, color: context.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepChip(String step, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: context.primaryAccent,
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
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textPrimary),
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
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
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
              Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textSecondary)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: context.textPrimary, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11, color: context.textMuted)),
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
                    color: isSelected ? context.primaryAccent : context.textSecondary,
                  ),
                  child: Text(label),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? context.primaryContainerBg : context.containerBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? context.primaryAccent : context.textSecondary,
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
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered
                  ? context.primaryAccent
                  : context.borderColor,
              width: isHovered ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? context.primaryAccent.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.05),
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
                          color: isSold ? Colors.black.withValues(alpha: 0.7) : context.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.borderColor),
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
                                color: isSold ? Colors.white : context.textPrimary,
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
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2, color: context.textPrimary),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '৳$price',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: context.primaryAccent),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: context.textSecondary, height: 1.3),
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
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)),
                child: const Text('ACTIVE MEMBER', style: TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(price, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: context.primaryAccent)),
          const SizedBox(height: 4),
          Text('👑 $host', style: TextStyle(fontSize: 12, color: context.textSecondary)),
          const SizedBox(height: 12),
          Text('📅 $billing', style: TextStyle(fontSize: 11, color: context.textMuted)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCredentialsModal(title, email, profile, pin),
                  icon: const Icon(Icons.vpn_key_rounded, size: 15),
                  label: const Text('View Credentials', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryContainerBg,
                    foregroundColor: context.primaryAccent,
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
                  foregroundColor: context.textPrimary,
                  side: BorderSide(color: context.borderColor),
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
    required String groupId,
    required String title,
    required String host,
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
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.primaryAccent.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: context.primaryAccent.withValues(alpha: 0.08),
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
                      color: context.primaryContainerBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.stars_rounded, color: context.primaryAccent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.textPrimary)),
                      Text('You are the Host / Admin', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('HOSTED BY YOU', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      ref.read(subscriptionsProvider.notifier).deleteGroup(groupId);
                    },
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    tooltip: 'Delete Group',
                  ),
                ],
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
                  Text('Price per Seat', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                  const SizedBox(height: 2),
                  Text(price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: context.primaryAccent)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Slots Occupied', style: TextStyle(fontSize: 11, color: context.textSecondary)),
                  const SizedBox(height: 2),
                  Text(filledSlots, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: context.textPrimary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Monthly Revenue', style: TextStyle(fontSize: 11, color: context.textSecondary)),
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
              color: context.containerBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.people_alt_outlined, size: 16, color: context.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Active Members: ',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary),
                      children: [
                        TextSpan(
                          text: members.join(", "),
                          style: TextStyle(fontWeight: FontWeight.normal, color: context.textPrimary),
                        ),
                      ],
                    ),
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
                    hostName: host,
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
                  foregroundColor: context.textPrimary,
                  side: BorderSide(color: context.borderColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicBuyerOrdersTab() {
    return StreamBuilder<List<OrderModel>>(
      stream: orderService.streamBuyerOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final orders = snapshot.data ?? [];
        final activeOrders = orders.where((o) => o.status == 'in_safepay').toList();
        final completedOrders = orders.where((o) => o.status == 'completed').toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Purchases & SafePay Handover', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textPrimary)),
                    const SizedBox(height: 2),
                    Text('Track items you bought, view your 4-digit verification PIN, and confirm receipt', style: TextStyle(fontSize: 13, color: context.textSecondary)),
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

            // SafePay Safety Explainer Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.isDarkMode ? const Color(0xFF1E3A8A).withValues(alpha: 0.25) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.isDarkMode ? const Color(0xFF2563EB).withValues(alpha: 0.5) : const Color(0xFFBFDBFE)),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Campus SafePay Protection is Active 🛡️',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: context.isDarkMode ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your bKash / Nagad payment is held safely in SafePay. The seller does NOT receive payment until you meet in person on campus, check the item condition, and tap "Item Received" (or give your 4-digit PIN).',
                          style: TextStyle(fontSize: 12, color: context.isDarkMode ? const Color(0xFFBFDBFE) : const Color(0xFF1E40AF), height: 1.4),
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
                  activeOrders.isEmpty ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                  color: activeOrders.isEmpty ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  activeOrders.isEmpty ? 'Active Orders (0)' : 'Active Orders (${activeOrders.length} Awaiting Campus Handover)',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: context.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (activeOrders.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 44, color: context.textSecondary),
                    const SizedBox(height: 10),
                    Text('No Active SafePay Orders', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: context.textPrimary)),
                    const SizedBox(height: 4),
                    Text('When you purchase an item using SafePay, your live order and 4-digit PIN will appear here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () => context.go('/marketplace'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Browse Campus Deals'),
                    ),
                  ],
                ),
              )
            else
              ...activeOrders.map((order) => _buildDynamicActiveOrderCard(order)),

            const SizedBox(height: 32),

            // PAST COMPLETED PURCHASES SECTION
            Text('Past Completed Purchases', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: context.textPrimary)),
            const SizedBox(height: 12),

            if (completedOrders.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Center(
                  child: Text('No completed purchases yet.', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                ),
              )
            else
              ...completedOrders.map((order) => _buildDynamicCompletedOrderCard(order)),

            const SizedBox(height: 28),

            // Admin Transparency Guide Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: context.containerBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.hub_rounded, color: context.textSecondary, size: 18),
                    const SizedBox(width: 8),
                    Text('How Admin & System Verifies Handover Automatically', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStepChip('1', 'bKash/Nagad SafePay'),
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
    },
  );
}

Widget _buildDynamicSellerWalletTab() {
  return StreamBuilder<List<OrderModel>>(
    stream: orderService.streamSellerOrders(),
    builder: (context, snapshot) {
      final sellerOrders = snapshot.data ?? [];
      final activeSales = sellerOrders.where((o) => o.status == 'in_safepay').toList();
      final completedSales = sellerOrders.where((o) => o.status == 'completed').toList();

      final livePending = activeSales.fold<double>(0.0, (acc, o) => acc + o.price);
      final liveAvailable = completedSales.fold<double>(0.0, (acc, o) => acc + o.price);
      final liveTotalRevenue = liveAvailable + livePending;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Quick Withdraw Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller Earnings & Wallet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textPrimary)),
                    SizedBox(height: 2),
                    Text('Track sales income, split revenue, and withdraw instantly', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _showHelpAndReportDialog(
                        itemTitle: 'Seller Payout / Withdrawal',
                        sellerName: 'Admin Support',
                        amount: liveAvailable > 0 ? liveAvailable : 1000,
                      ),
                      icon: const Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFFDC2626)),
                      label: const Text('Report Payout Delay', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => _showWithdrawModal(liveAvailable),
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
              ],
            ),
            const SizedBox(height: 20),

            // 4 Metric Stat Cards
            Row(
              children: [
                Expanded(
                  child: _buildWalletStatCard(
                    title: 'Available for Withdrawal',
                    amount: '৳${liveAvailable.toStringAsFixed(0)}',
                    subtitle: 'Ready to cash out',
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: const Color(0xFF059669),
                    bgColor: const Color(0xFFECFDF5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWalletStatCard(
                    title: 'Pending in SafePay',
                    amount: '৳${livePending.toStringAsFixed(0)}',
                    subtitle: '${activeSales.length} item(s) awaiting handover',
                    icon: Icons.hourglass_empty_rounded,
                    iconColor: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFFFBEB),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWalletStatCard(
                    title: 'Total Revenue Earned',
                    amount: '৳${liveTotalRevenue.toStringAsFixed(0)}',
                    subtitle: 'From ${sellerOrders.length} sale(s)',
                    icon: Icons.trending_up_rounded,
                    iconColor: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWalletStatCard(
                    title: 'Total Withdrawn',
                    amount: '৳0',
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
            Text('Recent Earnings & Sales History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
            const SizedBox(height: 12),

            if (sellerOrders.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  children: [
                    Icon(Icons.storefront_outlined, size: 40, color: context.textSecondary),
                    const SizedBox(height: 10),
                    Text('No sales yet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: context.textPrimary)),
                    const SizedBox(height: 4),
                    Text('List your textbooks or stationery to earn campus income!', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                  ],
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sellerOrders.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: context.borderColor),
                  itemBuilder: (context, index) {
                    final order = sellerOrders[index];
                    final isCompleted = order.status == 'completed';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (isCompleted ? const Color(0xFF059669) : const Color(0xFFD97706)).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCompleted ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                              color: isCompleted ? const Color(0xFF059669) : const Color(0xFFD97706),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.productTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textPrimary)),
                                const SizedBox(height: 2),
                                Text('Buyer: ${order.buyerName} • via ${order.paymentMethod}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isCompleted ? 'RELEASED' : 'IN SAFEPAY',
                              style: TextStyle(
                                color: isCompleted ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '+৳${order.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: Color(0xFF059669),
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
      },
    );
  }

  Widget _buildDynamicActiveOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFDE68A).withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                  order.productImage,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                  ),
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
                        Expanded(
                          child: Text(
                            order.productTitle,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: context.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'IN SAFEPAY VAULT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Paid ৳${order.price.toStringAsFixed(0)} via ${order.paymentMethod} • Seller: ${order.sellerName}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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

          // Handover PIN Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.isDarkMode ? const Color(0xFF78350F).withValues(alpha: 0.25) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.isDarkMode ? const Color(0xFFD97706).withValues(alpha: 0.5) : const Color(0xFFFDE68A)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.key_rounded, size: 18, color: context.isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFB45309)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Handover Verification PIN', style: TextStyle(fontSize: 10, color: context.isDarkMode ? const Color(0xFFFDE68A) : const Color(0xFF92400E), fontWeight: FontWeight.w600)),
                        Text(
                          'PIN: #${order.handoverPin}',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: context.isDarkMode ? const Color(0xFFFDE68A) : const Color(0xFF78350F), letterSpacing: 1.5),
                        ),
                      ],
                    ),
                  ],
                ),
                Text('Tell seller this PIN or confirm below when meeting', style: TextStyle(fontSize: 10, color: context.isDarkMode ? const Color(0xFFFDE68A) : const Color(0xFF92400E))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Actions Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final roomId = await chatService.getOrCreateChatRoom(
                      productId: order.productId,
                      productTitle: order.productTitle,
                      sellerId: order.sellerId,
                      sellerName: order.sellerName,
                    );
                    if (mounted) {
                      DynamicChatDialog.show(
                        context,
                        roomId: roomId,
                        targetUserName: order.sellerName,
                        productTitle: order.productTitle,
                        isSellerMode: true,
                      );
                    }
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Chat with Seller (Schedule Meetup)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    foregroundColor: const Color(0xFF2563EB),
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
                            Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 24),
                            SizedBox(width: 8),
                            Text('Confirm Item Handover'),
                          ],
                        ),
                        content: Text('Did you meet ${order.sellerName} and receive "${order.productTitle}" in good condition? This will release ৳${order.price.toStringAsFixed(0)} to the seller.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Not Yet'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await orderService.completeHandover(order.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🎉 Handover confirmed! ৳${order.price.toStringAsFixed(0)} released to ${order.sellerName}.'),
                                    backgroundColor: const Color(0xFF10B981),
                                  ),
                                );
                              }
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
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _showHelpAndReportDialog(
                itemTitle: order.productTitle,
                sellerName: order.sellerName,
                amount: order.price,
              ),
              icon: const Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFFDC2626)),
              label: const Text('Having an issue? Report to Admin', style: TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCompletedOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              order.productImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(width: 50, height: 50, color: context.containerBg, child: Icon(Icons.inventory_2_outlined, size: 20, color: context.textSecondary)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.productTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textPrimary)),
                const SizedBox(height: 2),
                Text('৳${order.price.toStringAsFixed(0)} • Delivered • Seller: ${order.sellerName}', style: TextStyle(fontSize: 11, color: context.textSecondary)),
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
    );
  }
}
