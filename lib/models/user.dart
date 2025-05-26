import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
abstract class HackerUser with _$HackerUser {
  factory HackerUser({
    required String id,
    int? created,
    String? about,
    List<int>? submitted,
  }) = _HackerUser;

  factory HackerUser.fromJson(Map<String, dynamic> json) =>
      _$HackerUserFromJson(json);
}
