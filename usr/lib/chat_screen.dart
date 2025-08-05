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
      text: '''以下是今日的印尼新闻摘要：

- **能源建设**: 印尼计划在靠近新加坡的Pemping岛建设一座日产50万桶的炼油厂，以加强能源供应。
- **可再生能源**: 政府正大力推动可再生能源发电，并计划为尚未通电的家庭提供电力。
- **体育**: 印尼足协主席呼吁球迷在体育赛事中避免对中国球迷采取过激行为。
- **天气预警**: 气象局警告称，虽然旱季已经开始，但仍需警惕可能出现的极端天气。
- **反腐调查**: 总检察院将搜查Gojek和Tokopedia的办公室，此举与前教育部长纳迪姆·马卡里姆的案件有关。
- **国际外交**: 外交部长正在推动东盟与韩国之间建立创新经济伙伴关系。
- **国防军事**: 印尼正在考虑采购中国的歼-10战斗机，同时俄罗斯方面表示将与印尼海军举行联合演习以加强合作。
- **经济贸易**: 印尼已成为全球第四大乐器出口国，其首都雅加达的通勤火车也开始启用中国制造的新列车。同时，安息香的出口量持续增加。
- **农业问题**: 报告指出，印尼在化肥补贴方面的支出存在浪费问题。
- **社会**: 国防部长普拉博沃在宰牲节向全国捐赠了985头祭祀牛。''',
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
