import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'Messages.dart';

//void main() => runApp(ChatBot()); //- For Testing, to be deleted

class ChatBot extends StatelessWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitBot',
      theme: ThemeData(brightness: Brightness.dark),
      home: const Home(),
      debugShowCheckedModeBanner: false, // Add this line
    );
  }
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> conversationList = [];
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    _createNewConversation(); // an empty conversation when the app starts
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: MessagesScreen(messages: messages),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  color: Colors.green,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                          decoration: InputDecoration(
                            hintText: 'Ask about workouts, meal plans or injuries.',
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5), fontSize: 17),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          sendMessage(_controller.text);
                          _controller.clear();
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48), // This is a placeholder to balance the row
                    IconButton(
                      onPressed: () {
                        _createNewConversation();
                      },
                      icon: const Icon(Icons.add),
                      tooltip: 'New Conversation',
                    ),
                    IconButton(
                      onPressed: () {
                        _showHistory(context);
                      },
                      icon: const Icon(Icons.more_horiz),
                      tooltip: 'Conversation History',
                    ),
                    const SizedBox(width: 48), // This is a placeholder to balance the row
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
        // Add the message to the current conversation
        int currentConversationIndex = conversationList.length - 1;
        conversationList[currentConversationIndex]['messages'].add({
          'text': text,
          'isUserMessage': true,
        });
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
        // Add the bot's response to the current conversation
        int currentConversationIndex = conversationList.length - 1;
        conversationList[currentConversationIndex]['messages'].add({
          'text': response.message!.text!.text!.first,
          'isUserMessage': false,
        });
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
  void _showHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Conversations'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: conversationList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(conversationList[index]['title']),
                  onTap: () {
                    Navigator.of(context).pop();
                    _displayConversation(context, index);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        conversationList.removeAt(index);
                      });
                      Navigator.of(context).pop();
                      _showHistory(context);
                    },
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  void _displayConversation(BuildContext context, int conversationIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(conversationList[conversationIndex]['title']),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: conversationList[conversationIndex]['messages'].length,
              itemBuilder: (context, index) {
                final message = conversationList[conversationIndex]['messages'][index];
                final isUserMessage = message['isUserMessage'];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isUserMessage
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isUserMessage) ...[
                      const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isUserMessage ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (isUserMessage) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.person, color: Colors.grey),
                    ],
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  void _createNewConversation() {
    setState(() {
      messages.clear();
      conversationList.add({
        'title': 'Conversation ${conversationList.length + 1}',
        'messages': [],
      });
    });
  }
}


