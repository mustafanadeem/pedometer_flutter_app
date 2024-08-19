import "package:flutter/material.dart";

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070707),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Ensures the column takes up minimum vertical space
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(20),
              ),
              child: Container(
                color: Color(0xff1A1B22), // Use Container's color directly
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures the container only takes up needed space
                  children: [
                    buildListTile(Icons.ads_click, 'Step Goal', null),
                    buildListTile(Icons.notifications, 'Reminder', '9:00 AM'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, String? trailing) {
    return Material(
      color: Colors.transparent, // Make the Material widget transparent
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: trailing != null
            ? Text(
                trailing,
                style: TextStyle(color: Colors.blue),
              )
            : null,
        onTap: () {
          // Handle the onTap if needed
        },
      ),
    );
  }
}
