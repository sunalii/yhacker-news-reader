import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';

part 'story.g.dart';

@freezed
abstract class Story with _$Story {
  factory Story({
    required int id,
    required String by,
    required int time,
    String? url,
    required String title,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
