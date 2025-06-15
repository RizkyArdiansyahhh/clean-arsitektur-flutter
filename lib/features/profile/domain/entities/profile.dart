import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int id;
  final String email;
  final String name;
  final String imageUrl;

  const Profile({
    required this.id,
    required this.email,
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, email, name, imageUrl];
}
