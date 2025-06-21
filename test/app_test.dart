import 'package:clean_arsitektur/features/profile/data/datasources/profile_remote_datasource.dart';

void main() async {
  final ProfileRemoteDatasourceImplementation
  profileRemoteDatasourceImplementation =
      ProfileRemoteDatasourceImplementation();
  try {
    var response = await profileRemoteDatasourceImplementation.getAllUser(1000);
    for (var e in response) {
      print(e.toJson());
    }
  } catch (e) {
    print(e);
  }
}
