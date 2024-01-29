import 'package:flutter/material.dart';

class MemberTab extends StatefulWidget {
  @override
  _MemberTabState createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> {
  final List<String> _members = [
    '+1234567890',
    '+1234567891',
    '+1234567892',
    // Add more mock phone numbers as needed
  ]; // Mockup member data

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _members.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(_members[index]),
        );
      },
    );
  }
}
