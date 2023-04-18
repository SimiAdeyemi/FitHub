import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'Messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



//void main() => runApp(ChatBot()); //- For Testing, to be deleted

class ChatBot extends StatelessWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitBot',
      theme: ThemeData(brightness: Brightness.dark),
      home: Home(),
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> conversationList = [];
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    _fetchConversations(); // fetch conversations from Cloud Firestore
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
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
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  color: Colors.green,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                        icon: Icon(Icons.send),
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
                    SizedBox(width: 48), // This is a placeholder to balance the row
                    IconButton(
                      onPressed: () {
                        _createNewConversation();
                      },
                      icon: Icon(Icons.add),
                      color: Colors.green,
                      tooltip: 'New Conversation',
                    ),
                    IconButton(
                      onPressed: () {
                        _showHistory(context);
                      },
                      icon: Icon(Icons.more_horiz),
                      color: Colors.green,
                      tooltip: 'Conversation History',
                    ),
                    SizedBox(width: 48), // This is a placeholder to balance the row
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  //save conversation to Firebase
  void _saveConversation(int conversationIndex) {
    String userId = _auth.currentUser!.uid;
    _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationIndex.toString())
        .set(conversationList[conversationIndex]);
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
        // Save the conversation to Firebase Realtime Database
        _saveConversation(currentConversationIndex);
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
          title: Text('Conversations'),
          content: Container(
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
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Add null check before removing a conversation
                      String? conversationId = conversationList[index]['id'];
                      if (conversationId != null) {
                        _deleteConversationFromFirebase(conversationId);
                      }
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
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  //method that will remove conversatoin from databae
  void _deleteConversationFromFirebase(String conversationId) {
    String userId = _auth.currentUser!.uid;
    _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .delete();
  }

  void _displayConversation(BuildContext context, int conversationIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(conversationList[conversationIndex]['title']),
          content: Container(
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
                      Icon(Icons.chat_bubble_outline, color: Colors.grey),
                      SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(8),
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
                      SizedBox(width: 8),
                      Icon(Icons.person, color: Colors.grey),
                    ],
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  void _createNewConversation() {
    int newConversationIndex = conversationList.length;
    Map<String, dynamic> newConversation = {
      'title': 'Conversation ${newConversationIndex + 1}',
      'messages': [],
    };

    setState(() {
      messages.clear();
      conversationList.add(newConversation);
    });

    // Save the new conversation to Cloud Firestore
    _saveConversation(newConversationIndex);
  }


  void _fetchConversations() {
    String userId = _auth.currentUser!.uid;
    _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<Map<String, dynamic>> fetchedConversations = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> conversationData = doc.data() as Map<String, dynamic>;
        conversationData['id'] = doc.id; // Add the document ID to the conversation data
        fetchedConversations.add(conversationData);
      });
      setState(() {
        conversationList = fetchedConversations;
      });
    });
  }
}


