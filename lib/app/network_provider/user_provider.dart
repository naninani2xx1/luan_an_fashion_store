import 'dart:convert';

import 'package:flutter_fashion/app/blocs/change_password/change_password_cubit.dart';
import 'package:flutter_fashion/app/models/user/user_model.dart';
import 'package:flutter_fashion/core/base/api/api.dart';
import 'package:flutter_fashion/core/base/api/endpoint.dart';
import 'package:flutter_fashion/core/base/exception/exception.dart';
import 'package:flutter_fashion/core/models/response_data.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/constant.dart';
import '../blocs/edit_information/edit_information_cubit.dart';

abstract class UserProvider {
  Future<UserModel> me();

  Future<UserModel> update(
      {required EditInformationState param, XFile? imageFile});

  Future<ResponseData> changePassword({required ChangePasswordState param});
}

class UserProviderImpl extends UserProvider {
  final ApiService _apiService;

  UserProviderImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<UserModel> me() async {
    var response = await _apiService.post(ApiEndpoint.me);

    final data = await response.stream.bytesToString();

    if (response.statusCode == 401) {
      _apiService.clearHeader();
      throw AuthenticatedException();
    } else {
      if (response.statusCode != 200) {
        throw ServerException();
      }
    }

    return UserModel.fromJson(jsonDecode(data)["data"]);
  }

  @override
  Future<UserModel> update(
      {required EditInformationState param, XFile? imageFile}) async {
    var response = await _apiService.post(
      ApiEndpoint.update,
      body: param.toJson(),
      image: imageFile,
    );
    final data = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 401) {
      //404 status unauthories token expired
      _apiService.clearHeader();
      throw AuthenticatedException();
    } else if (response.statusCode == 201) {
      throw Exception(data["error"]);
    } else {
      if (response.statusCode != 200) {
        throw ServerException();
      }
    }

    return UserModel.fromJson(data["data"]);
  }

  @override
  Future<ResponseData> changePassword(
      {required ChangePasswordState param}) async {
    var response = await _apiService.post(
      ApiEndpoint.changePassword,
      body: param.toJson(),
    );
    final data = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode != 200) {
      throw ServerException();
    }
    if (data["message"] == messagePasswordIncorrect) {
      return ResponseData.fromJson(data).copyWith.call(status: false);
    }

    return ResponseData.fromJson(data);
  }
}
