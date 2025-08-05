import 'package:flutter/material.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text,
      sender: 'Me',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    // Simulate a bot response
    final botMessage = ChatMessage(
      text: '''以下是今日的美国新闻摘要：

- **股市动态**: 尽管周一股市反弹，但银行股在8月至9月的季节性疲软期可能继续承压。市场对美国经济健康状况感到担忧，特别是上周五公布的疲弱就业数据之后。
- **欧美关系**: 欧盟宣布将对美国商品的报复性关税推迟六个月生效，以便继续与美国进行协商。
- **贸易政策**: 美国总统特朗普的贸易和关税政策持续引发市场波动。
- **国内政治**: 德克萨斯州民主党议员为阻止州内选区重划而离开该州，以阻挠投票。
- **科研动态**: 特朗普政府要求NASA制定计划，终止至少两个监测大气二氧化碳的卫星任务。
- **就业市场**: 就业市场数据显示劳动力市场显著放缓，影响了投资者的情绪。''',
      sender: 'Bot',
      timestamp: DateTime.now().add(const Duration(seconds: 1)),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    final bool isMe = message.sender == 'Me';
    final alignment = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAlignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    final avatar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(child: Text(message.sender[0])),
    );

    final messageBody = Flexible(
      child: Column(
        crossAxisAlignment: crossAlignment,
        children: <Widget>[
          Text(message.sender, style: Theme.of(context).textTheme.titleMedium),
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMe ? [messageBody, avatar] : [avatar, messageBody],
      ),
    );
  }
}
