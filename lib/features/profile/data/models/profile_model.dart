import 'package:clean_arsitektur/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  final String firstName;
  final String lastName;
  final String avatar;

  const ProfileModel({
    required super.id,
    required super.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  }) : super(name: "$firstName $lastName", imageUrl: avatar);

  // Map -> ProfileModel
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["data"];
    return ProfileModel(
      id: data["id"],
      email: data["email"],
      firstName: data["first_name"],
      lastName: data["last_name"],
      avatar: data["avatar"],
    );
  }

  // ProfileModel -> Map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "avatar": avatar,
    };
  }
}
