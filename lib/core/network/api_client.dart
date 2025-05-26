import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://hacker-news.firebaseio.com/v0/',
    responseType: ResponseType.json,
  ),
);
