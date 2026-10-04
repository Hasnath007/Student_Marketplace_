import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/chat_service.dart';
import '../../chat/widgets/dynamic_chat_dialog.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openChat(Map<String, dynamic> chatData) {
    final isMeBuyer = chatData['buyerId'] == currentUser?.uid;
    final targetUserName = isMeBuyer ? chatData['sellerName'] : chatData['buyerName'];

    DynamicChatDialog.show(
      context,
      roomId: chatData['roomId'],
      targetUserName: targetUserName ?? 'User',
      productTitle: chatData['productTitle'] ?? 'Item',
      isSellerMode: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // Header & Tabs
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32, 28, 32, 16),
                      child: Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFF2563EB),
                      labelColor: const Color(0xFF2563EB),
                      unselectedLabelColor: const Color(0xFF64748B),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      tabs: const [
                        Tab(text: 'Buying'),
                        Tab(text: 'Selling'),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Chat Lists
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: chatService.getUserChatsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No messages yet', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16)),
                      );
                    }

                    final allChats = snapshot.data!.docs.map((d) => d.data() as Map<String, dynamic>).toList();
                    
                    // Sort chats locally by lastMessageTime to avoid Firestore composite index requirement
                    allChats.sort((a, b) {
                      final aTime = a['lastMessageTime'] as Timestamp?;
                      final bTime = b['lastMessageTime'] as Timestamp?;
                      if (aTime == null && bTime == null) return 0;
                      if (aTime == null) return 1;
                      if (bTime == null) return -1;
                      return bTime.compareTo(aTime); // Descending order
                    });

                    final buyingChats = allChats.where((c) => c['buyerId'] == currentUser?.uid).toList();
                    final sellingChats = allChats.where((c) => c['sellerId'] == currentUser?.uid).toList();

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildChatList(buyingChats, true),
                        _buildChatList(sellingChats, false),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(List<Map<String, dynamic>> chats, bool isBuyingTab) {
    if (chats.isEmpty) {
      return Center(
        child: Text(
          isBuyingTab ? 'No buying conversations yet' : 'No selling conversations yet',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final unread = 0; // Unread logic can be added later
        final targetUserName = isBuyingTab ? chat['sellerName'] : chat['buyerName'];
        final avatarColor = isBuyingTab ? const Color(0xFF4F46E5) : const Color(0xFF10B981);
        
        String timeStr = '';
        if (chat['lastMessageTime'] != null) {
          final date = (chat['lastMessageTime'] as Timestamp).toDate();
          timeStr = '${date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour)}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
        }
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openChat(chat),
              borderRadius: BorderRadius.circular(16),
              hoverColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: avatarColor,
                      child: Text(
                        targetUserName != null && targetUserName.isNotEmpty ? targetUserName[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Chat Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  targetUserName ?? 'User',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: unread > 0 ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                                  fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chat['productTitle'] ?? 'Product',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (chat['lastMessage'] == null || chat['lastMessage'].toString().isEmpty) 
                                ? 'Say hi to start the conversation!' 
                                : chat['lastMessage'],
                            style: TextStyle(
                              fontSize: 14,
                              color: unread > 0 ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                              fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}
