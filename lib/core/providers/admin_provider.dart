// 🛡️ Admin Panel Riverpod State Providers
// 📌 কাজ: অ্যাডমিন ড্যাশবোর্ডের জন্য ইউজার, প্রোডাক্ট, সাবস্ক্রিপশন, রিপোর্ট ও অ্যানালিটিক্স স্টেট সংরক্ষণ।
// 🔗 ব্যবহৃত হয়: AdminPanelScreen

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────── User Management ───────────────────────────

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String campus;
  final String department;
  final String role; // 'student', 'seller', 'admin'
  final String status; // 'active', 'suspended', 'pending'
  final String joinDate;
  final int totalListings;
  final int totalSales;
  final String avatarUrl;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.campus,
    required this.department,
    required this.role,
    required this.status,
    required this.joinDate,
    required this.totalListings,
    required this.totalSales,
    required this.avatarUrl,
  });

  AdminUser copyWith({
    String? name,
    String? email,
    String? campus,
    String? department,
    String? role,
    String? status,
  }) {
    return AdminUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      campus: campus ?? this.campus,
      department: department ?? this.department,
      role: role ?? this.role,
      status: status ?? this.status,
      joinDate: joinDate,
      totalListings: totalListings,
      totalSales: totalSales,
      avatarUrl: avatarUrl,
    );
  }
}

final sampleAdminUsers = [
  const AdminUser(
    id: 'u1',
    name: 'Alex Rivera',
    email: 'alex.r@stanford.edu',
    campus: 'Main Campus',
    department: 'Computer Science',
    role: 'seller',
    status: 'active',
    joinDate: 'Aug 2022',
    totalListings: 12,
    totalSales: 8,
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
  ),
  const AdminUser(
    id: 'u2',
    name: 'Sarah Jenkins',
    email: 'sarah.j@stanford.edu',
    campus: 'North Campus',
    department: 'Biomedical Engineering',
    role: 'seller',
    status: 'active',
    joinDate: 'Sep 2023',
    totalListings: 5,
    totalSales: 3,
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
  ),
  const AdminUser(
    id: 'u3',
    name: 'Farhan Kabir',
    email: 'farhan.k@stanford.edu',
    campus: 'Engineering Quad',
    department: 'Electrical Engineering',
    role: 'student',
    status: 'active',
    joinDate: 'Jan 2024',
    totalListings: 2,
    totalSales: 1,
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
  ),
  const AdminUser(
    id: 'u4',
    name: 'Ayesha Chowdhury',
    email: 'ayesha.c@stanford.edu',
    campus: 'West Campus',
    department: 'Business Administration',
    role: 'seller',
    status: 'suspended',
    joinDate: 'Mar 2023',
    totalListings: 8,
    totalSales: 6,
    avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=150&q=80',
  ),
  const AdminUser(
    id: 'u5',
    name: 'David Kim',
    email: 'david.k@stanford.edu',
    campus: 'East Dorms',
    department: 'Physics',
    role: 'student',
    status: 'pending',
    joinDate: 'Sep 2024',
    totalListings: 0,
    totalSales: 0,
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
  ),
  const AdminUser(
    id: 'u6',
    name: 'Sadia Islam',
    email: 'sadia.i@stanford.edu',
    campus: 'Main Campus',
    department: 'English Literature',
    role: 'student',
    status: 'active',
    joinDate: 'Jun 2024',
    totalListings: 3,
    totalSales: 2,
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
  ),
];

class AdminUsersNotifier extends Notifier<List<AdminUser>> {
  @override
  List<AdminUser> build() => sampleAdminUsers;

  void toggleUserStatus(String userId) {
    state = state.map((u) {
      if (u.id == userId) {
        return u.copyWith(status: u.status == 'active' ? 'suspended' : 'active');
      }
      return u;
    }).toList();
  }

  void removeUser(String userId) {
    state = state.where((u) => u.id != userId).toList();
  }

  void approveUser(String userId) {
    state = state.map((u) {
      if (u.id == userId) {
        return u.copyWith(status: 'active');
      }
      return u;
    }).toList();
  }

  void promoteToAdmin(String userId) {
    state = state.map((u) {
      if (u.id == userId) {
        return u.copyWith(role: 'admin');
      }
      return u;
    }).toList();
  }

  void editUser(String userId, {String? name, String? email, String? campus, String? department, String? role, String? status}) {
    state = state.map((u) {
      if (u.id == userId) {
        return u.copyWith(
          name: name,
          email: email,
          campus: campus,
          department: department,
          role: role,
          status: status,
        );
      }
      return u;
    }).toList();
  }
}

final adminUsersProvider = NotifierProvider<AdminUsersNotifier, List<AdminUser>>(AdminUsersNotifier.new);

// ─────────────────────────── Transactions / Escrow ───────────────────────────

class AdminTransaction {
  final String id;
  final String buyerName;
  final String sellerName;
  final String itemName;
  final double amount;
  final String method; // 'bKash', 'Nagad'
  final String trxId;
  final String status; // 'pending_verification', 'held_in_escrow', 'released_to_seller', 'refunded'
  final String date;

  const AdminTransaction({
    required this.id,
    required this.buyerName,
    required this.sellerName,
    required this.itemName,
    required this.amount,
    required this.method,
    required this.trxId,
    required this.status,
    required this.date,
  });

  AdminTransaction copyWith({String? status}) {
    return AdminTransaction(
      id: id,
      buyerName: buyerName,
      sellerName: sellerName,
      itemName: itemName,
      amount: amount,
      method: method,
      trxId: trxId,
      status: status ?? this.status,
      date: date,
    );
  }
}

final sampleTransactions = [
  const AdminTransaction(
    id: 'trx1',
    buyerName: 'David Kim',
    sellerName: 'Sarah Jenkins',
    itemName: 'Organic Chemistry 10th Ed',
    amount: 850.0,
    method: 'bKash',
    trxId: '8J7K2LX9',
    status: 'pending_verification',
    date: 'Today, 2:30 PM',
  ),
  const AdminTransaction(
    id: 'trx2',
    buyerName: 'Farhan Kabir',
    sellerName: 'Alex Rivera',
    itemName: 'Engineering Calculator',
    amount: 1500.0,
    method: 'Nagad',
    trxId: 'NGD592L',
    status: 'held_in_escrow',
    date: 'Yesterday, 5:15 PM',
  ),
  const AdminTransaction(
    id: 'trx3',
    buyerName: 'Sadia Islam',
    sellerName: 'Ayesha Chowdhury',
    itemName: 'Digital Notes Set',
    amount: 300.0,
    method: 'bKash',
    trxId: 'BKS9092',
    status: 'released_to_seller',
    date: '28 Sep 2026',
  ),
];

class AdminTransactionsNotifier extends Notifier<List<AdminTransaction>> {
  @override
  List<AdminTransaction> build() => sampleTransactions;

  void verifyTransaction(String trxId) {
    state = state.map((t) {
      if (t.id == trxId) return t.copyWith(status: 'held_in_escrow');
      return t;
    }).toList();
  }

  void releaseToSeller(String trxId) {
    state = state.map((t) {
      if (t.id == trxId) return t.copyWith(status: 'released_to_seller');
      return t;
    }).toList();
  }

  void refundToBuyer(String trxId) {
    state = state.map((t) {
      if (t.id == trxId) return t.copyWith(status: 'refunded');
      return t;
    }).toList();
  }
}

final adminTransactionsProvider = NotifierProvider<AdminTransactionsNotifier, List<AdminTransaction>>(AdminTransactionsNotifier.new);

// ─────────────────────────── Reported Content ───────────────────────────

class AdminReport {
  final String id;
  final String reportedItem;
  final String reportedBy;
  final String reason;
  final String type; // 'product', 'user', 'subscription'
  final String status; // 'pending', 'resolved', 'dismissed'
  final String date;

  const AdminReport({
    required this.id,
    required this.reportedItem,
    required this.reportedBy,
    required this.reason,
    required this.type,
    required this.status,
    required this.date,
  });

  AdminReport copyWith({String? status}) {
    return AdminReport(
      id: id,
      reportedItem: reportedItem,
      reportedBy: reportedBy,
      reason: reason,
      type: type,
      status: status ?? this.status,
      date: date,
    );
  }
}

final sampleReports = [
  const AdminReport(
    id: 'r1',
    reportedItem: 'TI-84 Plus CE Calculator',
    reportedBy: 'Michael R.',
    reason: 'Suspicious pricing — listed far below market value, possible scam.',
    type: 'product',
    status: 'pending',
    date: 'Today, 3:15 PM',
  ),
  const AdminReport(
    id: 'r2',
    reportedItem: 'Ayesha Chowdhury',
    reportedBy: 'Sarah J.',
    reason: 'Selling counterfeit electronics. Multiple buyers reported.',
    type: 'user',
    status: 'pending',
    date: 'Yesterday',
  ),
  const AdminReport(
    id: 'r3',
    reportedItem: 'Netflix Premium 4K Group',
    reportedBy: 'Farhan K.',
    reason: 'Account credentials changed without notice after payment.',
    type: 'subscription',
    status: 'resolved',
    date: '28 Sep 2026',
  ),
  const AdminReport(
    id: 'r4',
    reportedItem: 'Resume Design Review Service',
    reportedBy: 'David K.',
    reason: 'Service was never delivered after payment confirmation.',
    type: 'product',
    status: 'dismissed',
    date: '25 Sep 2026',
  ),
];

class AdminReportsNotifier extends Notifier<List<AdminReport>> {
  @override
  List<AdminReport> build() => sampleReports;

  void addReport(AdminReport report) {
    state = [report, ...state];
  }

  void resolveReport(String reportId) {
    state = state.map((r) {
      if (r.id == reportId) return r.copyWith(status: 'resolved');
      return r;
    }).toList();
  }

  void dismissReport(String reportId) {
    state = state.map((r) {
      if (r.id == reportId) return r.copyWith(status: 'dismissed');
      return r;
    }).toList();
  }
}

final adminReportsProvider = NotifierProvider<AdminReportsNotifier, List<AdminReport>>(AdminReportsNotifier.new);

// ─────────────────────────── Admin Messages / Chat ───────────────────────────

class AdminMessage {
  final String id;
  final String sender; // 'Admin', 'User Name'
  final String receiver; // 'User Name', 'Admin'
  final String content;
  final String time;
  final bool isFromAdmin;

  const AdminMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.time,
    required this.isFromAdmin,
  });
}

final sampleMessages = [
  const AdminMessage(id: 'm1', sender: 'David Kim', receiver: 'Admin', content: 'Hi, I paid for the Organic Chemistry book but the seller hasn\'t responded.', time: '10:00 AM', isFromAdmin: false),
  const AdminMessage(id: 'm2', sender: 'Admin', receiver: 'David Kim', content: 'Hello David, I have verified your payment and it is held in escrow. I will contact the seller right away.', time: '10:05 AM', isFromAdmin: true),
  const AdminMessage(id: 'm3', sender: 'Admin', receiver: 'Sarah Jenkins', content: 'Hi Sarah, a buyer has paid for your Organic Chemistry book. Please coordinate the meetup.', time: '10:06 AM', isFromAdmin: true),
];

class AdminMessagesNotifier extends Notifier<List<AdminMessage>> {
  @override
  List<AdminMessage> build() => sampleMessages;

  void sendMessage(String receiver, String content) {
    final newMessage = AdminMessage(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'Admin',
      receiver: receiver,
      content: content,
      time: 'Just now',
      isFromAdmin: true,
    );
    state = [...state, newMessage];
  }
}

final adminMessagesProvider = NotifierProvider<AdminMessagesNotifier, List<AdminMessage>>(AdminMessagesNotifier.new);


// ─────────────────────────── Admin Panel Tab ───────────────────────────

class AdminTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int tab) => state = tab;
}

final adminTabProvider = NotifierProvider<AdminTabNotifier, int>(AdminTabNotifier.new);
