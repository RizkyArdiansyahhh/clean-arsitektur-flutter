import 'dart:convert';

import 'package:clean_arsitektur/core/error/exception.dart';
import 'package:clean_arsitektur/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:clean_arsitektur/features/profile/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([
  MockSpec<ProfileRemoteDatasource>(),
  MockSpec<http.Client>(),
])
import 'profile_remote_datasource_test.mocks.dart';

void main() {
  MockClient fakeClient = MockClient();
  // Create mock object.
  var remoteDatasource = MockProfileRemoteDatasource();
  var remoteDatasourceImplementation = ProfileRemoteDatasourceImplementation(
    client: fakeClient,
  );

  const int id = 1;
  const int page = 2;
  final Uri urlGetAllUser = Uri.parse("https://reqres.in/api/users?page=$page");
  final Uri urlGetUser = Uri.parse("https://reqres.in/api/users/$id");

  Map<String, dynamic> fakeJson = {
    "id": 1,
    "email": "Rizky@gmail.com",
    "first_name": "Rizky",
    "last_name": "1",
    "avatar": "https://image.com/1",
  };

  ProfileModel fakeProfileModel = ProfileModel.fromJson(fakeJson);

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

  group("Profile Remote Datasource Implementation", () {
    group("getUser()", () {
      test("should return json if success", () async {
        // stubbing
        when(fakeClient.get(urlGetUser)).thenAnswer(
          (_) async => http.Response(jsonEncode({"data": fakeJson}), 200),
        );

        final response = await remoteDatasourceImplementation.getUser(id);
        expect(response, fakeProfileModel);
        print(response);
      });

      test("should throw EmptyException if empty data", () async {
        when(
          fakeClient.get(urlGetAllUser),
        ).thenAnswer((_) async => http.Response(jsonEncode({"data": []}), 200));

        expect(
          () async => await remoteDatasourceImplementation.getAllUser(page),
          throwsA(isA<EmptyException>()),
        );
      });
      test("should throw StausCodeException if statusCode 404 ", () async {
        when(
          fakeClient.get(urlGetUser),
        ).thenAnswer((_) async => http.Response(jsonEncode({}), 404));

        expect(
          () async => await remoteDatasourceImplementation.getUser(id),
          throwsA(isA<StatusCodeException>()),
        );
      });
      test("should throw generalException if statusCode 500", () async {
        when(
          fakeClient.get(urlGetUser),
        ).thenAnswer((_) async => http.Response("Internal Server Error", 500));

        expect(
          () async => await remoteDatasourceImplementation.getUser(id),
          throwsA(isA<GeneralException>()),
        );
      });
    });
    group("getAllUser()", () {
      test("should return json if success ", () async {
        when(fakeClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              "data": [fakeJson],
            }),
            200,
          ),
        );
        final response = await remoteDatasourceImplementation.getAllUser(page);
        expect(response, [fakeProfileModel]);
      });
      test("should throw EmptyException if statusCode 404", () async {
        when(
          fakeClient.get(urlGetAllUser),
        ).thenAnswer((_) async => http.Response(jsonEncode({}), 404));

        expect(
          () async => await remoteDatasourceImplementation.getAllUser(page),
          throwsA(isA<EmptyException>()),
        );
      });
      test("should throw GeneralException if statusCode 500", () async {
        when(
          fakeClient.get(urlGetAllUser),
        ).thenAnswer((_) async => http.Response("Internal Server Error", 500));

        expect(
          () async => remoteDatasourceImplementation.getAllUser(page),
          throwsA(isA<GeneralException>()),
        );
      });
    });
  });
}
