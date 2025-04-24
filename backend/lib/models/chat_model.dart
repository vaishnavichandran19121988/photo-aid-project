class ChatMessage {
  final int id;
  final int sessionId;
  final int senderId;
  final int receiverId;
  final String message;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.sentAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      sessionId: map['session_id'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      message: map['message'],
      sentAt: map['sent_at'],
    );
  }
}
