import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create or get an existing chat room
  Future<String> getOrCreateChatRoom({
    required String productId,
    required String productTitle,
    required String sellerId,
    required String sellerName,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final buyerId = currentUser.uid;
    if (buyerId == sellerId) return ''; // Can't chat with self

    // Unique room ID based on product and buyer
    final roomId = 'prod_${productId}_buyer_$buyerId';

    final docRef = _firestore.collection('chats').doc(roomId);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      await docRef.set({
        'roomId': roomId,
        'productId': productId,
        'productTitle': productTitle,
        'sellerId': sellerId,
        'buyerId': buyerId,
        'sellerName': sellerName,
        'buyerName': currentUser.displayName ?? currentUser.email?.split('@')[0] ?? 'Student',
        'participants': [sellerId, buyerId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return roomId;
  }

  // Send a message
  Future<void> sendMessage(String roomId, String text) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || roomId.trim().isEmpty) return;

    final msgData = {
      'senderId': currentUser.uid,
      'senderName': currentUser.displayName ?? currentUser.email?.split('@')[0] ?? 'User',
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final docRef = _firestore.collection('chats').doc(roomId.trim());
    await docRef.collection('messages').add(msgData);

    final updateData = <String, dynamic>{
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderId': currentUser.uid,
    };

    try {
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        final data = docSnap.data();
        final participants = List<dynamic>.from(data?['participants'] ?? []);
        for (final p in participants) {
          if (p is String && p != currentUser.uid) {
            updateData['unreadCount_$p'] = FieldValue.increment(1);
          }
        }
      }
    } catch (_) {}

    await docRef.set(updateData, SetOptions(merge: true));
  }

  // Mark chat as read for current user
  Future<void> markChatAsRead(String roomId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || roomId.trim().isEmpty) return;
    try {
      await _firestore.collection('chats').doc(roomId.trim()).update({
        'unreadCount_${currentUser.uid}': 0,
      });
    } catch (_) {}
  }

  // Stream total unread messages count across all chats
  Stream<int> getTotalUnreadCountStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value(0);

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .snapshots()
        .map((snapshot) {
      int total = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final count = data['unreadCount_${currentUser.uid}'];
        if (count is int && count > 0) {
          total += count;
        }
      }
      return total;
    });
  }

  // Stream for chat rooms where user is participant
  Stream<QuerySnapshot> getUserChatsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .snapshots();
  }

  // Stream for messages in a specific room
  Stream<QuerySnapshot> getMessagesStream(String roomId) {
    if (roomId.trim().isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection('chats')
        .doc(roomId.trim())
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

final chatService = ChatService();
