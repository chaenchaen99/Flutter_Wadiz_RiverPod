import 'package:dio/dio.dart';
import 'package:flutter_wadiz_riverpod/model/home/home_model.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api.g.dart';

@RestApi(baseUrl: "http://localhost:3000/api/v1")
abstract class HomeApi {
  factory HomeApi(Dio dio, {String baseUrl}) = _HomeApi;

  @GET("/home")
  Future<HomeModel> getHomeProjects();
}
