import 'package:flutter/material.dart';
import 'package:happy_chat/screens/chat_screen/chat_tab.dart';
import 'package:happy_chat/screens/chat_screen/member_tab.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [ChatTab(), MemberTab()];
  final int _onlineMembersCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แฮปปี้แชท'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'แชท',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'สมาชิกออนไลน์',
          ),
        ],
      ),
    );
  }
}
