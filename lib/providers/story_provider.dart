import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../models/story.dart';

final storyIdsProvider = FutureProvider<List<int>>((ref) async {
  final api = ApiService(dio);
  return api.getTopStories();
});

final storyDetailProvider = FutureProvider.family<Story, int>((ref, id) async {
  final api = ApiService(dio);
  return api.getStory(id);
});
