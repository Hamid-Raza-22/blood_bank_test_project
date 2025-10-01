import 'package:flutter/material.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import 'dummy_chat_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});





  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final Color primaryRed = const Color(0xFF8B0000);

    final List<Map<String, String>> chats = [
      {
        "image": "assets/user1.png",
        "name": "Ali Khan",
        "message": "Hey! Are you available for blood donation?",
        "time": "10:15 AM"
      },
      {
        "image": "assets/user2.png",
        "name": "Sara Ahmed",
        "message": "I have A+ blood available",
        "time": "11:30 AM"
      },
      {
        "image": "assets/user3.png",
        "name": "Usman Ali",
        "message": "Can we meet at the hospital?",
        "time": "12:20 PM"
      },
      {
        "image": "assets/user4.png",
        "name": "Hina Malik",
        "message": "Donation completed successfully",
        "time": "1:45 PM"
      },
    ];

    // Reusable chat item widget (clickable)
    Widget chatItem(Map<String, String> chatData) {
      return GestureDetector(
        onTap: () {
          // Navigate to ChatDetailScreen with user name and image
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                name: chatData["name"]!,
                image: chatData["image"]!,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockHeight * 1.5,
              horizontal: SizeConfig.blockWidth * 3),
          margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 0.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.blockWidth * 6,
                backgroundImage: AssetImage(chatData["image"]!),
              ),
              SizedBox(width: SizeConfig.blockWidth * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatData["name"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockWidth * 4,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 0.5),
                    Text(
                      chatData["message"]!,
                      style: TextStyle(
                        fontSize: SizeConfig.blockWidth * 3.8,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                chatData["time"]!,
                style: TextStyle(
                  fontSize: SizeConfig.blockWidth * 3.5,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Custom search field
    Widget chatSearchField() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search chats...",
            hintStyle: TextStyle(fontSize: SizeConfig.blockWidth * 3.8),
            border: InputBorder.none,
            icon: Icon(
              Icons.search,
              color: Colors.grey[600],
              size: SizeConfig.blockWidth * 6,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
        child: Column(
          children: [
            chatSearchField(),
            SizedBox(height: SizeConfig.blockHeight * 2),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return chatItem(chats[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryRed,
        shape: CircleBorder(),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}


