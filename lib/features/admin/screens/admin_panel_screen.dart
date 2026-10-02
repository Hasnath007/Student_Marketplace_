// 🛡️ Admin Panel Screen (অ্যাডমিন ড্যাশবোর্ড ও ম্যানেজমেন্ট প্যানেল)
// 📌 কাজ: প্ল্যাটফর্মের সকল ইউজার, প্রোডাক্ট, সাবস্ক্রিপশন গ্রুপ, রিপোর্ট ও অ্যানালিটিক্স পরিচালনা।
// 🔗 স্টেট: adminUsersProvider, adminReportsProvider, adminTabProvider, marketplaceProvider, subscriptionsProvider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/admin_provider.dart';
import '../../../core/providers/marketplace_provider.dart';
import '../../../core/providers/subscriptions_provider.dart';
import '../../../models/product.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  int _selectedTab = 0;
  String _userSearchQuery = '';
  String _userFilterStatus = 'All';
  String _reportFilterStatus = 'All';
  String _transactionFilterStatus = 'All';
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(adminUsersProvider);
    final reports = ref.watch(adminReportsProvider);
    final products = ref.watch(marketplaceProvider);
    final subscriptions = ref.watch(subscriptionsProvider);
    final transactions = ref.watch(adminTransactionsProvider);
    final messages = ref.watch(adminMessagesProvider);

    // Summary stats
    final totalUsers = users.length;
    final activeUsers = users.where((u) => u.status == 'active').length;
    final suspendedUsers = users.where((u) => u.status == 'suspended').length;
    final totalProducts = products.length;
    final totalSubscriptions = subscriptions.length;
    final pendingReports = reports.where((r) => r.status == 'pending').length;
    final pendingTransactions = transactions.where((t) => t.status == 'pending_verification').length;

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
                // ── Page Header ──────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF2563EB), size: 24),
                            ),
                            const SizedBox(width: 14),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Admin Dashboard',
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.8),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Manage users, listings, subscriptions, and platform analytics.',
                                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Live Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: Color(0xFF059669)),
                          SizedBox(width: 8),
                          Text(
                            'Platform Online',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF047857)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Summary Stats Cards ──────────────────────────────
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildStatCard(
                          icon: Icons.people_alt_rounded,
                          iconBg: const Color(0xFFDBEAFE),
                          iconColor: const Color(0xFF2563EB),
                          label: 'Total Users',
                          value: '$totalUsers',
                          subtitle: '$activeUsers active  •  $suspendedUsers suspended',
                          width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                        ),
                        _buildStatCard(
                          icon: Icons.storefront_rounded,
                          iconBg: const Color(0xFFD1FAE5),
                          iconColor: const Color(0xFF059669),
                          label: 'Active Listings',
                          value: '$totalProducts',
                          subtitle: 'Across all categories',
                          width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                        ),
                        _buildStatCard(
                          icon: Icons.groups_rounded,
                          iconBg: const Color(0xFFFDE68A),
                          iconColor: const Color(0xFFD97706),
                          label: 'Sub Groups',
                          value: '$totalSubscriptions',
                          subtitle: 'Active sharing groups',
                          width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                        ),
                        _buildStatCard(
                          icon: Icons.flag_rounded,
                          iconBg: pendingReports > 0 ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
                          iconColor: pendingReports > 0 ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                          label: 'Pending Reports',
                          value: '$pendingReports',
                          subtitle: '${reports.length} total reports',
                          width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // ── Tab Navigation ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTab(0, Icons.people_alt_rounded, 'Users', totalUsers),
                      _buildTab(1, Icons.storefront_rounded, 'Listings', totalProducts),
                      _buildTab(2, Icons.groups_rounded, 'Subscriptions', totalSubscriptions),
                      _buildTab(3, Icons.flag_rounded, 'Reports', pendingReports),
                      _buildTab(4, Icons.payments_rounded, 'Escrow', pendingTransactions),
                      _buildTab(5, Icons.chat_bubble_rounded, 'Messages', null),
                      _buildTab(6, Icons.analytics_rounded, 'Analytics', null),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Tab Content ──────────────────────────────────────
                if (_selectedTab == 0) _buildUsersTab(users),
                if (_selectedTab == 1) _buildListingsTab(products),
                if (_selectedTab == 2) _buildSubscriptionsTab(subscriptions),
                if (_selectedTab == 3) _buildReportsTab(reports),
                if (_selectedTab == 4) _buildTransactionsTab(transactions),
                if (_selectedTab == 5) _buildMessagesTab(messages),
                if (_selectedTab == 6) _buildAnalyticsTab(users, products, reports, transactions),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Stat Card Widget
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    required String subtitle,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Tab Button Widget
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildTab(int index, IconData icon, String label, int? count) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 0: Users Management
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildUsersTab(List<AdminUser> users) {
    final statusFilters = ['All', 'Active', 'Suspended', 'Pending'];

    final filtered = users.where((u) {
      final matchesSearch = _userSearchQuery.isEmpty ||
          u.name.toLowerCase().contains(_userSearchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_userSearchQuery.toLowerCase()) ||
          u.department.toLowerCase().contains(_userSearchQuery.toLowerCase());
      final matchesStatus = _userFilterStatus == 'All' || u.status.toLowerCase() == _userFilterStatus.toLowerCase();
      return matchesSearch && matchesStatus;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search + Filter Row
        Row(
          children: [
            // Search
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 42,
                child: TextField(
                  onChanged: (val) => setState(() => _userSearchQuery = val),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search users by name, email, or department...',
                    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Status filter chips
            ...statusFilters.map((status) {
              final isSel = _userFilterStatus == status;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(status),
                  selected: isSel,
                  onSelected: (s) {
                    if (s) setState(() => _userFilterStatus = status);
                  },
                  selectedColor: const Color(0xFF2563EB),
                  backgroundColor: const Color(0xFFEEF2FF),
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Showing ${filtered.length} of ${users.length} users',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 16),

        // Users Table
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 3, child: Text('User', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 2, child: Text('Department', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 1, child: Text('Role', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 1, child: Text('Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 1, child: Text('Listings', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    SizedBox(width: 120, child: Text('Actions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                  ],
                ),
              ),
              // Table Rows
              ...filtered.map((user) => _buildUserRow(user)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserRow(AdminUser user) {
    Color statusColor;
    Color statusBg;
    switch (user.status) {
      case 'active':
        statusColor = const Color(0xFF047857);
        statusBg = const Color(0xFFD1FAE5);
        break;
      case 'suspended':
        statusColor = const Color(0xFFDC2626);
        statusBg = const Color(0xFFFEE2E2);
        break;
      case 'pending':
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFEF3C7);
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusBg = const Color(0xFFF1F5F9);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          // User Info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                      Text(user.email, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Department
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.department, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                Text(user.campus, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          // Role
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: user.role == 'admin' ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                user.role[0].toUpperCase() + user.role.substring(1),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: user.role == 'admin' ? const Color(0xFF2563EB) : const Color(0xFF475569),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Status
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                user.status[0].toUpperCase() + user.status.substring(1),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Listings
          Expanded(
            flex: 1,
            child: Text(
              '${user.totalListings} items',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
            ),
          ),
          // Actions
          SizedBox(
            width: 120,
            child: Row(
              children: [
                _buildActionButton(
                  Icons.edit_rounded,
                  const Color(0xFF2563EB),
                  'Edit User',
                  () => _showEditUserDialog(user),
                ),
                const SizedBox(width: 4),
                if (user.status == 'pending')
                  _buildActionButton(
                    Icons.check_circle_outline_rounded,
                    const Color(0xFF059669),
                    'Approve',
                    () {
                      ref.read(adminUsersProvider.notifier).approveUser(user.id);
                      _showSnack('${user.name} approved successfully!', const Color(0xFF059669));
                    },
                  )
                else
                  _buildActionButton(
                    user.status == 'active' ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                    user.status == 'active' ? const Color(0xFFF59E0B) : const Color(0xFF059669),
                    user.status == 'active' ? 'Suspend' : 'Activate',
                    () {
                      ref.read(adminUsersProvider.notifier).toggleUserStatus(user.id);
                      _showSnack(
                        user.status == 'active' ? '${user.name} suspended.' : '${user.name} re-activated.',
                        user.status == 'active' ? const Color(0xFFF59E0B) : const Color(0xFF059669),
                      );
                    },
                  ),
                const SizedBox(width: 4),
                _buildActionButton(
                  Icons.delete_outline_rounded,
                  const Color(0xFFDC2626),
                  'Remove',
                  () => _showDeleteConfirm(user),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  void _showDeleteConfirm(AdminUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Confirm Remove User', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently remove "${user.name}" from the platform? This action cannot be undone.',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(adminUsersProvider.notifier).removeUser(user.id);
              Navigator.pop(ctx);
              _showSnack('${user.name} removed from platform.', const Color(0xFFDC2626));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Remove User', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(AdminUser user) {
    final nameCtrl = TextEditingController(text: user.name);
    final roleCtrl = TextEditingController(text: user.role);
    final statusCtrl = TextEditingController(text: user.status);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Role (student/seller/admin)')),
            TextField(controller: statusCtrl, decoration: const InputDecoration(labelText: 'Status (active/suspended/pending)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(adminUsersProvider.notifier).editUser(
                user.id,
                name: nameCtrl.text.trim(),
                role: roleCtrl.text.trim(),
                status: statusCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              _showSnack('User updated successfully!', const Color(0xFF059669));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 1: Listings Overview
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildListingsTab(List products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Breakdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('All Product Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${products.length} Total',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Category Distribution Cards
        _buildCategoryCards(products),
        const SizedBox(height: 24),

        // Product Table
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 4, child: Text('PRODUCT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 2, child: Text('CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 1, child: Text('PRICE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 2, child: Text('SELLER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    Expanded(flex: 1, child: Text('CONDITION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                    SizedBox(width: 80, child: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5))),
                  ],
                ),
              ),
              ...products.map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              p.imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.image, size: 18, color: Color(0xFF94A3B8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              p.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.category,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '৳${p.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: const Color(0xFFDBEAFE),
                            child: Text(p.sellerName[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                          ),
                          const SizedBox(width: 8),
                          Text(p.sellerName, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(p.condition, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    ),
                    SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          _buildActionButton(
                            Icons.edit_rounded,
                            const Color(0xFF2563EB),
                            'Edit',
                            () => _showEditProductDialog(p),
                          ),
                          const SizedBox(width: 4),
                          _buildActionButton(
                            Icons.delete_outline_rounded,
                            const Color(0xFFDC2626),
                            'Remove',
                            () => _showDeleteProductConfirm(p),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteProductConfirm(Product p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Remove Listing'),
        content: Text('Are you sure you want to remove "${p.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(marketplaceProvider.notifier).deleteProduct(p.id);
              Navigator.pop(ctx);
              _showSnack('Listing removed.', const Color(0xFFDC2626));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(Product p) {
    final titleCtrl = TextEditingController(text: p.title);
    final priceCtrl = TextEditingController(text: p.price.toString());
    final categoryCtrl = TextEditingController(text: p.category);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Listing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(marketplaceProvider.notifier).editProduct(
                p.id,
                title: titleCtrl.text.trim(),
                price: double.tryParse(priceCtrl.text) ?? p.price,
                category: categoryCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              _showSnack('Listing updated successfully!', const Color(0xFF059669));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCards(List products) {
    final categories = <String, int>{};
    for (final p in products) {
      categories[p.category] = (categories[p.category] ?? 0) + 1;
    }

    final categoryIcons = <String, IconData>{
      'Books': Icons.menu_book_rounded,
      'Electronics': Icons.laptop_chromebook_rounded,
      'Stationery': Icons.draw_rounded,
      'Notes': Icons.description_rounded,
      'Digital Services': Icons.design_services_rounded,
    };

    final categoryColors = <String, Color>{
      'Books': const Color(0xFF2563EB),
      'Electronics': const Color(0xFF059669),
      'Stationery': const Color(0xFFD97706),
      'Notes': const Color(0xFF7C3AED),
      'Digital Services': const Color(0xFFDC2626),
    };

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.entries.map((e) {
        final color = categoryColors[e.key] ?? const Color(0xFF2563EB);
        return Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(categoryIcons[e.key] ?? Icons.category, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  Text('${e.value} items', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 2: Subscriptions Overview
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildSubscriptionsTab(List subscriptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subscription Groups', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE68A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${subscriptions.length} Active Groups',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Sub Group Cards
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth < 700) crossAxisCount = 1;
            if (constraints.maxWidth > 1100) crossAxisCount = 3;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 2.4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final sub = subscriptions[index];
                final fillRate = sub.currentMembers / sub.maxMembers;
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sub.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              sub.category,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person_outline_rounded, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text('Admin: ${sub.adminName}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          const Spacer(),
                          Text(
                            '\$${sub.monthlyPricePerMember.toStringAsFixed(2)}/mo',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${sub.currentMembers}/${sub.maxMembers} members',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                              ),
                              Text(
                                '${(fillRate * 100).toStringAsFixed(0)}% filled',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: fillRate >= 1.0 ? const Color(0xFFDC2626) : const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: fillRate,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: AlwaysStoppedAnimation(
                                fillRate >= 1.0 ? const Color(0xFFDC2626) : const Color(0xFF2563EB),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 3: Reports
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildReportsTab(List<AdminReport> reports) {
    final statusFilters = ['All', 'Pending', 'Resolved', 'Dismissed'];

    final filtered = reports.where((r) {
      return _reportFilterStatus == 'All' || r.status.toLowerCase() == _reportFilterStatus.toLowerCase();
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Content Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            const Spacer(),
            ...statusFilters.map((status) {
              final isSel = _reportFilterStatus == status;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(status),
                  selected: isSel,
                  onSelected: (s) {
                    if (s) setState(() => _reportFilterStatus = status);
                  },
                  selectedColor: const Color(0xFF2563EB),
                  backgroundColor: const Color(0xFFEEF2FF),
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 20),

        ...filtered.map((report) => _buildReportCard(report)),

        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF94A3B8)),
                SizedBox(height: 12),
                Text('No reports in this category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                SizedBox(height: 4),
                Text('All clear! No pending reports found.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReportCard(AdminReport report) {
    IconData typeIcon;
    Color typeBg;
    Color typeColor;

    switch (report.type) {
      case 'product':
        typeIcon = Icons.storefront_rounded;
        typeBg = const Color(0xFFDBEAFE);
        typeColor = const Color(0xFF2563EB);
        break;
      case 'user':
        typeIcon = Icons.person_rounded;
        typeBg = const Color(0xFFFEE2E2);
        typeColor = const Color(0xFFDC2626);
        break;
      case 'subscription':
        typeIcon = Icons.groups_rounded;
        typeBg = const Color(0xFFFDE68A);
        typeColor = const Color(0xFFD97706);
        break;
      default:
        typeIcon = Icons.flag_rounded;
        typeBg = const Color(0xFFF1F5F9);
        typeColor = const Color(0xFF64748B);
    }

    Color statusColor;
    Color statusBg;
    switch (report.status) {
      case 'pending':
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFEF3C7);
        break;
      case 'resolved':
        statusColor = const Color(0xFF047857);
        statusBg = const Color(0xFFD1FAE5);
        break;
      case 'dismissed':
        statusColor = const Color(0xFF64748B);
        statusBg = const Color(0xFFF1F5F9);
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusBg = const Color(0xFFF1F5F9);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: report.status == 'pending' ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: typeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(typeIcon, color: typeColor, size: 20),
          ),
          const SizedBox(width: 16),

          // Report Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.reportedItem,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        report.status[0].toUpperCase() + report.status.substring(1),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(report.reason, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded, size: 13, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text('Reported by: ${report.reportedBy}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(report.date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Action Buttons
          if (report.status == 'pending')
            Column(
              children: [
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(adminReportsProvider.notifier).resolveReport(report.id);
                      _showSnack('Report "${report.reportedItem}" resolved.', const Color(0xFF059669));
                    },
                    icon: const Icon(Icons.check_rounded, size: 14),
                    label: const Text('Resolve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(adminReportsProvider.notifier).dismissReport(report.id);
                      _showSnack('Report dismissed.', const Color(0xFF64748B));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Dismiss', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 4: Escrow Transactions
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildTransactionsTab(List<AdminTransaction> transactions) {
    final statusFilters = ['All', 'Pending_Verification', 'Held_In_Escrow', 'Released_To_Seller', 'Refunded'];

    final filtered = transactions.where((t) {
      return _transactionFilterStatus == 'All' || t.status.toLowerCase() == _transactionFilterStatus.toLowerCase();
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Escrow Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            const Spacer(),
            ...statusFilters.map((status) {
              final isSel = _transactionFilterStatus == status;
              final label = status.replaceAll('_', ' ');
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(label),
                  selected: isSel,
                  onSelected: (s) {
                    if (s) setState(() => _transactionFilterStatus = status);
                  },
                  selectedColor: const Color(0xFF2563EB),
                  backgroundColor: const Color(0xFFEEF2FF),
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 20),

        ...filtered.map((trx) => _buildTransactionCard(trx)),

        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                Icon(Icons.receipt_long_rounded, size: 48, color: Color(0xFF94A3B8)),
                SizedBox(height: 12),
                Text('No transactions found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionCard(AdminTransaction trx) {
    Color statusColor;
    Color statusBg;
    String statusLabel = trx.status.replaceAll('_', ' ').toUpperCase();

    switch (trx.status) {
      case 'pending_verification':
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFEF3C7);
        break;
      case 'held_in_escrow':
        statusColor = const Color(0xFF047857);
        statusBg = const Color(0xFFD1FAE5);
        break;
      case 'released_to_seller':
        statusColor = const Color(0xFF2563EB);
        statusBg = const Color(0xFFDBEAFE);
        break;
      case 'refunded':
        statusColor = const Color(0xFFDC2626);
        statusBg = const Color(0xFFFEE2E2);
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusBg = const Color(0xFFF1F5F9);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: trx.status == 'pending_verification' ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.payments_rounded, color: Color(0xFF2563EB), size: 20),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${trx.itemName} - ৳${trx.amount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        statusLabel,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Buyer: ${trx.buyerName}  •  Seller: ${trx.sellerName}', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                const SizedBox(height: 4),
                Text('Method: ${trx.method}  •  TrxID: ${trx.trxId}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 8),
                Text(trx.date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Action Buttons
          if (trx.status == 'pending_verification')
            SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(adminTransactionsProvider.notifier).verifyTransaction(trx.id);
                  _showSnack('Payment verified and held in escrow.', const Color(0xFF059669));
                },
                icon: const Icon(Icons.check_circle_rounded, size: 14),
                label: const Text('Verify Payment', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          if (trx.status == 'held_in_escrow')
            Column(
              children: [
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(adminTransactionsProvider.notifier).releaseToSeller(trx.id);
                      _showSnack('Funds released to seller via bKash/Nagad.', const Color(0xFF2563EB));
                    },
                    icon: const Icon(Icons.send_rounded, size: 14),
                    label: const Text('Release to Seller', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(adminTransactionsProvider.notifier).refundToBuyer(trx.id);
                      _showSnack('Funds refunded to buyer.', const Color(0xFFDC2626));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Refund Buyer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 5: Messages (Admin Chat)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildMessagesTab(List<AdminMessage> messages) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: const Row(
              children: [
                Icon(Icons.support_agent_rounded, color: Color(0xFF2563EB)),
                SizedBox(width: 12),
                Text('Admin Support Chat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: msg.isFromAdmin ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!msg.isFromAdmin)
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFE2E8F0),
                          child: Text(msg.sender[0], style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                        ),
                      if (!msg.isFromAdmin) const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: msg.isFromAdmin ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16).copyWith(
                              bottomRight: msg.isFromAdmin ? const Radius.circular(4) : const Radius.circular(16),
                              bottomLeft: !msg.isFromAdmin ? const Radius.circular(4) : const Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: msg.isFromAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.isFromAdmin ? 'To: ${msg.receiver}' : msg.sender,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: msg.isFromAdmin ? Colors.blue.shade100 : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg.content,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: msg.isFromAdmin ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (msg.isFromAdmin) const SizedBox(width: 8),
                      if (msg.isFromAdmin)
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFDBEAFE),
                          child: Icon(Icons.shield_rounded, size: 14, color: Color(0xFF2563EB)),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        ref.read(adminMessagesProvider.notifier).sendMessage('All Users', val);
                        _messageController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    final val = _messageController.text.trim();
                    if (val.isNotEmpty) {
                      ref.read(adminMessagesProvider.notifier).sendMessage('All Users', val);
                      _messageController.clear();
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TAB 6: Analytics
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildAnalyticsTab(List<AdminUser> users, List products, List<AdminReport> reports, List<AdminTransaction> transactions) {
    final activeUsers = users.where((u) => u.status == 'active').length;

    // Revenue simulation
    double totalRevenue = 0;
    for (final p in products) {
      totalRevenue += p.price;
    }

    // Escrow simulation
    double escrowBalance = 0;
    for (final t in transactions) {
      if (t.status == 'held_in_escrow' || t.status == 'pending_verification') {
        escrowBalance += t.amount;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Platform Analytics Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5)),
                const SizedBox(height: 6),
                Text(
                  'Comprehensive insights into marketplace performance, user growth, and escrow funds.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.download_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Download Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // ── HERO METRICS ROW ──
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildPremiumMetricCard(
                  title: 'Total Revenue (Est.)',
                  value: '৳${totalRevenue.toStringAsFixed(0)}',
                  change: '+15.2%',
                  isPositive: true,
                  icon: Icons.auto_graph_rounded,
                  colors: [const Color(0xFF10B981), const Color(0xFF059669)],
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                ),
                _buildPremiumMetricCard(
                  title: 'Escrow Balance',
                  value: '৳${escrowBalance.toStringAsFixed(0)}',
                  change: 'Pending & Held',
                  isPositive: true,
                  icon: Icons.account_balance_rounded,
                  colors: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                ),
                _buildPremiumMetricCard(
                  title: 'Total Users',
                  value: '${users.length}',
                  change: '+12 this month',
                  isPositive: true,
                  icon: Icons.rocket_launch_rounded,
                  colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                ),
                _buildPremiumMetricCard(
                  title: 'Active User Rate',
                  value: '${((activeUsers / (users.isEmpty ? 1 : users.length)) * 100).toStringAsFixed(0)}%',
                  change: 'Healthy engagement',
                  isPositive: true,
                  icon: Icons.local_fire_department_rounded,
                  colors: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // ── SECOND ROW: CHARTS & TOP DEPARTMENTS ──
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: isWide ? 2 : 1,
                  child: _buildRevenueBreakdownCard(),
                ),
                if (isWide) const SizedBox(width: 16),
                if (isWide)
                  Expanded(
                    flex: 1,
                    child: _buildTopDepartmentsCard(users),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // ── THIRD ROW: RECENT ACTIVITY ──
        _buildActivityFeed(),
      ],
    );
  }

  Widget _buildPremiumMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required List<Color> colors,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, colors[0].withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors[0].withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 3)),
                  ],
                ),
                child: Icon(icon, size: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -1)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 16,
                color: isPositive ? const Color(0xFF059669) : const Color(0xFFDC2626),
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? const Color(0xFF059669) : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE2E8F0).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revenue by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
              Text('Last 30 Days', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 24),
          _buildRevenueBar('Books', 0.35, const Color(0xFF2563EB), '৳950'),
          const SizedBox(height: 16),
          _buildRevenueBar('Electronics', 0.55, const Color(0xFF059669), '৳1,500'),
          const SizedBox(height: 16),
          _buildRevenueBar('Stationery', 0.15, const Color(0xFFD97706), '৳250'),
          const SizedBox(height: 16),
          _buildRevenueBar('Notes', 0.25, const Color(0xFF7C3AED), '৳330'),
          const SizedBox(height: 16),
          _buildRevenueBar('Digital Services', 0.10, const Color(0xFFDC2626), '৳300'),
        ],
      ),
    );
  }

  Widget _buildTopDepartmentsCard(List<AdminUser> users) {
    // Count users by department
    final Map<String, int> deptCounts = {};
    for (var u in users) {
      deptCounts[u.department] = (deptCounts[u.department] ?? 0) + 1;
    }
    final sortedDepts = deptCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE2E8F0).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Departments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
              Icon(Icons.school_rounded, color: Color(0xFF94A3B8), size: 18),
            ],
          ),
          const SizedBox(height: 24),
          ...sortedDepts.take(5).map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        entry.key.isNotEmpty ? entry.key[0] : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                    ),
                  ),
                  Text(
                    '${entry.value} users',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRevenueBar(String label, double progress, Color color, String amount) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 12,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 60,
          child: Text(amount, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
        ),
      ],
    );
  }

  Widget _buildActivityFeed() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFE2E8F0).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Platform Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
          const SizedBox(height: 20),
          _buildActivityItem(Icons.person_add_rounded, const Color(0xFF2563EB), 'David Kim', 'registered a new account', '5 min ago'),
          _buildActivityItem(Icons.storefront_rounded, const Color(0xFF059669), 'Sarah J.', 'listed "Organic Chemistry 10th Ed"', '12 min ago'),
          _buildActivityItem(Icons.groups_rounded, const Color(0xFFD97706), 'Farhan K.', 'joined Netflix Premium 4K group', '28 min ago'),
          _buildActivityItem(Icons.flag_rounded, const Color(0xFFDC2626), 'Michael R.', 'reported suspicious product listing', '1 hour ago'),
          _buildActivityItem(Icons.payments_rounded, const Color(0xFF7C3AED), 'Alex Rivera', 'withdrew ৳1,500 via bKash', '2 hours ago'),
          _buildActivityItem(Icons.check_circle_rounded, const Color(0xFF059669), 'Admin', 'resolved report on Netflix group', 'Yesterday'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, Color color, String user, String action, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Color(0xFF475569), fontFamily: 'Roboto'),
                children: [
                  TextSpan(text: user, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                  TextSpan(text: ' $action'),
                ],
              ),
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
