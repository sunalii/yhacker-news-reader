import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/story.dart';
import '../../models/user.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('topstories.json')
  Future<List<int>> getTopStories();

  @GET('item/{id}.json')
  Future<Story> getStory(@Path("id") int id);

  @GET('user/{username}.json')
  Future<HackerUser> getUser(@Path("username") String username);
}
