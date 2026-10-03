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
      'senderName': currentUser.displayName ?? 'User',
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('chats').doc(roomId.trim()).collection('messages').add(msgData);

    await _firestore.collection('chats').doc(roomId.trim()).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
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
