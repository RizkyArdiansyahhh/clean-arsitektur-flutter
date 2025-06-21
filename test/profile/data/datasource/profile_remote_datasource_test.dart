import 'package:clean_arsitektur/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:clean_arsitektur/features/profile/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<ProfileRemoteDatasource>()])
import 'profile_remote_datasource_test.mocks.dart';

void main() {
  // Create mock object.
  var remoteDatasource = MockProfileRemoteDatasource();
  const int id = 1;
  const int page = 2;
  ProfileModel fakeProfileModel = const ProfileModel(
    id: 1,
    email: "Rizky@gmail.com",
    firstName: "Rizky",
    lastName: "1",
    avatar: "https://image.com/1",
  );

  group("Profile Remote Datasource", () {
    group("getUser()", () {
      test("should return ProfileModel if success", () async {
        when(
          remoteDatasource.getUser(id),
        ).thenAnswer((_) async => fakeProfileModel);

        final response = await remoteDatasource.getUser(id);
        expect(response, fakeProfileModel);
      });

      test("should throw exception if failed", () async {
        when(remoteDatasource.getUser(id)).thenThrow(Exception());

        expect(
          () async => await remoteDatasource.getUser(id),
          throwsA(isA<Exception>()),
        );
      });
    });
    group("getAllUser()", () {
      test("should return ProfileModel if success", () async {
        when(
          remoteDatasource.getAllUser(1),
        ).thenAnswer((_) async => [fakeProfileModel]);

        final response = await remoteDatasource.getAllUser(1);
        expect(response, [fakeProfileModel]);
      });

      test("should throw exception if failed", () async {
        when(remoteDatasource.getUser(1)).thenThrow(Exception());

        expect(
          () async => await remoteDatasource.getUser(1),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
