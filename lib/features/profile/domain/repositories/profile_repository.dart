import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<List<Profile>> getUsers(int page);
  Future<Profile> getUser(int id);
}
