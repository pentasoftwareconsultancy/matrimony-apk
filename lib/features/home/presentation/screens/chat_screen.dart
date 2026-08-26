import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/app_providers.dart';
import '../controllers/presence_provider.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String partnerId;
  final String name;
  final String avatarUrl;

  const ChatDetailScreen({
    super.key,
    required this.partnerId,
    required this.name,
    required this.avatarUrl,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() =>
      _ChatDetailScreenState();
}

class _ChatDetailScreenState
    extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();



  @override
  void initState() {
    super.initState();

    _scrollToBottom();

    Future.microtask(() {
      debugPrint(
        '[ChatPresence] Loading presence for ${widget.partnerId}',
      );

      ref
          .read(presenceProvider.notifier)
          .loadPresence(widget.partnerId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  void _sendMessage(
      ConversationItem conversation,
      ) {
    final text =
    _messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    ref
        .read(messageProvider.notifier)
        .sendMessage(
      conversation.partnerId,
      text,
    );

    _messageController.clear();



    _scrollToBottom();
  }

  // ============================================================
  // SCROLL TO BOTTOM
  // ============================================================

  void _scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController
              .position
              .maxScrollExtent,
          duration:
          const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ============================================================
  // LAST SEEN FORMATTER
  // ============================================================

  String _formatLastSeen(
      DateTime? lastSeenAt,
      ) {
    if (lastSeenAt == null) {
      return 'Offline';
    }

    final localTime =
    lastSeenAt.toLocal();

    final hour =
    localTime.hour % 12 == 0
        ? 12
        : localTime.hour % 12;

    final minute =
    localTime.minute
        .toString()
        .padLeft(2, '0');

    final period =
    localTime.hour >= 12
        ? 'PM'
        : 'AM';

    return 'Last seen $hour:$minute $period';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    // ==========================================================
    // MESSAGE STATE
    // ==========================================================

    final conversations =
    ref.watch(messageProvider);

    final conversation =
    conversations.firstWhere(
          (c) =>
      c.partnerId ==
          widget.partnerId,
      orElse: () => ConversationItem(
        partnerId: widget.partnerId,
        partnerName: widget.name,
        partnerAvatar: widget.avatarUrl,
        messages: [],
      ),
    );

    final messages =
        conversation.messages;

    // ==========================================================
    // PRESENCE STATE
    // ==========================================================

    final presenceState =
    ref.watch(presenceProvider);

    final presence =
    presenceState[widget.partnerId];

    final isOnline =
        presence?.isOnline ?? false;

    final lastSeenAt =
        presence?.lastSeenAt;

    // Scroll whenever messages change
    _scrollToBottom();

    // ==========================================================
    // UI
    // ==========================================================

    return Scaffold(
      backgroundColor:
      const Color(0xFFFFFDF9),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,

        iconTheme:
        const IconThemeData(
          color: Colors.black,
        ),

        title: Row(
          children: [
            // --------------------------------------------------
            // PROFILE IMAGE
            // --------------------------------------------------

            CircleAvatar(
              radius: 18,
              backgroundImage:
              NetworkImage(
                widget.avatarUrl,
              ),
            ),

            const SizedBox(width: 10),

            // --------------------------------------------------
            // NAME + PRESENCE
            // --------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style:
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight:
                      FontWeight.bold,
                    ),
                    overflow:
                    TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  Row(
                    children: [
                      // ----------------------------------------
                      // ONLINE/OFFLINE DOT
                      // ----------------------------------------

                      Container(
                        width: 6,
                        height: 6,
                        decoration:
                        BoxDecoration(
                          color: isOnline
                              ? Colors.green
                              : Colors.grey,
                          shape:
                          BoxShape.circle,
                        ),
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      // ----------------------------------------
                      // ONLINE / LAST SEEN
                      // ----------------------------------------

                      Text(
                        isOnline
                            ? 'Online'
                            : _formatLastSeen(
                          lastSeenAt,
                        ),
                        style:
                        const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
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

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // ====================================================
          // MESSAGE LIST
          // ====================================================

          Expanded(
            child: ListView.builder(
              controller:
              _scrollController,

              padding:
              const EdgeInsets.all(16),

              itemCount:
              messages.length,

              itemBuilder:
                  (context, index) {
                final msg =
                messages[index];

                final isMe =
                    msg.senderId ==
                        'me';

                final timeStr =
                    '${msg.timestamp.hour.toString().padLeft(2, '0')}:'
                    '${msg.timestamp.minute.toString().padLeft(2, '0')}';

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: Container(
                    margin:
                    const EdgeInsets
                        .symmetric(
                      vertical: 4,
                    ),

                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    constraints:
                    BoxConstraints(
                      maxWidth:
                      MediaQuery.of(
                        context,
                      ).size.width *
                          0.75,
                    ),

                    decoration:
                    BoxDecoration(
                      color: isMe
                          ? AppColors.primary
                          : Colors.white,

                      borderRadius:
                      BorderRadius.only(
                        topLeft:
                        const Radius.circular(
                          16,
                        ),
                        topRight:
                        const Radius.circular(
                          16,
                        ),
                        bottomLeft: isMe
                            ? const Radius.circular(
                          16,
                        )
                            : const Radius.circular(
                          0,
                        ),
                        bottomRight: isMe
                            ? const Radius.circular(
                          0,
                        )
                            : const Radius.circular(
                          16,
                        ),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(
                            0.02,
                          ),
                          blurRadius: 4,
                          offset:
                          const Offset(
                            0,
                            1,
                          ),
                        ),
                      ],

                      border: isMe
                          ? null
                          : Border.all(
                        color:
                        Colors.grey.shade200,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                      isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment
                          .start,

                      children: [
                        // --------------------------------------
                        // MESSAGE TEXT
                        // --------------------------------------

                        Text(
                          msg.text,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        // --------------------------------------
                        // TIME
                        // --------------------------------------

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              timeStr,
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white60
                                    : Colors.grey.shade400,
                                fontSize: 8,
                              ),
                            ),

                            _buildMessageTicks(msg),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ====================================================
          // TYPING INDICATOR
          // ====================================================



          // ====================================================
          // INPUT BAR
          // ====================================================

          Container(
            padding:
            const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              24,
            ),

            color: Colors.white,

            child: Row(
              children: [
                // ------------------------------------------------
                // TEXT FIELD
                // ------------------------------------------------

                Expanded(
                  child: Container(
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.grey.shade50,

                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),

                      border: Border.all(
                        color:
                        Colors.grey.shade200,
                      ),
                    ),

                    child: TextField(
                      controller:
                      _messageController,

                      decoration:
                      const InputDecoration(
                        hintText:
                        'Type a message...',

                        hintStyle:
                        TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),

                        contentPadding:
                        EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),

                        border:
                        InputBorder.none,
                      ),

                      onSubmitted: (_) =>
                          _sendMessage(
                            conversation,
                          ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                // ------------------------------------------------
                // SEND BUTTON
                // ------------------------------------------------

                GestureDetector(
                  onTap: () =>
                      _sendMessage(
                        conversation,
                      ),

                  child: Container(
                    padding:
                    const EdgeInsets.all(
                      12,
                    ),

                    decoration:
                    const BoxDecoration(
                      color:
                      AppColors.primary,
                      shape:
                      BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMessageTicks(MessageItem msg) {
    if (msg.senderId != 'me') {
      return const SizedBox.shrink();
    }

    switch (msg.status) {
      case 'read':
        return const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            '✓✓',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case 'delivered':
        return const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            '✓✓',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case 'sent':
      default:
        return const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            '✓',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}