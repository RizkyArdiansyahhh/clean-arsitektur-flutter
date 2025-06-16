import 'package:clean_arsitektur/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:clean_arsitektur/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:clean_arsitektur/features/profile/data/models/profile_model.dart';
import 'package:hive/hive.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfileRepositoryImplementation extends ProfileRepository {
  final ProfileLocalDatasource profileLocalDatasource;
  final ProfileRemoteDatasource profileRemoteDatasource;
  final HiveInterface hive;

  ProfileRepositoryImplementation({
    required this.profileRemoteDatasource,
    required this.profileLocalDatasource,
    required this.hive,
  });
  @override
  Future<Either<Failure, List<Profile>>> getAllUser(int page) async {
    try {
      //CEK apakah ada konektifitas network
      final List<ConnectivityResult> connectivityResult = await (Connectivity()
          .checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        // No available network types
        List<ProfileModel> result = await profileLocalDatasource.getAllUser(
          page,
        );
        return right(result);
      } else {
        List<ProfileModel> result = await profileRemoteDatasource.getAllUser(
          page,
        );
        var box = hive.box("profile_box");
        box.put("getAllUser", result);
        return right(result);
      }
    } catch (e) {
      return left(Failure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getUser(int id) async {
    try {
      final List<ConnectivityResult> connectivityResult = await (Connectivity()
          .checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        ProfileModel result = await profileLocalDatasource.getUser(id);
        return right(result);
      } else {
        ProfileModel result = await profileRemoteDatasource.getUser(id);
        var box = hive.box("profile_box");
        box.put("getUser", result);
        return right(result);
      }
    } catch (e) {
      return left(Failure());
    }
  }
}
