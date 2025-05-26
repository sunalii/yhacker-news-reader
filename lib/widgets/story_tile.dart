import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/story_provider.dart';
import '../utils/time_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryTile extends ConsumerWidget {
  final int storyId;
  final bool isTopStory;

  const StoryTile({super.key, required this.storyId, this.isTopStory = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyDetailProvider(storyId));

    return storyAsync.when(
      data: (story) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Material(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(12),
          elevation: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              if (story.url != null &&
                  await canLaunchUrl(Uri.parse(story.url!))) {
                launchUrl(Uri.parse(story.url!));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (story.url != null && story.url!.contains(".jpg"))
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        story.url!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          story.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isTopStory)
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/user/${story.by}'),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'View Author ${story.by}',
                              style: TextStyle(
                                color: Colors.purple.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatUnixTime(story.time),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LinearProgressIndicator(),
      ),
      error: (err, stack) => ListTile(title: Text('Error: $err')),
    );
  }
}
