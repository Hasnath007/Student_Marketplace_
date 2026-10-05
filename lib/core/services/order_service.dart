import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../../models/product.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream active/past orders for current buyer
  Stream<List<OrderModel>> streamBuyerOrders() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('orders')
        .where('buyerId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((d) => OrderModel.fromFirestore(d)).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // Stream sales for current seller (for wallet calculations)
  Stream<List<OrderModel>> streamSellerOrders() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    final currentUserName = (user.displayName ?? user.email?.split('@')[0] ?? '').trim().toLowerCase();

    return _firestore
        .collection('orders')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((d) => OrderModel.fromFirestore(d))
              .where((o) {
                final sellerId = o.sellerId.trim().toLowerCase();
                final sellerName = o.sellerName.trim().toLowerCase();

                final isDirectUidMatch = o.sellerId == user.uid;
                final isNameMatch = currentUserName.isNotEmpty &&
                    (sellerId == currentUserName ||
                        sellerName == currentUserName ||
                        sellerName.contains(currentUserName) ||
                        currentUserName.contains(sellerName));

                return isDirectUidMatch || isNameMatch;
              })
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // Stream ALL orders for Admin Panel (Payments / SafePay Vault)
  Stream<List<OrderModel>> streamAllOrders() {
    return _firestore
        .collection('orders')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((d) => OrderModel.fromFirestore(d)).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // Place a new order
  Future<OrderModel> createOrder({
    required Product product,
    required String paymentMethod,
    required String trxId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final randomPin = (1000 + Random().nextInt(9000)).toString();
    final docRef = _firestore.collection('orders').doc();

    final order = OrderModel(
      id: docRef.id,
      productId: product.id,
      productTitle: product.title,
      productImage: product.imageUrl,
      price: product.price,
      category: product.category,
      buyerId: user.uid,
      buyerName: user.displayName ?? user.email?.split('@')[0] ?? 'Student',
      sellerId: product.sellerId.isNotEmpty ? product.sellerId : 'dummy_seller',
      sellerName: product.sellerName,
      handoverPin: randomPin,
      paymentMethod: paymentMethod,
      trxId: trxId.isNotEmpty ? trxId : 'TRX${100000 + Random().nextInt(900000)}',
      status: 'in_safepay',
      createdAt: DateTime.now(),
    );

    await docRef.set(order.toMap());

    // Mark product as sold in Firestore products collection
    try {
      await _firestore.collection('products').doc(product.id).update({'isSold': true});
    } catch (_) {}

    return order;
  }

  // Place a subscription group order for Admin and tracking
  Future<void> createSubscriptionOrder({
    required String groupId,
    required String groupTitle,
    required double price,
    required String category,
    required String hostName,
    String? hostId,
    required String paymentMethod,
    required String trxId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('orders').doc();
    final order = OrderModel(
      id: docRef.id,
      productId: groupId,
      productTitle: '$groupTitle (Sub Group)',
      productImage: '',
      price: price,
      category: category,
      buyerId: user.uid,
      buyerName: user.displayName ?? user.email?.split('@')[0] ?? 'Student',
      sellerId: (hostId != null && hostId.isNotEmpty) ? hostId : hostName,
      sellerName: hostName,
      handoverPin: '0000',
      paymentMethod: paymentMethod,
      trxId: trxId.isNotEmpty ? trxId : 'TRX${100000 + Random().nextInt(900000)}',
      status: 'in_safepay',
      createdAt: DateTime.now(),
    );

    await docRef.set(order.toMap());
  }

  // Complete handover
  Future<void> completeHandover(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  // Refund order (Admin action)
  Future<void> refundOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'refunded',
      'refundedAt': FieldValue.serverTimestamp(),
    });
  }

  // Report dispute to Admin (saves in Firestore 'reports' collection)
  Future<void> submitDisputeReport({
    required String orderId,
    required String itemName,
    required String reason,
    required String contactNumber,
    required String notes,
  }) async {
    final user = _auth.currentUser;
    final docRef = _firestore.collection('reports').doc();
    await docRef.set({
      'id': docRef.id,
      'orderId': orderId,
      'reportedItem': itemName,
      'reportedBy': user?.displayName ?? user?.email?.split('@')[0] ?? 'Student',
      'reportedById': user?.uid ?? '',
      'reason': reason,
      'contactNumber': contactNumber,
      'notes': notes,
      'type': 'safepay_dispute',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'date': 'Today',
    });
  }

  // Stream all dispute reports for Admin
  Stream<List<Map<String, dynamic>>> streamAllReports() {
    return _firestore
        .collection('reports')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((d) {
            final data = d.data();
            data['id'] = d.id;
            return data;
          }).toList();
          return list;
        });
  }

  // Resolve report in Firestore
  Future<void> resolveReport(String reportId) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': 'resolved',
      'resolvedAt': FieldValue.serverTimestamp(),
    });
  }

  // Dismiss report in Firestore
  Future<void> dismissReport(String reportId) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': 'dismissed',
      'dismissedAt': FieldValue.serverTimestamp(),
    });
  }
}

final orderService = OrderService();
