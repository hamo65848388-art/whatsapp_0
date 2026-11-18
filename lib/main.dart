import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181818),
        fontFamily: 'Roboto',
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  final List<Map<String, dynamic>> messages = [
    {
      'message': 'Hello!',
      'isMe': false,
      'time': '10:30',
    },
    {
      'message':
      'Hey! Have you ever thought about how random moments can sometimes turn into the best memories? It’s like the universe loves to surprise us when we least expect it!',
      'isMe': false,
      'time': '10:31',
    },
    {
      'message': 'Hello!',
      'isMe': true,
      'time': '10:32',
    },
    {
      'message': 'Top Learn',
      'isMe': true,
      'time': '10:33',
    },
  ];

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'message': text,
        'isMe': true,
        'time': TimeOfDay.now().format(context),
      });
    });

    messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),

      // ==============================
      // APP BAR
      // ==============================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF168C4B),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 0,

        title: Row(
          children: [
            // Leading icon
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 8),

            // Profile image
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(
                  Icons.person,
                  color: Color(0xFF168C4B),
                  size: 25,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Name
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Safwat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_outlined,
              size: 21,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.videocam_outlined,
              size: 23,
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              size: 23,
            ),
            onSelected: (_) {},
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text('Settings'),
                ),
              ];
            },
          ),
        ],
      ),

      // ==============================
      // BODY
      // ==============================
      body: Stack(
        children: [
          // WhatsApp-style dark background
          Positioned.fill(
            child: CustomPaint(
              painter: ChatBackgroundPainter(),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    12,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    final bool isMe =
                    message['isMe'] as bool;

                    return MessageBubble(
                      text: message['message'] as String,
                      time: message['time'] as String,
                      isMe: isMe,
                    );
                  },
                ),
              ),

              // ==============================
              // INPUT BAR
              // ==============================
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    10,
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      // Text form field
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF181818),
                            borderRadius:
                            BorderRadius.circular(30),
                            border: Border.all(
                              color:
                              const Color(0xFF168C4B),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Camera prefix icon
                              IconButton(
                                onPressed: () {},
                                splashRadius: 22,
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ),

                              // Text field
                              Expanded(
                                child: TextField(
                                  controller:
                                  messageController,
                                  onSubmitted: (_) =>
                                      sendMessage(),
                                  textInputAction:
                                  TextInputAction.send,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  decoration:
                                  const InputDecoration(
                                    border:
                                    InputBorder.none,
                                    hintText:
                                    'Type a Message ...',
                                    hintStyle:
                                    TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 12,
                                    ),
                                    contentPadding:
                                    EdgeInsets.zero,
                                  ),
                                ),
                              ),

                              // Send suffix icon
                              IconButton(
                                onPressed: sendMessage,
                                splashRadius: 22,
                                icon: const Icon(
                                  Icons.send_outlined,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Circular elevated microphone button
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFF168C4B),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// MESSAGE BUBBLE
// ======================================================

class MessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
      isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
          MediaQuery.of(context).size.width * 0.72,
        ),
        margin: EdgeInsets.only(
          bottom: 12,
          left: isMe ? 45 : 0,
          right: isMe ? 0 : 45,
        ),
        padding: const EdgeInsets.fromLTRB(
          12,
          9,
          10,
          7,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFF232D36)
              : const Color(0xFF168C4B),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
            Radius.circular(isMe ? 16 : 0),
            bottomRight:
            Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.18,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color:
                    Colors.white.withOpacity(0.65),
                    fontSize: 9,
                  ),
                ),

                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    color: Colors.white70,
                    size: 14,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// DARK WHATSAPP CHAT BACKGROUND
// ======================================================

class ChatBackgroundPainter extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFF181818);

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      backgroundPaint,
    );

    final iconPaint = Paint()
      ..color = const Color(0xFF252525)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    const double spacing = 58;

    for (double y = 15;
    y < size.height;
    y += spacing) {
      for (double x = 10;
      x < size.width;
      x += spacing) {
        final offset = ((y / spacing).floor() % 2 == 0)
            ? 0.0
            : spacing / 2;

        final center = Offset(
          x + offset,
          y,
        );

        _drawSmallBubble(
          canvas,
          center,
          iconPaint,
        );

        _drawSmallCircle(
          canvas,
          Offset(
            center.dx + 25,
            center.dy + 20,
          ),
          iconPaint,
        );

        _drawSmallCamera(
          canvas,
          Offset(
            center.dx - 15,
            center.dy + 30,
          ),
          iconPaint,
        );
      }
    }
  }

  void _drawSmallBubble(
      Canvas canvas,
      Offset center,
      Paint paint,
      ) {
    final rect = Rect.fromCenter(
      center: center,
      width: 18,
      height: 13,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(4),
      ),
      paint,
    );
  }

  void _drawSmallCircle(
      Canvas canvas,
      Offset center,
      Paint paint,
      ) {
    canvas.drawCircle(
      center,
      6,
      paint,
    );
  }

  void _drawSmallCamera(
      Canvas canvas,
      Offset center,
      Paint paint,
      ) {
    final rect = Rect.fromCenter(
      center: center,
      width: 14,
      height: 10,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(2),
      ),
      paint,
    );

    final lens = Offset(
      center.dx + 7,
      center.dy,
    );

    final path = Path()
      ..moveTo(
        lens.dx,
        lens.dy - 3,
      )
      ..lineTo(
        lens.dx + 4,
        lens.dy - 5,
      )
      ..lineTo(
        lens.dx + 4,
        lens.dy + 5,
      )
      ..lineTo(
        lens.dx,
        lens.dy + 3,
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}