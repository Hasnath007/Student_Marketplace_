import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String productId;
  final String productTitle;
  final String productImage;
  final double price;
  final String category;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final String handoverPin;
  final String paymentMethod;
  final String trxId;
  final String status; // 'in_safepay', 'completed', 'disputed'
  final DateTime createdAt;
  final DateTime? completedAt;

  const OrderModel({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.price,
    required this.category,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
    required this.handoverPin,
    required this.paymentMethod,
    required this.trxId,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'price': price,
      'category': category,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'handoverPin': handoverPin,
      'paymentMethod': paymentMethod,
      'trxId': trxId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return OrderModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      productTitle: data['productTitle'] ?? 'Product',
      productImage: data['productImage'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] ?? 'General',
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ?? 'Student',
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? 'Seller',
      handoverPin: data['handoverPin'] ?? '1234',
      paymentMethod: data['paymentMethod'] ?? 'bKash',
      trxId: data['trxId'] ?? '',
      status: data['status'] ?? 'in_safepay',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }
}
