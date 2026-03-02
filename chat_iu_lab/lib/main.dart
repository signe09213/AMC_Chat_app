
import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(const AntogramApp());
}

class Post {
  final String username;
  final String profileImageUrl;
  final String postImageUrl;
  final String caption;

  Post({
    required this.username,
    required this.profileImageUrl,
    required this.postImageUrl,
    required this.caption,
  });
}

class AntogramApp extends StatelessWidget {
  const AntogramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antogram',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const AntogramScreen(),
    );
  }
}

class AntogramScreen extends StatelessWidget {
  const AntogramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Post> posts = [
      Post(
        username: 'antonio',
        profileImageUrl: 'assets/images/1.jpg',
        postImageUrl: 'assets/images/1.jpg',
        caption: 'This is my first post on Antogram!',
      ),
      Post(
        username: 'flutter_dev',
        profileImageUrl: 'assets/images/2.jpg',
        postImageUrl: 'assets/images/2.jpg',
        caption: 'Loving the new Flutter update.',
      ),
      Post(
        username: 'creative_mind',
        profileImageUrl: 'assets/images/3.jpg',
        postImageUrl: 'assets/images/3.jpg',
        caption: 'Just finished a new design.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antogram'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(post.profileImageUrl),
                ),
                const SizedBox(width: 8.0),
                Text(
                  post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Image.asset(post.postImageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.caption),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
