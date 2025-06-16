import '../models/profile_model.dart';
import 'package:hive/hive.dart';

abstract class ProfileLocalDatasource {
  Future<ProfileModel> getUser(int id);
  Future<List<ProfileModel>> getAllUser(int page);
}

class ProfileLocalDatasourceImplementation implements ProfileLocalDatasource {
  final HiveInterface hive;
  const ProfileLocalDatasourceImplementation({required this.hive});
  @override
  Future<List<ProfileModel>> getAllUser(int page) {
    var box = hive.box("profile_box");
    return box.get("getAllUser");
  }

  @override
  Future<ProfileModel> getUser(int id) {
    var box = hive.box("profile_box");
    return box.get("getUser");
  }
}
