import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../providers/story_provider.dart';
import '../utils/time_utils.dart';

class UserDetailScreen extends ConsumerWidget {
  final String username;

  const UserDetailScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(username));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple.shade50,
        foregroundColor: Colors.deepPurple.shade800,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey.shade100,
      body: userAsync.when(
        data: (user) => _buildUserInfo(context, ref, user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref, HackerUser user) {
    final submitted = user.submitted?.take(20).toList() ?? [];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Author Name:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user.id, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                if (user.created != null)
                  Text('Created: ${formatUnixTime(user.created!)}'),
                const SizedBox(height: 12),
                if (user.about != null)
                  Text(
                    user.about!.replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: const TextStyle(height: 1.4),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Recent Posts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...submitted.map(
          (id) => Consumer(
            builder: (context, ref, _) {
              final story = ref.watch(storyDetailProvider(id));
              return story.when(
                data: (s) {
                  if (s.title.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Card(
                      color: Colors.deepPurple.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          s.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(formatUnixTime(s.time)),
                        trailing: const Icon(Icons.open_in_new, size: 18),
                        onTap: () async {
                          if (s.url != null &&
                              await canLaunchUrl(Uri.parse(s.url!))) {
                            launchUrl(Uri.parse(s.url!));
                          }
                        },
                      ),
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: LinearProgressIndicator()),
                ),
                error: (err, stack) => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ],
    );
  }
}
