import 'package:dio/dio.dart';
import 'package:garimpoo/model/Product.dart';
import 'package:garimpoo/model/ProductNotification.dart';
import 'package:garimpoo/model/User.dart';
import 'package:retrofit/retrofit.dart';

import '../model/Filter.dart';

part 'client_repository.g.dart';

@RestApi(baseUrl: "https://www.garimpoo.app/api/")
//@RestApi(baseUrl: "http://192.168.0.134:5000/api/")
abstract class ClientRepository {
  factory ClientRepository(Dio dio, {String baseUrl}) = _ClientRepository;

  @GET("/notification/")
  Future<List<ProductNotification>> getAllNotifications(@Header("X-Firebase-Auth") String token);

  @GET("/product/")
  Future<ProductResponse> getAll(@Header("X-Firebase-Auth") String token);

  @GET("/product/{offset}")
  Future<ProductResponse> getPage(@Header("X-Firebase-Auth") String token, @Path("offset") int page);

  @POST("/product-discard/")
  Future<ProductResponse> discardProducts(@Header("X-Firebase-Auth") String token, @Body() body);

  @PUT("/product-discard/")
  Future discardAllProducts(@Header("X-Firebase-Auth") String token);

  @PUT("/user/")
  Future<User> signIn(@Header("X-Firebase-Auth") String uid, @Body() body);

  @POST("/user/")
  Future<User> signUp(@Header("X-Firebase-Auth") String uid, @Body() body);


  @PUT("/filter/")
  Future<Filter> updateFilter(@Header("X-Firebase-Auth") String uid, @Body() body);

  @GET("/filter/")
  Future<Filter> getFilter(@Header("X-Firebase-Auth") String token);

}