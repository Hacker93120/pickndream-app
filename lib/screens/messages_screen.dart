import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildMessageCard(
            'Support PicknDream',
            'Bienvenue ! Comment pouvons-nous vous aider ?',
            '10:30',
            true,
          ),
          _buildMessageCard(
            'Hôtel Le Grand Paris',
            'Votre réservation est confirmée',
            'Hier',
            false,
          ),
          _buildMessageCard(
            'Service Client',
            'Merci pour votre avis !',
            '2 jours',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(String sender, String message, String time, bool unread) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade600,
          child: Icon(Icons.message, color: Colors.white),
        ),
        title: Text(
          sender,
          style: TextStyle(
            fontWeight: unread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: TextStyle(fontSize: 12)),
            if (unread) 
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () {
          // Ouvrir la conversation
        },
      ),
    );
  }
}
