// File: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_provider.dart';
import '../widgets/story_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topStoriesAsync = ref.watch(storyIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YHacker',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple.shade50,
        foregroundColor: Colors.deepPurple.shade800,
        elevation: 0.5,
      ),
      body: topStoriesAsync.when(
        data: (topStoryIds) => ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '⭐ Top Stories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...topStoryIds
                .take(10)
                .map(
                  (storyId) => StoryTile(storyId: storyId, isTopStory: true),
                ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(
                '📰 All News',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...topStoryIds.map((storyId) => StoryTile(storyId: storyId)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
