import 'dart:io';

import 'package:bots_demo/data/hive/hive_setup.dart';
import 'package:bots_demo/data/local_data_source.dart';
import 'package:bots_demo/globals/exveptions/network_exceptions.dart';
import 'package:bots_demo/modal/api_response_status.dart';
import 'package:bots_demo/modal/login/request/login_request.dart';
import 'package:bots_demo/modal/user/user.dart';
import 'package:bots_demo/network/network_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationService {
  Future<User> saveAuth(User user);
  Future<User> getAuth();
  Future<void> logOut();
}

class AuthenticationRepository extends AuthenticationService {
  final LocalDataSource _localDataSource;
  // ignore: unused_field
  final BotsNetworkApi _networkApi;
  // ignore: unused_field

  AuthenticationRepository({
    @required LocalDataSource localDataSource,
    @required BotsNetworkApi networkApi,
  })  : assert(localDataSource != null),
        assert(networkApi != null),
        _networkApi = networkApi,
        _localDataSource = localDataSource;

  @override
  Future<User> saveAuth(User user) async {
    await _localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<User> getAuth() async {
    final auth = await _localDataSource.getUserFromLocal();
    return auth;
  }

  @override
  Future<void> logOut() async {
    await _localDataSource.logOut();
  }

  // ignore: missing_return
  Future<ApiResponseStatus<User>> loginWithCreds(LoginRequest creds) async {
    try {
      final response = await _networkApi.loginWithCreds(creds);
      if (response != null) {
        final user = User.fromJson(response.data["user"]);

        final data = user.copyWith(token: response.token);

        if (data.token != null) {
          await _localDataSource.cacheUser(data);
        }

        return ApiResponseStatus(
          data: data,
          isSuccessful: true,
          error: null,
        );
      } else {}
    } on DioError catch (error) {
      if (error != null &&
          error.response != null &&
          error.response.data != null &&
          error.response.data["error"] != null &&
          error.response.data["error"]["message"] != null) {
        return ApiResponseStatus(
            isSuccessful: false,
            error: NetworkExceptions.woocommerceLoginError(
                error.response.data["error"]["message"]));
      } else {
        return ApiResponseStatus(
            isSuccessful: false,
            error: NetworkExceptions.getDioException(error));
      }
    } on SocketException catch (error) {
      return ApiResponseStatus(
          isSuccessful: false, error: NetworkExceptions.getDioException(error));
    }
  }
}
