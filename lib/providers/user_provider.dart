import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../models/user.dart';

final userProvider = FutureProvider.family<HackerUser, String>((ref, username) async {
  final api = ApiService(dio);
  return api.getUser(username);
});
