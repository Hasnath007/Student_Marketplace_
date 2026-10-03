// 🛡️ Admin Panel Riverpod State Providers
// 📌 কাজ: অ্যাডমিন ড্যাশবোর্ডের জন্য ইউজার, অর্ডার/পেমেন্ট ও রিপোর্ট স্টেট রিয়েল-টাইম ফায়ারস্টোর থেকে সংরক্ষণ।
// 🔗 ব্যবহৃত হয়: AdminPanelScreen

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/order_service.dart';

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
    int? totalListings,
    int? totalSales,
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
      totalListings: totalListings ?? this.totalListings,
      totalSales: totalSales ?? this.totalSales,
      avatarUrl: avatarUrl,
    );
  }
}

class AdminUsersNotifier extends Notifier<List<AdminUser>> {
  @override
  List<AdminUser> build() {
    _listenToUsers();
    return [];
  }

  void _listenToUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        DateTime? dt;
        if (data['createdAt'] is Timestamp) {
          dt = (data['createdAt'] as Timestamp).toDate();
        }
        final joinStr = dt != null ? '${_monthName(dt.month)} ${dt.year}' : 'Recent';

        final role = (data['role'] ?? 'student').toString().toLowerCase();
        final status = (data['status'] ?? 'active').toString().toLowerCase();

        return AdminUser(
          id: doc.id,
          name: (data['name'] ?? data['displayName'] ?? 'Student User').toString(),
          email: (data['email'] ?? '').toString(),
          campus: (data['campus'] ?? 'Main Campus').toString(),
          department: (data['department'] ?? 'General').toString(),
          role: role,
          status: status,
          joinDate: joinStr,
          totalListings: (data['totalListings'] is int) ? data['totalListings'] as int : 0,
          totalSales: (data['totalSales'] is int) ? data['totalSales'] as int : 0,
          avatarUrl: (data['photoUrl'] ?? data['avatarUrl'] ?? '').toString(),
        );
      }).toList();
      state = list;
    }, onError: (_) {
      state = [];
    });
  }

  static String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  Future<void> toggleUserStatus(String userId) async {
    final user = state.firstWhere((u) => u.id == userId, orElse: () => state.first);
    final newStatus = user.status == 'active' ? 'suspended' : 'active';
    await FirebaseFirestore.instance.collection('users').doc(userId).update({'status': newStatus});
  }

  Future<void> removeUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  Future<void> approveUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({'status': 'active'});
  }

  Future<void> promoteToAdmin(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({'role': 'admin'});
  }

  Future<void> editUser(String userId, {String? name, String? email, String? campus, String? department, String? role, String? status}) async {
    final Map<String, dynamic> updates = {};
    if (name != null) updates['name'] = name;
    if (email != null) updates['email'] = email;
    if (campus != null) updates['campus'] = campus;
    if (department != null) updates['department'] = department;
    if (role != null) updates['role'] = role;
    if (status != null) updates['status'] = status;
    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update(updates);
    }
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

class AdminTransactionsNotifier extends Notifier<List<AdminTransaction>> {
  @override
  List<AdminTransaction> build() {
    _listenToOrders();
    return [];
  }

  void _listenToOrders() {
    orderService.streamAllOrders().listen((orders) {
      final list = orders.map((ord) {
        String st;
        if (ord.status == 'completed') {
          st = 'released_to_seller';
        } else if (ord.status == 'refunded') {
          st = 'refunded';
        } else {
          st = 'held_in_escrow';
        }

        return AdminTransaction(
          id: ord.id,
          buyerName: ord.buyerName,
          sellerName: ord.sellerName,
          itemName: ord.productTitle,
          amount: ord.price,
          method: ord.paymentMethod,
          trxId: ord.trxId,
          status: st,
          date: '${ord.createdAt.day}/${ord.createdAt.month}/${ord.createdAt.year}',
        );
      }).toList();
      state = list;
    }, onError: (_) {
      state = [];
    });
  }

  Future<void> verifyTransaction(String trxId) async {
    await FirebaseFirestore.instance.collection('orders').doc(trxId).update({'status': 'in_safepay'});
  }

  Future<void> releaseToSeller(String trxId) async {
    await orderService.completeHandover(trxId);
  }

  Future<void> refundToBuyer(String trxId) async {
    await orderService.refundOrder(trxId);
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

class AdminReportsNotifier extends Notifier<List<AdminReport>> {
  @override
  List<AdminReport> build() {
    _listenToReports();
    return [];
  }

  void _listenToReports() {
    orderService.streamAllReports().listen((reports) {
      final list = reports.map((doc) {
        return AdminReport(
          id: doc['id'] ?? '',
          reportedItem: doc['reportedItem'] ?? 'SafePay Order',
          reportedBy: doc['reportedBy'] ?? 'Student',
          reason: '${doc['reason'] ?? ''}${doc['notes'] != null && doc['notes'].toString().isNotEmpty ? ' - ${doc['notes']}' : ''}',
          type: doc['type'] ?? 'product',
          status: doc['status'] ?? 'pending',
          date: doc['date'] ?? 'Today',
        );
      }).toList();
      state = list;
    }, onError: (_) {
      state = [];
    });
  }

  Future<void> addReport(AdminReport report) async {
    await FirebaseFirestore.instance.collection('reports').add({
      'reportedItem': report.reportedItem,
      'reportedBy': report.reportedBy,
      'reason': report.reason,
      'type': report.type,
      'status': report.status,
      'createdAt': FieldValue.serverTimestamp(),
      'date': report.date,
    });
  }

  Future<void> resolveReport(String reportId) async {
    await orderService.resolveReport(reportId);
  }

  Future<void> dismissReport(String reportId) async {
    await orderService.dismissReport(reportId);
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

class AdminMessagesNotifier extends Notifier<List<AdminMessage>> {
  @override
  List<AdminMessage> build() => [];

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
