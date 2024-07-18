import 'package:dio/dio.dart';
import 'package:flutter_wadiz_riverpod/model/login/login_model.dart';
import 'package:flutter_wadiz_riverpod/shared/model/response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api.g.dart';

@RestApi(baseUrl: 'http://localhost:3000/api/v1')
abstract class LoginApiClient {
  factory LoginApiClient(Dio dio, {String baseUrl}) = _LoginApiClient;

  @POST("/signup")
  Future<ResponseModel> signUp(
    @Body() LoginModel body,
  );

  @GET("/checkauth")
  Future<ResponseModel> checkEmail(
    @Body() LoginModel body,
  );
}
