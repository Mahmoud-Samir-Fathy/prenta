import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 25),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Notification'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.email, color: Colors.blue),
            ),
            title: Text('Email Notification'),
            subtitle: Text(dateFormat.format(today)),
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.message, color: Colors.green),
            ),
            title: Text('Message Notification'),
            subtitle: Text(dateFormat.format(today)),
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.warning, color: Colors.red),
            ),
            title: Text('Warning Notification'),
            subtitle: Text(dateFormat.format(yesterday)),
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.calendar_today, color: Colors.orange),
            ),
            title: Text('Event Notification'),
            subtitle: Text(dateFormat.format(yesterday)),
          ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.alarm, color: Colors.purple),
            ),
            title: Text('Alarm Notification'),
            subtitle: Text(dateFormat.format(today)),
          ),
        ],
      ),
    );
  }
}
