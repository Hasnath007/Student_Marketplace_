import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/theme/app_theme.dart';

class DynamicChatDialog extends StatefulWidget {
  final String roomId;
  final String targetUserName;
  final String productTitle;
  final bool isSellerMode;

  const DynamicChatDialog({
    super.key,
    required this.roomId,
    required this.targetUserName,
    required this.productTitle,
    this.isSellerMode = false,
  });

  static Future<void> show(
    BuildContext context, {
    required String roomId,
    required String targetUserName,
    required String productTitle,
    bool isSellerMode = false,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => DynamicChatDialog(
        roomId: roomId,
        targetUserName: targetUserName,
        productTitle: productTitle,
        isSellerMode: isSellerMode,
      ),
    );
  }

  @override
  State<DynamicChatDialog> createState() => _DynamicChatDialogState();
}

class _DynamicChatDialogState extends State<DynamicChatDialog> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.roomId.trim().isNotEmpty) {
      chatService.markChatAsRead(widget.roomId);
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    _msgController.clear();
    await chatService.sendMessage(widget.roomId, clean);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 490,
        constraints: BoxConstraints(
          maxWidth: 490,
          maxHeight: (MediaQuery.of(context).size.height * 0.88).clamp(400.0, 640.0),
        ),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.borderColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1B4B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF4F46E5),
                    child: Text(
                      widget.targetUserName.isNotEmpty ? widget.targetUserName[0].toUpperCase() : 'S',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.targetUserName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.productTitle} • Chat',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 20),
                  ),
                ],
              ),
            ),

            // Context Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: context.isDarkMode ? const Color(0xFF1E1B4B).withValues(alpha: 0.5) : const Color(0xFFEEF2FF),
              child: Row(
                children: [
                  const Icon(Icons.storefront_rounded, size: 14, color: Color(0xFF4F46E5)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Live Chat for ${widget.productTitle}',
                      style: TextStyle(fontSize: 11, color: context.isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF3730A3), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // Messages Stream
            Expanded(
              child: Container(
                color: context.isDarkMode ? const Color(0xFF090A0E) : const Color(0xFFF8FAFC),
                child: StreamBuilder<QuerySnapshot>(
                  stream: chatService.getMessagesStream(widget.roomId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No messages yet. Say hi!', style: TextStyle(color: Colors.grey)),
                      );
                    }

                    final messages = snapshot.data!.docs;
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index].data() as Map<String, dynamic>;
                        final isMe = msg['senderId'] == currentUser?.uid;
                        final senderName = msg['senderName'] as String?;
                        final text = msg['text'] as String?;
                        
                        String timeStr = 'Just now';
                        if (msg['timestamp'] != null) {
                          final date = (msg['timestamp'] as Timestamp).toDate();
                          timeStr = '${date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour)}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
                        }

                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe ? const Color(0xFF2563EB) : context.containerBg,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 16),
                              ),
                              border: isMe ? null : Border.all(color: context.borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                if (!isMe && senderName != null) ...[
                                  Text(
                                    senderName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                ],
                                Text(
                                  text ?? '',
                                  style: TextStyle(
                                    color: isMe ? Colors.white : context.textPrimary,
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    color: isMe ? Colors.white70 : context.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            Divider(height: 1, color: context.borderColor),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: context.cardBg,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      style: TextStyle(fontSize: 13, color: context.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(fontSize: 13, color: context.textSecondary),
                        filled: true,
                        fillColor: context.containerBg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: context.borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: context.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F46E5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _sendMessage(_msgController.text),
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
