import 'dart:convert';

import 'package:clean_arsitektur/core/error/exception.dart';
import 'package:clean_arsitektur/features/profile/data/models/profile_model.dart';
import 'package:http/http.dart' as http;

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getUser(int id);
  Future<List<ProfileModel>> getAllUser(int page);
}

class ProfileRemoteDatasourceImplementation implements ProfileRemoteDatasource {
  final http.Client client;

  const ProfileRemoteDatasourceImplementation({required this.client});
  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    // https://reqres.in/api/users?page=2
    final Uri url = Uri.parse("https://reqres.in/api/users?page=$page");
    final response = await client.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);
      List<dynamic> data = dataBody["data"];
      if (data.isEmpty) throw EmptyException(message: "Error Empty Data ");
      return ProfileModel.fromJsonList(data);
    } else if (response.statusCode == 404) {
      throw EmptyException(message: "Data Not Found - Error 404");
    } else {
      throw GeneralException(message: "Cannot get Data");
    }
  }

  @override
  Future<ProfileModel> getUser(int id) async {
    // https://reqres.in/api/users/2
    final Uri url = Uri.parse("https://reqres.in/api/users/$id");
    final response = await client.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);
      Map<String, dynamic> data = dataBody["data"];
      return ProfileModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw StatusCodeException(message: "Data Not Found - Error 404");
    } else {
      throw GeneralException(message: "cannot get data");
    }
  }
}
