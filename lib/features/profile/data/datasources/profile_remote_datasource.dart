import 'dart:convert';

import 'package:clean_arsitektur/features/profile/data/models/profile_model.dart';
import 'package:clean_arsitektur/features/profile/domain/entities/profile.dart';
import 'package:http/http.dart' as http;

abstract class ProfileRemoteDatasource {
  Future<Profile> getUser(int id);
  Future<List<Profile>> getAllUser(int page);
}

class ProfileRemoteDatasourceImplementation implements ProfileRemoteDatasource {
  @override
  Future<List<Profile>> getAllUser(int page) async {
    // https://reqres.in/api/users?page=2
    final Uri url = Uri.parse("https://reqres.in/api/users?page=$page");
    final response = await http.get(url);
    Map<String, dynamic> dataBody = jsonDecode(response.body);
    List<Map<String, dynamic>> data = dataBody["data"];
    return ProfileModel.fromJsonList(data);
  }

  @override
  Future<Profile> getUser(int id) async {
    // https://reqres.in/api/users/2
    final Uri url = Uri.parse("https://reqres.in/api/users/2");
    final response = await http.get(url);
    Map<String, dynamic> dataBody = jsonDecode(response.body);
    Map<String, dynamic> data = dataBody["data"];
    return ProfileModel.fromJson(data);
  }
}
