import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  // In a real app, these would come from your auth/feed providers
  final bool isLoggedIn = false; // TODO: Replace with actual auth state
  final List<Post> publicPosts = [
    // TODO: Replace with actual feed data
    Post(
      username: 'alice',
      description: 'A beautiful day! #sunshine',
      mediaUrl: 'https://placekitten.com/400/300',
      isVideo: false,
    ),
    Post(
      username: 'bob',
      description: 'Check out this video! #fun',
      mediaUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      isVideo: true,
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
        actions: [
          if (!isLoggedIn) ...[
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(S.of(context).login, style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(S.of(context).register, style: TextStyle(color: Colors.white)),
            ),
          ]
        ],
      ),
      body: publicPosts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: publicPosts.length,
              itemBuilder: (context, index) {
                final post = publicPosts[index];
                return PostCard(post: post);
              },
            ),
    );
  }
}

class Post {
  final String username;
  final String description;
  final String mediaUrl;
  final bool isVideo;

  Post({
    required this.username,
    required this.description,
    required this.mediaUrl,
    required this.isVideo,
  });
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(post.username),
          ),
          post.isVideo
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(child: Icon(Icons.videocam)),
                  // Replace with actual video player
                )
              : Image.network(post.mediaUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.description),
          ),
        ],
      ),
    );
  }
}
